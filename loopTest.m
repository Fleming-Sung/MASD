%% 十字路口场景下的循环测试
% 前置条件：交通灯设置为StaticGreen
% 原始scenario为TrafficLightNegotiationTestBench中自带的scenario
% 修改后的scenario中增加了一辆对向右转车辆，且改变了；ing外两个车辆的行驶轨迹
% 0829修改：暂时不计算ttc，调整了输出结果至包含自车和环境车的轨迹时间序列。
% 0903修改：输出ttc，更正了轨迹记录
addpath(genpath('TrafficLightNegotiation'))
clear
close all
bdclose('all')

dim =  [[3,18];
        [-30,30]]; % 倒序放置！
step = 10;
batchsize = 100;

% 打开模型并进行初始化
model = "TrafficLightNegotiationTestBench";
% open_system(model);
load_system(model);

% SLTrafficLightNegotiationSetup();
helperSLTrafficLightNegotiationSetup;
clear scenario;

series = test_space(dim, step);
results = cell(size(series, 1), 2);
minttc = ones(size(series, 1),1)*inf;
assignin("base","series",series);
% assignin("base","results");

% results = batchSim(series, batchsize, model);
% results = cell(size(series, 1), 2);
totalSimNum = size(series, 1);
num_batches = ceil(totalSimNum/batchsize);
% 遍历每一个batch
for batchID = 1:num_batches
    % 根据当前batchID计算起止索引（按行索引）
    if batchID == num_batches
        startLine = (batchID-1)*batchsize + 1;
        endLine = totalSimNum;
    else
        startLine = (batchID-1)*batchsize + 1;
        endLine = batchID * batchsize;
    end
    
    % 仿真一个batch
    [results,minttc] = simAbatch(startLine, endLine, minttc, results, model);
    disp("当前进度：");
    disp([batchID, "/", num_batches]);
end

save("minttclist.mat", "minttc");
save("loopTestInputMat.mat", "series");
save("looptestResults.mat", "results");

dim1 = series(:,2);
dim2 = series(:,1);
rtttc = ones(length(series),1)  ./ minttc;
scatter3(dim1, dim2, minttc)
figure(2)
scatter3(dim1, dim2, rtttc)

tableTTC = list2table(minttc, step);
tableRTTC = list2table(rtttc, step);
figure(3)
heatmap(tableTTC)
figure(5)
heatmap(tableRTTC)


function [results,minttc] = simAbatch(startLine, endLine, minttc, results, model)
    series = evalin("base", "series");
    batch = series(startLine:endLine, :); % batch输入
    parsim_repmat = scenario_repmat(batch, model); % 为整个batch的并行仿真生成配置矩阵
    out = parsim(parsim_repmat, 'ShowProgress', 'on','ShowSimulationManager','off','TransferBaseWorkspaceVariables','on'); % 并行仿真batch
    
    % 存储ttc和距离序列
    for rindex=1:size(batch, 1)
        logsout = out(rindex).logsout;
        [ttc, traj] = cal_ttc(logsout);
        results{(startLine - 1 + rindex), 1} = ttc;
        results{(startLine - 1 + rindex), 2} = traj;
        minttc(startLine - 1 + rindex) = ttc(1,4);
    end

%     % 直接存储模型信号
%     for rindex=1:size(batch, 1)
%         thisLine = startLine - 1 + rindex;
%         logsout = out(rindex).logsout;
%         results{thisLine, 1} = logsout;
%         results{thisLine, 2} = series(thisLine, :);
%     end
end