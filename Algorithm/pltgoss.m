clear
close all
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

% 绘制数据和拟合结果
x = linspace(0, 1, 100);
y = linspace(0, 1, 100);
[X, Y] = meshgrid(x, y);
XY = [X(:) Y(:)]; % 所有网格点的坐标
z = pdf(gmModel, XY); % 计算每个网格点的概率密度值
Z = reshape(z, size(X));

figure;
contour(X, Y, Z, 'LineWidth', 1.5); % 绘制等高线图
hold on;
% scatter(data(:, 1), data(:, 2), 'filled', 'MarkerFaceColor', 'r'); % 绘制样本点
hold off;
xlabel('X');
ylabel('Y');
title('二维高斯混合模型');


% 绘制每个分量的均值点
hold on;
scatter(gmModel.mu(:, 1), gmModel.mu(:, 2), 'Marker', 'x', 'MarkerEdgeColor', 'k', 'LineWidth', 2);
hold off;

figure(2);
surf(X,Y,Z);

figure(3);
heatmap(Z);


% % 绘制椭圆
% hold on;
% for i = 1:numComponents
%     plot_gaussian_ellipsoid(gmModel.mu(i, :), gmModel.Sigma(:, :, i));
% end
% hold off;