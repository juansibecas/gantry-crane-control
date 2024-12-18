clear, clc
%% Axes

x_axis = [-30 50];      % shore to ship range[m]
SHORE_LIMIT = x_axis(1);
SHIP_LIMIT = x_axis(2);
vx_max = 4;             % max speed[m/s]
ax_max = 0.8;           % max acceleration[m/s2]
jerkt=0.2;
dx=0.1;

y_axis = [-20 40];      % ship bottom to trolley pulleys range[m]
MAX_CABLE_LENGTH = y_axis(2) - y_axis(1);  % max theorical cable length[m]
vy_loaded_max = 1.5;    % max speed[m/s] - rated load - see constant power graph
vy_unloaded_max = 3;    % max speed[m/s] - unloaded
ay_max = 0.75;          % max acceleration[m/s2]
jerkh=4;

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
kwu = 2.36e8;           % Unit Traction stiffness [] %guia de trabajo 2.36e8
bwu = 15000;              % Unit Internal Friction []  %guia de trabajo 150

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
Ktw = 4.8e3;             % Wirerope total equivalent traction stiffness %guia de trabajo 4.8e5
btw = 3e5;               % Internal friction %guia de trabajo 3e3

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
Ttb_max = 5.0e3;       % Max brake torque
Tau_tm = 1e-3;          % Torque modulator time constant
Ttm_max = 3.0e3;       % Max motor/regenerative-braking torque

% Hoist Subsystem equivalent parameters
MEh = (Jhd_hEb + Jhm_hb * ih^2)/rhd^2;
bEh = (bhd + bhm*ih^2)/rhd^2;

% Trolley Drum Subsystem equivalent parameters
MEtd = Mt + (Jtd + Jtm_tb*it^2)/rtd^2;
bEtd = bt + (btd + btm*it^2)/rtd^2;

%% Initialize container layout and masses of the top containers
columns = 9;
maxContainers = 13;
minMass = 2000;
maxMass = 50000;
containerWidth=2.5;
Hseg=5;
Bseg=5;

containerLayout = [3 2 2 4 3 4 2 1 4];
containerMasses = randi([Mc_range(1), Mc_range(2)], 1, columns);

bayLayout = [0 1 1];
bayMasses = randi([Mc_range(1), Mc_range(2)], 1, length(bayLayout));

X_bay=[-22,-15,-8];

X_container=[2.75,5.25,7.75,10.25,12.75,15.25,17.75,20.25,22.75];

%% Generate profile(yc0) from layout

%profile = generate_profile_from_vector(containerLayout, Hc);
%xc0 = profile(1,:);
%yc0 = profile(2,:);

%% Hoist Overspeed Sensor

hoist_v115 = 115; %TODO how much is it

%% Level 2 PID Constants
wh = 10*bEh/MEh;
nh = 2.5;
% Ksia_PID_hoist = -ih * MEh * nh * wh^3 / rhd;
% Ksa_PID_hoist = -ih * MEh * nh * wh^2 /rhd;
% b_PID_hoist = -(ih * MEh * nh *wh - ih * bEh ) /rhd;

Ksia_PID_hoist = MEh * wh^3;
Ksa_PID_hoist = MEh * nh * wh^2;
ba_PID_hoist = MEh * nh * wh;


wtd = 8.3*bEtd/MEtd;
ntd = 2.5;
% Ksia_PID_trolley =it * MEtd * ntd * wtd^3 / rtd;
% Ksa_PID_trolley =it * MEtd * ntd * wtd^2 / rtd;
% b_PID_trolley =(it * MEtd * ntd *wtd- it * bEtd)/rtd ;
% % 
% Ksia_PID_trolley =+1.026e7;
% Ksa_PID_trolley =3.8e7; 
% b_PID_trolley =6.75e5; 

Ksia_PID_trolley =MEtd*wtd^3*rtd/it;
Ksa_PID_trolley =MEtd*ntd*wtd^2*rtd/it;
ba_PID_trolley = MEtd*ntd*wtd*rtd/it;



wtd_sway = 8*bEtd/MEtd;
z_sway = 0.8;

Ksa_PID_trolley_sway =MEtd*wtd_sway^2*rtd/it;
ba_PID_trolley_sway = MEtd*z_sway*wtd_sway*rtd/it;

%% observer gains

wh_obs = 1*wh;

Ktheta_obs_h = 3*wh_obs;
Kw_obs_h = 3*wh_obs^2;
Ki_obs_h = wh_obs^3;

wtd_obs = 1*wtd;

Ktheta_obs_t = 3*wtd_obs;
Kw_obs_t = 3*wtd_obs^2;
Ki_obs_t = wtd_obs^3;

%% sample frequency
Ts = 0.001;

%% manual control

AnalogV_=0;
AnalogH_=0;

message=["Exit manual zone to perform automatic positioning","Positioning","Manually engage the container","Manually release the container","Manual"];
Container1_x0=-15;
Container1_y0=2.2;









