function simInputs = particles2Inputs(particles)
simDim = evalin("base", "dim");
numParticles = size(particles, 1);
simInputs = zeros(numParticles, length(simDim));
for pIndex = 1:numParticles
    particle = particles(pIndex, :);
    lowBound = simDim(:,1)';
    upBound = simDim(:,2)';
    simInputs(pIndex,:) = lowBound + particle .* (upBound-lowBound);
end