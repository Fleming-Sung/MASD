function pso()    
    % 设定算法参数
    max_iterations = evalin("base","maxIteration");
    num_particles = 12;
    % fit小于gate被认为是危险粒子;
    simDim = evalin("base","dim");
    dimensions = length(simDim);

    c1 = 1.5; % 加速因子1
    c2 = 1.5; % 加速因子2
    w = 0.5; % 惯性权重

    
    optArray = [];

    % 初始化粒子群      
    particles_position = rand(num_particles, dimensions);
    particles_velocity = rand(num_particles, dimensions);
    personal_best_position = particles_position;
    personal_best_fitness = evaluate_fitness(personal_best_position,1);    
    % 设置全局最优
    [global_best_fitness, index] = min(personal_best_fitness);
    global_best_position = personal_best_position(index, :);
    
    
f =  waitbar(0, strcat('PSO for ',num2str(max_iterations),'iterations...'));
    % 粒子群优化主循环
    for iteration = 1:max_iterations
        % 更新粒子速度和位置
        particles_velocity = w * particles_velocity + c1 * rand() * (personal_best_position - particles_position) + c2 * rand() * (global_best_position - particles_position);
        particles_position = particles_position + particles_velocity;

        particles_position(:, :) = max(particles_position(:, :), 0);
        particles_position(:, :) = min(particles_position(:, :), 1);

    
        % 评估新位置的适应度
        current_fitness = evaluate_fitness(particles_position,iteration);
        close(f)
        f = waitbar(iteration/max_iterations, strcat('PSO for ',num2str(max_iterations),'iterations...'));

        % 可视化总适应度函数值变化过程    
        totalfit = sum(current_fitness);
        optArray(iteration, 1) = iteration;
        optArray(iteration, 2) = totalfit;
        figure(99)
        plot(optArray(:,1), optArray(:,2))
    
        % 更新个体最优
        update_personal_best = current_fitness < personal_best_fitness;
        personal_best_position(update_personal_best, :) = particles_position(update_personal_best, :);
        personal_best_fitness(update_personal_best) = current_fitness(update_personal_best);
    
        % 更新全局最优
        [current_global_best_fitness, index] = min(personal_best_fitness);
        if current_global_best_fitness < global_best_fitness
            global_best_fitness = current_global_best_fitness;
            global_best_position = personal_best_position(index, :);
        end
    end
    close(f);    
end

function particlesFitness = evaluate_fitness(particles, iteration)
    algorithmTest = evalin("base","algorithmTest");
    if algorithmTest == false
%         disp("当前进度：");
%         disp([iteration, "/", max_iterations]);
        particlesFitness = simAbatch(particles, iteration); % 并行仿真以求解当前种群的适应度

        if size(particles,2) == 2 % 对于2维仿真，可视化算法执行过程
            gate = -1;
            plotProcedure(particles, particlesFitness, gate);
        end
    else
        particlesFitness = batchOptimal(particles, iteration);
    end
end
