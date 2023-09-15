% Clean up script for the Traffic Light Negotiation Test Bench Example
%
% This script cleans up the example model. It is triggered by the
% CloseFcn callback.
%
%   This is a helper script for example purposes and may be removed or
%   modified in the future.

%   Copyright 2019-2021 The MathWorks, Inc.

clear BusActors1
clear BusActors2
clear BusDetectionConcatenation1
clear BusDetectionConcatenation1Detections
clear BusDetectionConcatenation1DetectionsMeasurementParameters
clear BusLaneBoundaries1
clear BusLaneBoundaries1LaneBoundaries
clear BusLaneCenter
clear BusLanes
clear BusLanesLaneBoundaries
clear BusMultiObjectTracker1
clear BusMultiObjectTracker1Tracks
clear BusRadar
clear BusRadarDetections
clear BusRadarDetectionsMeasurementParameters
clear BusRadarDetectionsObjectAttributes
clear BusVehiclePose
clear BusVision
clear BusVisionDetections
clear BusVisionDetectionsMeasurementParameters
clear BusVisionDetectionsObjectAttributes
clear Cf
clear Cr
clear FB_decel
clear Iz
clear LaneSensor
clear LaneSensorBoundaries
clear LateralJerkMax
clear LongitudinalJerkMax
clear M
clear N
clear PB1_decel
clear PB2_decel
clear PredictionHorizon
clear ControlHorizon
clear ReferencePathInfo
clear Ts
clear ans
clear assignThresh
clear default_spacing
clear driver_decel
clear egoVehDyn
clear egoVehicle
clear hFigResults
clear hFigScenario
clear headwayOffset
clear intersectionInfo
clear lf
clear logsout
clear lr
clear m
clear maxMIOLeadDistance
clear max_ac
clear max_dc
clear max_steer
clear min_ac
clear min_steer
clear numSensors
clear numTracks
clear posSelector
clear referencePathInfo
clear referencePathSwitchThreshold
clear refpathSize
clear scenario
clear tau
clear tau1
clear tau2
clear timeMargin
clear timeToReact
clear time_gap
clear trafficLightStateTriggerThreshold
clear v0_ego
clear v_set
clear vehicleLength
clear velSelector
clear waypointsSize
clear Default_decel
clear TimeFactor
clear stopVelThreshold
clear egoActorID

figs = findobj('Name','Traffic Light Negotiation','Type','figure');
if ~isempty(figs)
    close(figs);
end
clear figs

% If ans was created by the model, clean it too
if exist('ans','var') && ischar(ans) && (strcmpi(ans,'BusMultiObjectTracker1')) %#ok<NOANS>
    clear ans
end
