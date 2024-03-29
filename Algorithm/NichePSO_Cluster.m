function [globalBest, globalBestFitness, localBest, localBestFitness] = NichePSO_Cluster()
    % Niche-based multimodal adversarial scenarios searching for autonomous
    % driving test and validation
    %% 参数设置
    numParticles = 24; % 粒子数量
    numDimensions = 2; % 搜索空间维度
    maxIterations = evalin("base","maxIteration"); % 最大迭代次数
    numNiche = 5; % 生境数量
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
    for iteration = 1:maxIterations % 遍历算法的每次迭代
        disp("当前进度：");
        disp([iteration, "/", maxIterations]);
        particlesFitness = simAbatch(particles, iteration); % 并行仿真以求解当前种群的适应度
        for i = 1:numParticles % 遍历每一个粒子
            particle = particles(i, :); % 当前粒子位置

            % 计算当前粒子适应度
%             fitness = optimal(particle);
            fitness = particlesFitness(i);

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

            % 计算粒子之间的距离
            distance = pdist2(particles, particles);

            % 应用基于聚类的小生境划分
            [idx, ~] = kmeans(particles, numNiche, 'Distance', 'sqeuclidean', 'Start', 'uniform');

            for k = 1:numNiche
                nicheParticles = particles(idx == k, :);
                nicheFitness = localBestFitness(idx == k);
                nicheBestFitness = min(nicheFitness);

                % 更新粒子速度和位置
                dominationCount = zeros(size(nicheParticles, 1), 1);
                for j = 1:size(nicheParticles, 1)
                    velocity = inertiaWeight * velocities(i, :) ...
                        + cognitiveWeight * rand(1, numDimensions) .* (localBest(i, :) - particle) ...
                        + socialWeight * rand(1, numDimensions) .* (globalBest - particle);
                    particles(i, :) = particle + velocity;

                    % 边界处理
                    particles(i, :) = max(particles(i, :), 0);
                    particles(i, :) = min(particles(i, :), 1);

                    % 计算被当前粒子支配的粒子数量
                    dominationCount(j) = sum(nicheFitness(j) <= nicheFitness);

                    % 更新局部最优
                    if fitness < localBestFitness(i)
                        localBest(i, :) = particle;
                        localBestFitness(i) = fitness;
                    end

                    % 更新全局最优
                    if fitness < nicheBestFitness
                        globalBest = particle;
                        globalBestFitness = fitness;
                    end
                end

                % 被支配的粒子执行根据支配数量的减小更新速度和位置
                subDominationCount = dominationCount < numNiche;
                subParticles = nicheParticles(subDominationCount, :);
                subFitness = nicheFitness(subDominationCount);
                [~, subIndices] = sort(subFitness);
                for j = 1:length(subIndices)
                    subIndex = subIndices(j);
                    velocity = inertiaWeight * velocities(subIndex, :) ...
                        + cognitiveWeight * rand(1, numDimensions) .* (localBest(subIndex, :) - particle) ...
                        + socialWeight * rand(1, numDimensions) .* (globalBest - particle);
                    particles(subIndex, :) = particle + velocity;

                    % 边界处理
                    particles(subIndex, :) = max(particles(subIndex, :), 0);
                    particles(subIndex, :) = min(particles(subIndex, :), 1);

                    % 更新局部最优
                    if fitness < localBestFitness(subIndex)
                        localBest(subIndex, :) = particle;
                        localBestFitness(subIndex) = fitness;
                    end

                    % 更新全局最优
                    if fitness < nicheBestFitness
                        globalBest = particle;
                        globalBestFitness = fitness;
                    end
                end
            end
        end
    end
end