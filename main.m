% Main progress of the MASS
% Author: Fleming
% Mail: ming.sang@siat.ac.cn

% prepare for the progress begin
clear
close all
bdclose('all')

algorithmTest = false;

addpath(genpath('Simulation'));
addpath(genpath('Algorithm'));
addpath(genpath('Utils'));
modelName = "TrafficLightNegotiationTestBench";
saveName = 'NMO2d_012502';

% param
maxIteration = 100;
clust_method = 1;
cutValue = -1;
% 聚类方法：
% 1 -- mean shift
% 2 -- dbscan
% 0 -- kmeans 未定义时执行此选项

% 各个维度的含义和范围如下
% xCar1     = param(1); % 前车cut in时的纵向坐标[-35,5]
% speedCar3 = param(2); % 右侧车辆车速[3,18]
% xCar2     = param(3); % 从左向右的车辆的纵坐标[-2.5,-6]
% speedCar1 = param(4);; % 前车车速[3,18]
% speedCar2 = param(5);; % 左侧车辆车速[3,18]
rowDim = [[-35,  5];
          [3,   18];
          [-2.6, 6];
          [3,   18];
          [3,   18]];

dimSort = [1,2]; % 参与测试的维度序号

dim =  rowDim(dimSort,:);

savePath = strcat('./Results/',saveName);
mkdir(savePath);
beginTime = datetime();
save(strcat(savePath,'/info.mat'));

% 存储整个算法运行过程中的结果，用于回溯分析
fullResults = cell(maxIteration, 1); 

if algorithmTest == true
    pltgoss;
    saveName = 'algorithmTest';
else  % 加载仿真模型
    load_system(modelName);
    helperSLTrafficLightNegotiationSetup;
    clear scenario;
end

NichePSO_Cluster(clust_method);

save(strcat(savePath,'/fullresults.mat'), "fullResults");
saveas(gcf,strcat(savePath,'/searchProcedure.png'))

finished = 1;
finishTime = datetime();
save(strcat(savePath,'/finishInfo.mat'),"finishTime","finished");