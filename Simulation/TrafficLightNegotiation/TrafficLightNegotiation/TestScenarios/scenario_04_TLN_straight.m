function [scenario, egoVehicle, referencePathInfo, intersectionInfo] = scenario_04_TLN_straight()
% scenario_04_TLN_straight creates a scenario that is compatible with
% TrafficLightNegotiationTestBench.slx. This open loop scenario has an
% intersection and contains ego vehicle. The ego vehicle continues straight
% at the intersection.

%  Copyright 2019-2021 The MathWorks, Inc.

%%
%  Get driving scenario that is compatible with
%  TrafficLightNegotiationTestBench.slx
[scenario,referencePathInfo,intersectionInfo] = ...
    helperGetTrafficLightScene("Straight");

%% Add the ego vehicle
initPos = referencePathInfo.waypoints(1,:);
speed = 8;
egoVehicle = vehicle(scenario, ...
    'ClassID', 1, ...
    'Position', initPos, ...
    'FrontOverhang', 0.9, ...
    'Name', 'Car');

trajectory(egoVehicle, referencePathInfo.waypoints, speed);

%% Simulation stop time
scenario.StopTime = 15;

%% Explore the scenario using Driving Scenario Designer
% drivingScenarioDesigner(scenario);
