% 对比两种不同小生境算法的性能
clear
close all

% 生成一个高斯混合模型作为目标函数
gmModel = gausianModel();
assignin("base","gmModel",gmModel);

% 分别使用两种算法进行优化
[globalBest1, globalBestFitness1, localBest1, localBestFitness1] = NichePSO_Cluster();
[globalBest2, globalBestFitness2, localBest2, localBestFitness2] = NichePSO_gpt();

% 绘制数据图像
x = linspace(0, 1, 100);
y = linspace(0, 1, 100);
[X, Y] = meshgrid(x, y);
XY = [X(:) Y(:)]; % 所有网格点的坐标
z = pdf(gmModel, XY); % 计算每个网格点的概率密度值
Z = reshape(z, size(X));
figure(1);
title('普通N-PSO');
surf(X,Y,Z);
hold on
scatter3(localBest2(:,1), localBest2(:,2), -localBestFitness2, MarkerFaceColor="r");
hold off


figure(2);
title('聚类N-PSO');
surf(X,Y,Z);
hold on
scatter3(localBest1(:,1), localBest1(:,2), -localBestFitness1, MarkerFaceColor="r");
hold off



function gmModel = gausianModel()
% 生成高斯混合模型数据
rng(1); % 设置随机数种子
numSamples = 500; % 样本数量
numComponents = 2; % 混合模型分量数量

% 随机生成混合模型参数
mu = [0.2 0.8; 0.8 0.2]; % 每个分量的均值
sigma = repmat(0.02*eye(2), 1, 1, numComponents); % 每个分量的协方差矩阵
weights = rand(1, numComponents);
weights = weights / sum(weights); % 每个分量的权重

% 生成样本数据
data = [];
for i = 1:numComponents
    numSamplesComponent = round(numSamples * weights(i)); % 每个分量的样本数量
    dataComponent = mvnrnd(mu(i, :), sigma(:, :, i), numSamplesComponent);
    data = [data; dataComponent];
end

% 使用高斯混合模型进行拟合
gmModel = fitgmdist(data, numComponents);
end