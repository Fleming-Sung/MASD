function [scenario, egoVehicle, referencePathInfo, intersectionInfo] = scenario_01_TLN_left_turn()
% scenario_01_TLN_left_turn creates a scenario that is compatible with
% TrafficLightNegotiationTestBench.slx. This open loop scenario has an
% intersection and contains an ego vehicle. The ego vehicle takes left turn
% at the intersection.

%  Copyright 2019-2021 The MathWorks, Inc.

%%
%  Get driving scenario that is compatible with
%  TrafficLightNegotiationTestBench.slx
[scenario,referencePathInfo,intersectionInfo] = ...
    helperGetTrafficLightScene("Left");

%% Add the ego vehicle
speed = 8;
initPos = referencePathInfo.waypoints(1,:);
egoVehicle = vehicle(scenario, ...
    'ClassID', 1, ...
    'Position', initPos, ...
    'FrontOverhang', 0.9, ...
    'Name', 'Car');
trajectory(egoVehicle, referencePathInfo.waypoints, speed);

%% Simulation stop time
scenario.StopTime = 20;

%% Explore the scenario using Driving Scenario Designer
% drivingScenarioDesigner(scenario);
