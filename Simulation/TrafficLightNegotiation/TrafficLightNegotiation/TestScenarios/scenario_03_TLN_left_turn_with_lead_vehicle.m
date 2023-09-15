function [scenario, egoVehicle, referencePathInfo, intersectionInfo] = scenario_03_TLN_left_turn_with_lead_vehicle()
% scenario_03_TLN_left_turn_with_lead_vehicle creates a scenario that is
% compatible with TrafficLightNegotiationTestBench.slx. This open loop
% scenario has an intersection and contains two vehicles. The lead vehicle
% moves at a constant speed of 9 m/s . The ego vehicle turns left at the
% intersection.

%  Copyright 2019-2021 The MathWorks, Inc.

%%
%  Get driving scenario that is compatible with
%  TrafficLightNegotiationTestBench.slx
[scenario,referencePathInfo,intersectionInfo] = ...
    helperGetTrafficLightScene("Left");


%% Add the ego vehicle
speed = 9;
initPos = referencePathInfo.waypoints(1,:);
egoVehicle = vehicle(scenario, ...
    'ClassID', 1, ...
    'Position', initPos, ...
    'FrontOverhang', 0.9, ...
    'Name', 'Car');
trajectory(egoVehicle, referencePathInfo.waypoints, speed);

%% Add the non-ego actors
waypoints = [-35 -2 0;
    50 -2 0];
speed = [9;9];
waittime = [0;0];

initPos = waypoints(1,:);
car1 = vehicle(scenario, ...
    'ClassID', 1, ...
    'Position', initPos, ...
    'FrontOverhang', 0.9, ...
    'PlotColor', [196 87 14] / 255, ...
    'Name', 'Car1');

trajectory(car1, waypoints, speed, waittime);
%%
% Simulation stop time
scenario.StopTime = 18;

%% Explore the scenario using Driving Scenario Designer
% drivingScenarioDesigner(scenario);
