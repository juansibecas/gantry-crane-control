% Axes

x_axis = [-30 50];      % shore to ship range[m]
vx_max = 4;             % max speed[m/s]
ax_max = 0.8;           % max acceleration[m/s2]

y_axis = [-20 40];      % ship bottom to trolley pulleys range[m]
vy_loaded_max = 1.5;    % max speed[m/s] - rated load - see constant power graph
vy_unloaded_max = 3;    % max speed[m/s] - unloaded
ay_max = 0.75;          % max acceleration[m/s2]

Yt0 = 45;               % trolley pulleys height[m]
Ysb = 15;               % sill beam height[m]

% !!!! yl + lh(cable height) = Yt0

% Parameters
Hc = 2.5;               % container height[m]
Ms = 15000;             % Spreader + Headblock mass[kg]
Mc_range = [2000 50000];      % container mass range[kg]
% Random container mass
Mc = Ms + Mc_range(1) + rand() * (Mc_range(2) - Mc_range(1));
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
Thm = 1e-3;             % Torque modulator time constant
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
Ttm_max = 3.0e-3;       % Max motor/regenerative-braking torque

% Hoist Subsystem equivalent parameters
MEh = 2*(Jhd_hEb + Jhm_hb * ih^2)/rhd^2;
bEh = 2*(bhd + bhm*ih^2)/rhd^2;

% Trolley Drum Subsystem equivalent parameters
MEtd = (Jtd + Jtm_tb*it^2)/rtd^2;
bEtd = (btd + btm*it^2)/rtd^2;

%%%%TODO Script to initialize and store container layout
columns = 9;
maxContainers = 13;
minMass = 2000;
maxMass = 50000;

initialLayout = randi([0, maxContainers], 1, columns);
initialMasses = randi([Mc_range(1), Mc_range(2)], 1, columns);

% Save initial layout and masses to workspace variables
assignin('base', 'initialLayout', initialLayout);
assignin('base', 'initialMasses', initialMasses);









    






