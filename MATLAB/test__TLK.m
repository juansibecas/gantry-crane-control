%% Plant tests with different initial conditions

%% Twistlocks and profile updates test (spreader should grab and drop containers 
%% and the plant should update accordingly)

% Initial Conditions
dlh0 = 0;
lh0 = 45 + 9.35;

dxt0 = 0;
xt0 = 10.55;

dxtd0 = 0;
xtd0 = 10.55;

%Load position
xl0 = 10.55;
yl0 = Yt0 - lh0;
Vlx0 = 0;
Vly0 = 0;

theta_hm0 = 0;
theta_tm0 = 0;

% Torque
Tt = 0;
Th = 0;

% Brakes

trolley_brake = 0;

hoist_brake = 1;

hoist_ebrake = 0;

% Twistlocks

TLK = 0;