function [globalBest, globalBestFitness, localBest, localBestFitness] = NichePSO_gpt()

    %% 参数设置
    numParticles = 10; % 粒子数量
    numDimensions = 2; % 搜索空间维度
    maxIterations = 10; % 最大迭代次数
    numNiche = 5; % 生境数量
    nicheRadius = 0.1; % 生境半径
    socialWeight = 1.5; % 社会因子权重
    cognitiveWeight = 1.5; % 认知因子权重
    inertiaWeight = 0.5; % 惯性因子权重

    %% 粒子群初始化
    particles = rand(numParticles, numDimensions); % 粒子群的初始位置
    velocities = zeros(numParticles, numDimensions); % 粒子群的初始速度
    localBest = particles; % 记录每个粒子的个体最优位置
    localBestFitness = zeros(numParticles, 1); % 记录每个粒子的个体最优适应度
    globalBest = zeros(1, numDimensions); % 记录全局最优位置
    globalBestFitness = Inf; % 记录全局最优适应度

    %% 粒子群优化迭代
    for iteration = 1:maxIterations
        for i = 1:numParticles
            particle = particles(i, :); % 当前粒子位置

            % 计算当前粒子适应度
            fitness = optimal(particle);

            % 更新局部最优
            if fitness < localBestFitness(i)
                localBest(i, :) = particle;
                localBestFitness(i) = fitness;
            end

            % 更新全局最优
            if fitness < globalBestFitness
                globalBest = particle;
                globalBestFitness = fitness;
            end

            % 计算邻域粒子
            distance = zeros(numParticles, 1);
            for j = 1:numParticles
                distance(j) = norm(particles(j, :) - particle);
            end
            [~,sortedIndices] = sort(distance);

            % 应用小生境机制保持多样性
            nicheCount = ones(numParticles, 1);
            for j = 2:numParticles
                k = sortedIndices(j);
                if distance(k) <= nicheRadius
                    nicheCount(k) = nicheCount(k) + 1;
                end
            end

            % 更新粒子速度和位置
            velocity = inertiaWeight * velocities(i, :) ...
                       + cognitiveWeight * rand(1, numDimensions) .* (localBest(i, :) - particle) ...
                       + socialWeight * rand(1, numDimensions) .* (globalBest - particle / numNiche);
            particles(i, :) = particle + velocity;

            % 边界处理
            particles(i, :) = max(particles(i, :), 0);
            particles(i, :) = min(particles(i, :), 1);
        end
    end
end