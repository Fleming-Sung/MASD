% 假设你有一个样本矩阵，每一行是一个样本的坐标
% 样本矩阵示例：samples = [x1, y1; x2, y2; ...];

close all
% 右下：0.57-0.71；0.2-0.65；
index = find( ...
    (0.75<adversarialSamples(:,1)) & ...
    (adversarialSamples(:,1)<0.85) & ...
    (0.2<adversarialSamples(:,2)) & ...
    (adversarialSamples(:,2)<0.6));
thisSamples = adversarialSamples(index, :);

% 计算凸包
k = convhull(thisSamples(:, 1), thisSamples(:, 2));

figure()
% 绘制原始样本散点图
scatter(thisSamples(:, 1), thisSamples(:, 2), 'filled');
hold on;


% 绘制凸包边界
plot(thisSamples(k, 1), thisSamples(k, 2), 'r-', 'LineWidth', 2);

% 添加图标题和标签
title('不规则边界检测');
xlabel('X轴');
ylabel('Y轴');

% 保持图形可读性
axis equal;
grid on;

% 显示图例
legend('原始样本', '凸包边界');

hold on;
for p = 1:length(k)
    pk = k(p);
    scatter(thisSamples(pk, 1), thisSamples(pk, 2), 100, 'square')
    pause(1)
end
hold off;