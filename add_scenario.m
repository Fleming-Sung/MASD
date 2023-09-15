function scenario = add_scenario(param)
% scenario_02_TLN_left_turn_with_cross_over_vehicle creates a scenario that
% is compatible with TrafficLightNegotiationTestBench.slx. This open loop
% scenario has an intersection and contains three vehicles. The lead
% vehicle moves at a constant speed of 9 m/s. A slow-moving cross-traffic
% vehicle is moving in the road that is perpendicular to the ego road.

%  Copyright 2019-2021 The MathWorks, Inc.s

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

% 添加一个actor，紫色
car3 = vehicle(scenario,'ClassID',1);
scenario.Actors(4).Name = 'Car3';
scenario.Actors(4).Position = [50,2,0];
scenario.Actors(4).Velocity = [-10,0,0];
scenario.Actors(4).PlotColor = [1,0,1];

speedCar1 = param(1); % 前车车速[3,18]
xCar1 = 28; % 前车cut in时的纵向坐标[-30, 30]
xCar2 = -5.5; % 从左向右的车辆的纵坐标[-2.5,-6]
speedCar2 = param(2); % 左侧车辆车速[3,18]
speedCar3 = 5; % 右侧车辆车速[3,18]

% waypoint1 = ...
%     [-40,-6;
%     xCar1,-2.5;
%     50,-2.5]; % 前车不向左并线
waypoint1 = ...
    [-40,-6;
    xCar1,-5;
    50,-5]; % 前车向左并线,但不完全并入
% waypoint1 = ...
%     [-40,-6;
%     xCar1,-2.5;
%     50,-2.5]; % 前车向左并线
waypoint2 = ...
    [-2.5,50;
    xCar2,-10;
    xCar2,-50];
waypoint3 = ...
   [5.5,-50;
    5.5,0;
    5.5,50];

trajectory(scenario.Actors(2),waypoint1,speedCar1);
trajectory(scenario.Actors(3),waypoint2,speedCar2);
trajectory(scenario.Actors(4),waypoint3,speedCar3);
end