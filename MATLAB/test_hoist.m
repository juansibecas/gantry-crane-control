%% Plant tests with different initial conditions

%% LiDAR Test (sweep trolley through x -> should plot the container profile)

% Initial Conditions
dlh0 = 0;
lh0 = 40;

dxt0 = 0;
xt0 = -20;

dxtd0 = 0;
xtd0 = -20;

%Load position
xl0 = -20;
yl0 = Yt0 - lh0;
Vlx0 = 0;
Vly0 = 0;

theta_hm0 = 0;
theta_tm0 = 0;

% Torque
Tt = 0;
Th = Thm_max/5;

% Brakes

trolley_brake = 0;

hoist_brake = 0;

hoist_ebrake = 0;

% Twistlocks

TLK = 0;