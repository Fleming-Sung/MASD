function batchFit = simAbatch(particles, iter)
    model = evalin("base", "modelName");
    fullResults = evalin("base", "fullResults");
    batch = particles2Inputs(particles); % batch输入
    parsim_repmat = scenario_repmat(batch, model); % 为整个batch的并行仿真生成配置矩阵
    out = parsim(parsim_repmat, 'ShowProgress', 'off','ShowSimulationManager','off','TransferBaseWorkspaceVariables','on'); % 并行仿真batch
    
    % 存储ttc和距离序列
    batchTTC = zeros(size(batch,1), 1);
    batchTraj = cell(size(batch,1), 1);
    for rindex=1:size(batch, 1)
        logsout = out(rindex).logsout;
        [ttc, traj] = cal_ttc(logsout);

        batchTTC(rindex) = ttc;
        batchTraj{rindex} = traj;
    end

    batchFit = ttc2Fitness(batchTTC);

    fullResults{iter}.iter = iter;
    fullResults{iter}.ttc = batchTTC;
    fullResults{iter}.fit = batchFit;
    fullResults{iter}.traj = batchTraj;
    fullResults{iter}.simInputs = batch;
    fullResults{iter}.particles = particles;

    assignin("base", "fullResults", fullResults);
end

function fitList = ttc2Fitness(ttcList)
    fitList = - ones(size(ttcList)) ./ ttcList;
    % 当-1/ttc小于-5时，认为车辆已经发生碰撞
    for index = 1:size(fitList,1)
        if fitList(index) < -5
            fitList(index) = -5;
        end
    end
end