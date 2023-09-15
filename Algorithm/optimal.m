function particleValue = optimal(particle)

    gm = evalin("base","gmModel");
%     gm = getgmModel();
    
%     numParticles = size(particles,1);
%     dim = size(particles,2);
    
%     optimalList = zeros(numParticles,1);
    
%     for index=1:numParticles
%         runtimeObject = particles(index,:);
%         objectValue = calObjectValue(runtimeObject,gmModel);
%         optimalList(index) = objectValue;
%     end
    particleValue = -calObjectValue(particle,gm);

end

function gmModel = getgmModel()
    % 生成高斯混合模型数据
    rng(1); % 设置随机数种子
    numSamples = 500; % 样本数量
    numComponents = 2; % 混合模型分量数量
    
    % 随机生成混合模型参数
    mu = [0.5 0.5; 0.2 0.8; 0.8 0.2]; % 每个分量的均值
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

function y = calObjectValue(x,gmModel)
    x1 = x(1);
    x2 = x(2);    

    y = pdf(gmModel,[x1,x2]);
end