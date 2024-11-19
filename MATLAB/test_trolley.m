%% Plant tests with different initial conditions

%% LiDAR Test (sweep trolley through x -> should plot the container profile)

% Initial Conditions
dlh0 = 0;
lh0 = 6;

dxt0 = 0;
xt0 = -25;

dxtd0 = 0;
xtd0 = -25;

%Load position
xl0 = -25;
yl0 = Yt0 - lh0 - 1/4 * (Ms*g)/(kwu/(2*lh0+110));
Vlx0 = 0;
Vly0 = 0;

theta_hm0 = 0;
theta_tm0 = 0;

% Torque
% Equilibrium torque, m = Ms
Teq = Ms*g*rhd /ih/2;

Tt = 0;
Th = 0;

% Brakes

trolley_brake = 0;

hoist_brake = 1;

hoist_ebrake = 1;

% Twistlocks

TLK = 0;