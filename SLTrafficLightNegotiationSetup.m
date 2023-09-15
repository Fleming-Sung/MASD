function SLTrafficLightNegotiationSetup()

% Load the Simulink model
modelName = 'TrafficLightNegotiationTestBench';
wasModelLoaded = bdIsLoaded(modelName);
if ~wasModelLoaded
    load_system(modelName)
end

%  Get driving scenario that is compatible with
%  TrafficLightNegotiationTestBench.slx
[scenario,referencePathInfo,intersectionInfo] = ...
    helperGetTrafficLightScene("Left");

% Add the ego vehicle
% The waypoints for the ego vehicle are defined from the reference path.
% In this case the vehicle turns left at the intersection.
initPos = referencePathInfo.waypoints(1,:);
egoVehicle = vehicle(scenario, ...
    'ClassID', 1, ...
    'Position', initPos, ...
    'FrontOverhang', 0.9, ...
    'Name', 'Car');


%% Scenario parameters
% assignin('base','scenario',scenario);
assignin('base','egoVehicle',egoVehicle);
assignin('base', 'egoActorID', egoVehicle.ActorID);
assignin('base','referencePathInfo',referencePathInfo);
assignin('base','intersectionInfo',intersectionInfo);

%% Vehicle parameters
egoVehDyn = egoVehicleDynamicsParams(egoVehicle);
assignin('base','egoVehDyn',egoVehDyn);
assignin('base','vehicleLength',egoVehicle.Length);

%% General model parameters
assignin('base','Ts',0.1);                   % Algorithm sample time  (s)
assignin('base','v_set', egoVehDyn.VLong0);  % Set velocity           (m/s)
assignin('base','LongitudinalJerkMax', 5);   % Max Longitudinal Jerk
assignin('base','LateralJerkMax', 5);        % Max Lateral Jerk

%% Path following controller parameters
assignin('base','tau',               0.05);  % Time constant for longitudinal dynamics 1/s/(tau*s+1)
assignin('base','tau1',              0.7);   % Longitudinal time constant (throttle)          (N/A)
assignin('base','tau2',              0.07);  % Longitudinal time constant (brake)             (N/A)
assignin('base','time_gap',          1.5);   % Time gap                                       (s)
assignin('base','default_spacing',   10);    % Default spacing                                (m)
assignin('base','max_ac',            2);     % Maximum acceleration                           (m/s^2)
assignin('base','max_dc',            -10);   % Maximum deceleration                           (m/s^2)
assignin('base','min_ac',            -3);    % Minimum acceleration                           (m/s^2)
assignin('base','max_steer',         0.79);  % Maximum steering                               (rad)
assignin('base','min_steer',         -0.79); % Minimum steering                               (rad)
assignin('base','PredictionHorizon', 30);    % Prediction horizon
assignin('base', 'ControlHorizon',   2);     % Control horizon
assignin('base','v0_ego', egoVehDyn.VLong0); % Initial longitudinal velocity                  (m/s)

%% Watchdog Braking controller parameters
assignin('base', 'PB1_decel',       3.8);      % 1st stage Partial Braking deceleration (m/s^2)
assignin('base', 'PB2_decel',       5.3);      % 2nd stage Partial Braking deceleration (m/s^2)
assignin('base', 'FB_decel',        9.8);      % Full Braking deceleration              (m/s^2)
assignin('base', 'headwayOffset',   3.7);      % Distance from ego origin to bumper     (m)
assignin('base', 'timeMargin',      0);        % time margin                            (sec)
assignin('base', 'timeToReact',     1.2);      % driver reaction time                   (sec)
assignin('base', 'driver_decel',    4.0);      % driver braking deceleration            (m/s^2)
assignin('base','Default_decel', 0);           % Default deceleration (m/s^2)
assignin('base','TimeFactor', 1.2);            % Time factor (sec)
assignin('base','stopVelThreshold', 0.1);      % Velocity threshold for stopping ego vehicle (m/s)

%% Tracking and sensor fusion parameters
assignin('base','assignThresh', 50);       % Tracker assignment threshold          (N/A)
assignin('base','M',            2);        % Tracker M value for M-out-of-N logic  (N/A)
assignin('base','N',            3);        % Tracker N value for M-out-of-N logic  (N/A)
assignin('base','numTracks',    100);      % Maximum number of tracks              (N/A)
assignin('base','numSensors',   2);        % Maximum number of sensors             (N/A)

% Position and velocity selectors from track state
% The filter initialization function used in this example is initcvekf that
% defines a state that is: [x;vx;y;vy;z;vz].
assignin('base','posSelector', [1,0,0,0,0,0; 0,0,1,0,0,0]); % Position selector   (N/A)
assignin('base','velSelector', [0,1,0,0,0,0; 0,0,0,1,0,0]); % Velocity selector   (N/A)

%% Dynamics modeling parameters
assignin('base','m',  1575);                    % Total mass of vehicle                          (kg)
assignin('base','Iz', 2875);                    % Yaw moment of inertia of vehicle               (m*N*s^2)
assignin('base','Cf', 19000);                   % Cornering stiffness of front tires             (N/rad)
assignin('base','Cr', 33000);                   % Cornering stiffness of rear tires              (N/rad)
assignin('base','lf', egoVehDyn.CGToFrontAxle); % Longitudinal distance from c.g. to front tires (m)
assignin('base','lr', egoVehDyn.CGToRearAxle);  % Longitudinal distance from c.g. to rear tires  (m)

%% Bus Creation
evalin('base','helperSLCreateTLNUtilityBus');

% Create bus for multi-object tracker
blk = [modelName,'/Sensors and Environment/Tracking and Sensor Fusion/Multi-Object Tracker'];
multiObjectTracker.createBus(blk);

end

% Update the initial vehicle parameters for the vehicle dynamics block.
function egoVehDyn = egoVehicleDynamicsParams(ego)
% Translate to SAE J670E (North-East-Down)
% Adjust sign of y position
egoVehDyn.X0  =  ego.Position(1); % (m)
egoVehDyn.Y0  = -ego.Position(2); % (m)
egoVehDyn.VX0 =  ego.Velocity(1); % (m)
egoVehDyn.VY0 = -ego.Velocity(2); % (m)

% Adjust sign and unit of yaw
egoVehDyn.Yaw0 = -deg2rad(ego.Yaw); % (rad)

% Longitudinal velocity
egoVehDyn.VLong0 = hypot(egoVehDyn.VX0,egoVehDyn.VY0); % (m/sec)

% Distance from center of gravity to axles
egoVehDyn.CGToFrontAxle = ego.Length/2 - ego.FrontOverhang;
egoVehDyn.CGToRearAxle  = ego.Length/2 - ego.RearOverhang;

end