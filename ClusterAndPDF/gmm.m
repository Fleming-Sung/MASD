% gmModel = fitgmdist(adversarialSamples, 5, "CovarianceType","diagonal")
gmModel = fitgmdist(adversarialSamples, 100, 'SharedCovariance', true)
% gmModel = fitgmdist(adversarialSamples, 5, 'RegularizationValue', 0.0001)

close all;
gmPDF = @(x,y) arrayfun(@(x0,y0) pdf(gmModel,[x0 y0]),x,y);
figure()
fsurf(gmPDF,[0,1])
figure()
fcontour(gmPDF,[0,1])
