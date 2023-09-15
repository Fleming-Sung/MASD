function hFigHandle = helperPlotScenarioWithTrafficLights()
% helperPlotScenarioWithTrafficLights A helper function
% for plotting the scenario along with the traffic light states.
%
% This is a helper function for example purposes and may be removed or
% modified in the future.
%

% Copyright 2019-2020 The MathWorks, Inc.

% Open the figure.
hFigHandle = figure('Name', 'Traffic Light Scenario');

% Create axes handle.
axesHandle = axes(hFigHandle);

% Get scenario from the workspace.
scenario = evalin('base', 'scenario');

% Plot the scenario.
plot(scenario, 'Parent', axesHandle);

% Get intersection info from the base workspace.
intersectionInfo = evalin('base', 'intersectionInfo');

% Update the traffic light positions from the intersection information.
trafficLightPositions = [intersectionInfo.tlSensor1Position(1,1), ...
    intersectionInfo.tlSensor1Position(1,2); ...
    intersectionInfo.tlSensor2Position(1,1), ...
    intersectionInfo.tlSensor2Position(1,2); ...
    intersectionInfo.tlSensor3Position(1,1), ...
    intersectionInfo.tlSensor3Position(1,2); ...
    intersectionInfo.tlSensor4Position(1,1), ...
    intersectionInfo.tlSensor4Position(1,2), ...
    ];
fontSize = 11;

hold on;

% Plot the marker for TL Sensor 1, TL Sensor 2, TL Sensor 3, TL Sensor 4
% and add text annotations.
for i=1:size(trafficLightPositions)
    plot(trafficLightPositions(i,1),trafficLightPositions(i,2), ...
        'Marker','o','MarkerFaceColor','r','MarkerSize',8, ...
        'Parent',axesHandle);
    text(trafficLightPositions(i,1)+0.6, ...
        trafficLightPositions(i,2)-1.75, ...
        num2str(i), 'FontSize', fontSize);
end

% Set the size of the figure.
set(gcf, 'Position', [1 1 800 600]);
