% Main progress of the MASS
% Author: Fleming
% Mail: ming.sang@siat.ac.cn

%% prepare for the progress begin
clear
close all
bdclose('all')
addpath(genpath('Simulation'));
addpath(genpath('Algorithm'));
modelName = "TrafficLightNegotiationTestBench";

% param
maxIteration = 10;

simDim =  [[3,18];
        [-30,30]]; % 倒序放置！
% step = 1000; % 每个维度进行离散化的步长
% batchsize = 100;

% 存储整个算法运行过程中的结果，用于回溯分析
% {[轨迹], [ttc;fit;iterIndex]}?
fullResults = cell(maxIteration, 1); 

% assignin("base", "simDim", simDim);
% assignin("base", "modelName", modelName);
% assignin("base", "fullResults", fullResults);

load_system(modelName);
helperSLTrafficLightNegotiationSetup;
clear scenario;

NichePSO_Cluster();

% 可视化最后一次迭代
% lastIterParticles = fullResults{maxIteration}.particles;
lastIterSimInputs = fullResults{maxIteration}.simInputs;
lastIterFit = - fullResults{maxIteration}.fit;
% scatter3(lastIterParticles(:,1), lastIterParticles(:,2), lastIterFit);
scatter3(lastIterSimInputs(:,1), lastIterSimInputs(:,2), lastIterFit);

% 可视化搜索过程