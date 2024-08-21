%% Plant tests with different initial conditions

%% LiDAR Test (sweep trolley through x -> should plot the container profile)

% Initial Conditions
dlh0 = 0;
lh0 = 10;

dxt0 = 0;
xt0 = -25;

dxtd0 = 0;
xtd0 = -25;

%Load position
xl0 = -25;
yl0 = Yt0 - lh0;
Vlx0 = 0;
Vly0 = 0;

theta_hm0 = 0;
theta_tm0 = 0;

% Torque
Tt = Ttm_max/2;
Th = 0;

% Brakes

trolley_brake = 0;

hoist_brake = 1;

hoist_ebrake = 1;

% Twistlocks

TLK = 0;