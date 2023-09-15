function [scenario, egoVehicle, referencePathInfo, intersectionInfo] = scenario_05_TLN_straight_with_lead_vehicle()
% scenario_05_TLN_straight_with_lead_vehicle creates a scenario that is
% compatible with TrafficLightNegotiationTestBench.slx. This open loop
% scenario has an intersection and contains two vehicles. The lead vehicle
% moves at a constant speed of 5 m/s. In open loop, there is an expected
% collision between the ego vehicle and lead car. The ego vehicle continues
% to travel straight at the intersection.

%  Copyright 2019-2021 The MathWorks, Inc.

%%
%  Get driving scenario that is compatible with
%  TrafficLightNegotiationTestBench.slx
[scenario,referencePathInfo,intersectionInfo] = ...
    helperGetTrafficLightScene("Straight");

%% Add the ego vehicle
speed = 10;
initPos = referencePathInfo.waypoints(1,:);
egoVehicle = vehicle(scenario, ...
    'ClassID', 1, ...
    'Position', initPos, ...
    'FrontOverhang', 0.9, ...
    'Name', 'Car');

trajectory(egoVehicle, referencePathInfo.waypoints, speed);

%% Add the non-ego actors. 
% car1 moves with a constant velocity of 5 m/s in the ego lane and
% ahead of ego vehicle.
waypoints = [-32.2 -1.8 0;
    10.5 -1.8 0;
    46.9 -1.8 0;
    56.5 -1.8 0];
speed = 5;
initPos = referencePathInfo.waypoints(1,:);
car1 = vehicle(scenario, ...
    'ClassID', 1, ...
    'Position', initPos, ...
    'FrontOverhang', 0.9, ...
    'PlotColor', [162 20 47] / 255);
trajectory(car1, waypoints, speed);

%%
% Simulation stop time
scenario.StopTime = 18;

%% Explore the scenario using Driving Scenario Designer
% drivingScenarioDesigner(scenario);
