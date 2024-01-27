function batchFit = batchOptimal(batch, iter)
    fullResults = evalin("base", "fullResults");
    batchFit = zeros(size(batch,1), 1);
    for i = 1:size(batch, 1)
        fit = optimal(batch(i,:));
        batchFit(i) = fit;
    end

    fullResults{iter}.fit = batchFit;
    fullResults{iter}.particles = batch;
    assignin("base", "fullResults", fullResults);
end