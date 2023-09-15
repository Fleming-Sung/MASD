function [scenario, egoVehicle, referencePathInfo, intersectionInfo] = scenario_02_TLN_left_turn_with_cross_over_vehicle()
% scenario_02_TLN_left_turn_with_cross_over_vehicle creates a scenario that
% is compatible with TrafficLightNegotiationTestBench.slx. This open loop
% scenario has an intersection and contains three vehicles. The lead
% vehicle moves at a constant speed of 9 m/s. A slow-moving cross-traffic
% vehicle is moving in the road that is perpendicular to the ego road.

%  Copyright 2019-2021 The MathWorks, Inc.

%%
%  Get driving scenario that is compatible with
%  TrafficLightNegotiationTestBench.slx
[scenario,referencePathInfo,intersectionInfo] = ...
    helperGetTrafficLightScene("Left");

%%
% Add the ego vehicle
% The waypoints for the ego vehicle are defined from the reference path.
% In this case the vehicle turns left at the intersection.
speed = 9;
initPos = referencePathInfo.waypoints(1,:);
egoVehicle = vehicle(scenario, ...
    'ClassID', 1, ...
    'Position', initPos, ...
    'FrontOverhang', 0.9, ...
    'Name', 'Car');

% Form the trajectory for the ego vehicle with the waypoints from the
% reference path.
trajectory(egoVehicle, referencePathInfo.waypoints, speed);

%%
% Add the non-ego actors
% car1 moves with a constant velocity of 8 m/s in the ego lane and ahead of
% ego lane.
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

% Form the trajectory with the waypoints.
trajectory(car1, waypoints, speed, waittime);

% car2 is a slow moving cross-over vehicle that passes through the
% intersection in a perpendicular direction to the motion of the ego
% vehicle.
waypoints = [-2 50 0;
    -2 10 0;
    -2 2 0;
    -2 1 0;
    -2 -2 0;
    -2 -50 0];
speed = [5;5;3;2.5;3;5];
waittime = [0;0;0;0;0;0];

initPos = waypoints(1,:);
car2 = vehicle(scenario, ...
    'ClassID', 1, ...
    'Position', initPos, ...
    'FrontOverhang', 0.9, ...
    'PlotColor', [15 255 255] / 255, ...
    'Name', 'Car2');

% Form trajectory with the waypoints.
trajectory(car2, waypoints, speed, waittime);

%%
% Simulation stop time
scenario.StopTime = 18;

%% Explore the scenario using Driving Scenario Designer
% drivingScenarioDesigner(scenario);
