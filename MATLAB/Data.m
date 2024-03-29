clear, clc
%% Axes

x_axis = [-30 50];      % shore to ship range[m]
SHORE_LIMIT = x_axis(1);
SHIP_LIMIT = x_axis(2);
vx_max = 4;             % max speed[m/s]
ax_max = 0.8;           % max acceleration[m/s2]

y_axis = [-20 40];      % ship bottom to trolley pulleys range[m]
MAX_CABLE_LENGTH = y_axis(2) - y_axis(1);  % max theorical cable length[m]
vy_loaded_max = 1.5;    % max speed[m/s] - rated load - see constant power graph
vy_unloaded_max = 3;    % max speed[m/s] - unloaded
ay_max = 0.75;          % max acceleration[m/s2]

Yt0 = 45;               % trolley pulleys height[m]
Ysb = 15;               % sill beam height[m]

% !!!! yl + lh(unrolled cable length) = Yt0

%% Parameters
Hc = 2.5;               % container height[m]
Ms = 15000;             % Spreader + Headblock mass[kg]
Mc_range = [2000 50000];      % container mass range[kg]
% Random container mass
Mc = Mc_range(1) + rand() * (Mc_range(2) - Mc_range(1));
g = 9.80665;            % gravity[m/s2]

% Supported load parameters
Kcy = 1.8e9;            % Compression stiffness (vertical contact[]
bcy = 1e8;              % Internal friction[]
bcx = 1e7;              % Horizontal drag friction (vertical contact)[]

% Hoisting Equivalent wirerope parameters PER METER
kwu = 2.36e8;           % Unit Traction stiffness []
bwu = 150;              % Unit Internal Friction []

% Hoisting drive system
rhd = 0.75;             % Drum radius[m]
Jhd_hEb = 3800;         % Equivalent inertia moment of the slow axle (drum + Ebrake + gearbox output)
bhd = 8.0;              % Equivalent mechanical viscous friction (slow axle)
bhEb = 2.2e9;           % Equivalent mechanical viscous friction (Ebrake)
ThEb_max = 1.1e6;       % Max Ebrake torque
ih = 22;                % gearbox ratio
Jhm_hb = 30.0;          % Equivalent inertia moment of the fast axle (motor + break + gearbox input)
bhm = 18.0;             % Equivalent mechanical viscous friction (fast axle)
bhb = 1.0e8;            % Equivalent mechanical viscous friction (brake)
Thb_max = 5.0e4;        % Max brake torque
Fhb_max = Thb_max/rhd;  % Max brake force (at drum diameter)
Tau_hm = 1e-3;             % Torque modulator time constant
Thm_max = 2.0e4;        % Max motor/regenerative-braking torque

% Trolley equivalent wirerope parameters TOTAL
Ktw =4.8e5;             % Wirerope total equivalent traction stiffness
btw =3e3;               % Internal friction

% Trolley drive system
Mt = 30000;             % Trolley mass
bt = 90;                % Equivalent mechanical viscous friction (trolley)
rtd = 0.5;              % Drum radius[m]
Jtd = 1200;             % Equivalent inertia moment of the slow axle (drum + gearbox output)
btd = 1.8;              % Equivalent mechanical viscous friction (slow axle)
it = 30;                % gearbox ratio
Jtm_tb = 7.0;           % Equivalent inertia moment of the fast axle (motor + break + gearbox input)
btm = 6.0;              % Equivalent mechanical viscous friction (fast axle)
btb = 5.0e6;            % Equivalent mechanical viscous friction (brake)
Ttb_max = 5.0e-3;       % Max brake torque
Tau_tm = 1e-3;          % Torque modulator time constant
Ttm_max = 3.0e3;       % Max motor/regenerative-braking torque

% Hoist Subsystem equivalent parameters
MEh = 2*(Jhd_hEb + Jhm_hb * ih^2)/rhd^2;
bEh = 2*(bhd + bhm*ih^2)/rhd^2;

% Trolley Drum Subsystem equivalent parameters
MEtd = (Jtd + Jtm_tb*it^2)/rtd^2;
bEtd = (btd + btm*it^2)/rtd^2;

%% Initialize container layout and masses of the top containers
columns = 9;
maxContainers = 13;
minMass = 2000;
maxMass = 50000;

containerLayout = randi([0, maxContainers], 1, columns);
containerMasses = randi([Mc_range(1), Mc_range(2)], 1, columns);

%% Generate profile(yc0) from layout

%profile = generate_profile_from_vector(containerLayout, Hc);
%xc0 = profile(1,:);
%yc0 = profile(2,:);

%% Hoist Overspeed Sensor

hoist_v115 = 115; %TODO how much is it

%% Initial conditions
%{ 
dlh0 = 0;
lh0 = 30;

dxt0 = 0;
xt0 = 30;

dxtd0 = 0;
xtd0 = 30;

%Load position
xl0 = 30;
yl0 = Yt0 - lh0;
Vlx0 = 0;
Vly0 = 0;

theta_hm0 = 0;
theta_tm0 = 0;
%}
% Sway test (TODO)
dlh0 = 0;
lh0 = 10;

dxt0 = 0;
xt0 = 16;

dxtd0 = 0;
xtd0 = xt0;

%Load position
xl0 = xt0;
yl0 = Yt0 - lh0;
Vlx0 = 0;
Vly0 = 0;

theta_hm0 = 0;
theta_tm0 = 0;


%% Level 2 PID Constants
wh = bEh/MEh;
nh = 2.5;
Ksia_PID_hoist = MEh * (10*wh)^3;
Ksa_PID_hoist = MEh * nh * (10*wh)^2;
b_PID_hoist = MEh * nh *(10*wh);

wtd = bEtd/MEtd;
ntd = 2.5;
Ksia_PID_trolley = MEtd * (10*wtd)^3;
Ksa_PID_trolley = MEh * ntd * (10*wtd)^2;
b_PID_trolley = MEh * ntd *(10*wtd);




