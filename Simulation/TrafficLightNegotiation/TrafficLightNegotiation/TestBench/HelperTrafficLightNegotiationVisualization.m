classdef HelperTrafficLightNegotiationVisualization < matlab.System
    %HelperTrafficLightNegotiationVisualization Visualization helper class.
    %   This is a helper class which plots the run time simulation result
    %   for the traffic light negotiation example.
    
    % NOTE: The name of this System Object and its functionality may
    % change without notice in a future release,
    % or the System Object itself may be removed.
    
    % Copyright 2019-2020 The MathWorks, Inc.
    
    properties(Access = private)
        %Figure Store the figure handle.
        Figure;
        
        %AxesHandle.
        AxesHandle;
        
        %Scenario Store scenario variable from the workspace.
        Scenario;
        
        %TrafficLightGraphicObjects Store graphic objects to change marker
        %face color.
        TrafficLightGraphicObjects = [];
    end
    
    methods(Access = protected)
        %------------------------------------------------------------------
        function setupImpl(obj,varargin)
            %setupImpl Perform one-time calculations.
            figureName = 'Traffic Light Negotiation';
            obj.Figure = findobj('Type','Figure','Name',figureName);
            
            % create the figure only if it is not already open.
            if isempty(obj.Figure)
                obj.Figure = figure('Name',figureName);
                obj.Figure.NumberTitle = 'off';
                obj.Figure.MenuBar = 'none';
                obj.Figure.ToolBar = 'none';
            end
            
            % Clear figure.
            clf(obj.Figure);
            obj.AxesHandle = axes(obj.Figure);
            
            % Get the scenario object from the base workspace.
            obj.Scenario = evalin('base', 'scenario');
            
            % Plot the scenario.
            plot(obj.Scenario,'Parent',obj.AxesHandle,'RoadCenters',...
                'off','Centerline','off');
            hold on;
            % Get the referencePathInfo variable from the base work space.
            refPath = evalin('base', 'referencePathInfo.referencePath');
            
            % Plot the reference path.
            plot(refPath(:,1), refPath(:,2), '--', 'Color','k','Parent',...
                obj.AxesHandle);
            
            % Get intersection info from the base workspace.
            intersectionInfo = evalin('base', 'intersectionInfo');
            
            % Update the traffic light positions from the intersection
            % information.
            trafficLightPositions = [intersectionInfo.tlSensor1Position(1,1), ...
                intersectionInfo.tlSensor1Position(1,2); ...
                intersectionInfo.tlSensor2Position(1,1), ...
                intersectionInfo.tlSensor2Position(1,2); ...
                intersectionInfo.tlSensor3Position(1,1), ...
                intersectionInfo.tlSensor3Position(1,2); ...
                intersectionInfo.tlSensor4Position(1,1), ...
                intersectionInfo.tlSensor4Position(1,2), ...
                ];
            
            % preallocate an array to store graphics handles.
            obj.TrafficLightGraphicObjects = gobjects(4,1);
            
            % Plot traffic light sensor positions.
            for i=1:size(trafficLightPositions)
                obj.TrafficLightGraphicObjects(i) = plot(trafficLightPositions(i,1),trafficLightPositions(i,2), ...
                    'Marker','o','MarkerFaceColor','r','MarkerSize',8,...
                    'Parent',obj.AxesHandle);
            end

            % set current figure handle position.
            set(gcf, 'Position', [1 1 800 600]);
            
            % Add legend information.
            f=get(gca,'Children');
            
            % Assign 'none' for the LineStyle in legend for traffic light
            % representation.
            f(4).LineStyle = 'none';
            
            % Add legend
            legend([f(5),f(4)], 'Reference Path',...
                'State of Traffic light on the Ego lane','AutoUpdate','off');
        end
        
        %------------------------------------------------------------------
        function stepImpl(obj,trafficLightSensorStates,...
                targetPoses, egoInfo)
            %stepImpl Implements the main logic that updates the plot with
            %   new actor positions and traffic light states for all
            %   traffic lights.
            
            % Get the number of actors along with ego vehicle.
            numActors = targetPoses.NumActors + 1;
            
            % Update ego position and yaw.
            obj.Scenario.Actors(1).Position = egoInfo.Position;
            obj.Scenario.Actors(1).Yaw = egoInfo.Yaw;
            
            % Update other vehicle positions in the scenario.
            for n = 2:numActors
                obj.Scenario.Actors(n).Position = ...
                    targetPoses.Actors(n-1).Position;
                obj.Scenario.Actors(n).Yaw   = targetPoses.Actors(n-1).Yaw;
            end
            
            if (isvalid(obj.AxesHandle))
                % Update marker face colors based on the traffic light
                % sensor states. Red state of TL Sensor 1 is represented by
                % value 0. Yellow state of TL Sensor 1 is represented by
                % value 1. Green state of TL Sensor 1 is represented by
                % value 2. Black represents that there are no valid
                % detections from TL Sensor 1. It is assumed to have
                % one-to-one correspondence between
                % TrafficLightGraphicObjects and trafficLightSensorStates.
                for i = 1:size(obj.TrafficLightGraphicObjects)
                    switch(trafficLightSensorStates(i))
                        case 0
                            % Set the marker color to red.
                            obj.TrafficLightGraphicObjects(i).MarkerFaceColor = 'r';
                        case 1
                            % Set the marker color to yellow.
                            obj.TrafficLightGraphicObjects(i).MarkerFaceColor = 'y';
                        case 2
                            % Set the marker color to green.
                            obj.TrafficLightGraphicObjects(i).MarkerFaceColor = 'g';
                        otherwise
                            % Set the marker color to black.
                            obj.TrafficLightGraphicObjects(i).MarkerFaceColor = 'k';
                    end
                end
                
                % update existing scenario plot.
                updatePlots(obj.Scenario);
                
                % limits the number of updates to 20 frames per second.
                drawnow limitrate
            end
        end
    end
    
    methods(Access = protected, Static)
        function simMode = getSimulateUsingImpl
            % Return only allowed simulation mode in System block dialog.
            simMode = "Interpreted execution";
        end
        
        function flag = showSimulateUsingImpl
            % Return false if simulation mode hidden in System block
            % dialog.
            flag = false;
        end
        
        function [name1,name2,name3] = getInputNamesImpl(obj)
            % Return input port names for System block.
            name1 = 'TrafficLightSensorStates';
            name2 = 'TargetPoses';
            name3 = 'EgoInfo';
        end
    end
    
end
