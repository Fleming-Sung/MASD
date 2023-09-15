function hFigure = helperPlotTrafficLightNegotiationResults(logsout)
% helperPlotTrafficLightNegotiationResults A helper function for plotting
% the results of the traffic light negotiation demo.
%
% This is a helper function for example purposes and may be removed or
% modified in the future.
%
% The function assumes that the demo outputs the Simulink log, logsout,
% containing the following elements to be plotted.

% Copyright 2019-2020 The MathWorks, Inc.

%% Get the data from simulation

% longitudinal velocity of ego car
ego_long_velocity = logsout.getElement('ego_velocity');                                 

% tlSensor1 traffic light state
tlSensor1State = logsout.getElement('tlSensor1State');

% relative distance to mio (tracker)
relative_distance = logsout.getElement('mio_relative_distance');                        

% ego_acceleration
ego_acceleration = logsout.getElement('ego_acceleration');

% ego_yaw
ego_yaw = logsout.getElement('ego_yaw');

% simulation time
tmax = ego_long_velocity.Values.time(end);                                              

%% Plot the spacing control results
hFigure = figure('Name','Spacing Control Performance','position',[100 100 720 600]);

%% Plot the states of TL Sensor 1 traffic light.
%
% Red state of TL Sensor 1 is represented by value 0.
% Yellow state of TL Sensor 1 is represented by value 1.
% Green state of TL Sensor 1 is represented by value 2.
% Black represents that there are no valid states from TL Sensor 1.  
subplot(4,1,1)
for i=1:size(tlSensor1State.Values.time)    
    switch tlSensor1State.Values.Data(i)
        case 0 
            % Set the marker color to red.
            markerColor = 'r';    
        case 1
            % Set the marker color to yellow.
            markerColor = 'y';
        case 2
            % Set the marker color to green.
            markerColor = 'g';
        otherwise
            % Set the marker color to black.
            markerColor = 'k';
    end
    scatter(tlSensor1State.Values.time(i), tlSensor1State.Values.Data(i),markerColor);
    hold on;
end
grid on
xlim([0,tmax])
title('Traffic light state - TL Sensor 1')
xlabel('time (sec)')

%% relative longitudinal distance
subplot(4,1,2)
plot(relative_distance.Values.time,relative_distance.Values.Data,'b')
grid on
xlim([0,tmax])
title('Relative longitudinal distance (between ego and MIO)')
xlabel('time (sec)')
ylabel('$meters$','Interpreter','latex')

%% ego acceleration 
subplot(4,1,3)
plot(ego_acceleration.Values.time,ego_acceleration.Values.Data,'b')
grid on
xlim([0,tmax])
ylim(ylim + [-2 2])
title('Ego acceleration')
xlabel('time (sec)')
ylabel('$m/s^2$','Interpreter','latex')

%% ego yaw
subplot(4,1,4)
plot(ego_yaw.Values.time,(ego_yaw.Values.Data),'b')
grid on
xlim([0,tmax])
ylim(ylim + [-2 2])
title('Ego yaw angle')
xlabel('time (sec)')
ylabel('$degree$','Interpreter','latex')

end
