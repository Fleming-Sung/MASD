clear
close all
% filePath = '..\Results\NMO2d_012405\fullresults.mat';
filePath = '..\Results\NMO2d_012501\fullresults.mat';
% filePath = './dim2-0121-1.mat';
% filePath = './dim5.mat';

gateValue = -1; % 当fit>=gateValue时认为改样本是危险样本
radius = 0.1;
threshold = 0.2;

load(filePath);
% fullResults{1}

% maxIter = length(fullResults);
maxIter = 5;

adversarialSamples = [];

% 遍历每一次迭代
for i = 1:maxIter
    thisSimInputs = fullResults{i}.simInputs;
    thisParticles = fullResults{i}.particles;
    thisFit = fullResults{i}.fit;

    index = find(thisFit<=gateValue);

%     thisAdvSamples = thisSimInputs(index,:); % 原始特征尺度聚类；
    thisAdvSamples = thisParticles(index,:); % 标准化特征尺度（粒子）聚类

    adversarialSamples((end+1):(end+size(thisAdvSamples,1)),:) = ...
        thisAdvSamples(:,:);
end

% adversarialSamples = adversarialSamples(1:17*17, :);

%% 对数据进行聚类
% [idx] = kmeans(adversarialSamples, 4, "Distance","sqeuclidean");

% [idx] = kmedoids(adversarialSamples, 4);

% [idx] = spectralcluster(adversarialSamples, 4);
% idx = clusterdata(adversarialSamples,4);

% idx = dbscan(adversarialSamples, 1, 5);
[~, idx] = mean_shift_see(radius, threshold, adversarialSamples);
Num_m = max(idx)
% max(idx)

% gmm = fitgmdist(adversarialSamples, 4);
% idx = cluster(gmm, adversarialSamples);


%% 聚类结果可视化
figure(1)
hold on
for m = 1:Num_m
    color_seq = ["red", "green" ,"blue", "black"];
    mkr_seq = ["o", "+", "*", "square"];
    color_index = rem(m, size(color_seq, 2)) + 1;
    scatter(adversarialSamples(idx==m,1), adversarialSamples(idx==m,2), 60, color_seq(color_index),mkr_seq(color_index));
end
% scatter(adversarialSamples(idx==1,1), adversarialSamples(idx==1,2), 'red','filled');
% scatter(adversarialSamples(idx==2,1), adversarialSamples(idx==2,2), 'green', 'filled');
% scatter(adversarialSamples(idx==3,1), adversarialSamples(idx==3,2), 'blue', 'filled');
% scatter(adversarialSamples(idx==4,1), adversarialSamples(idx==4,2), 'yellow', 'filled');
hold off
% xlim([2,20])
% ylim([-16,16])
% xlabel("SFC - Km/h")
% ylabel("LC - m")

% 危险样本分布可视化
figure(2)
hold off
scatter(adversarialSamples(:,1), adversarialSamples(:,2), 60, 'filled');
% xlim([2,20])
% ylim([-16,16])
% xlabel("SFC - Km/h")
% ylabel("LC - m")