%% Plots and performance checks
logs = out.logsout;
time = out.tout;


mode_log = logs.getElement('display').Values;
tlk_log = logs.getElement('TLK').Values;
%% Torque inputs

thm_ref_log = logs.getElement('Thm*').Values;
thm_real_log = logs.getElement('Thm').Values;
ttm_ref_log = logs.getElement('Ttm*').Values;
ttm_real_log = logs.getElement('Ttm').Values;

%% Contact Mode

fcx_log = logs.getElement('Fcx').Values;
fcy_log = logs.getElement('Fcy').Values;

%% Mass estimation

loadcell_log = logs.getElement('loadcell').Values;
est_mass_log = logs.getElement('est_mass').Values;
real_mass_log = logs.getElement('real_mass').Values;

%% Load X-Y coordinates

xl_log = logs.getElement('xl').Values;
yl_log = logs.getElement('yl').Values;

vlx_log = logs.getElement('vlx').Values;
vly_log = logs.getElement('vly').Values;


%% Trolley and Hoist real profiles

lh_real_log = logs.getElement('lh_real').Values;
dlh_real_log = logs.getElement('dlh_real').Values;
ddlh_real_log = logs.getElement('ddlh_real').Values;

xt_real_log = logs.getElement('xt_real').Values;
dxt_real_log = logs.getElement('dxt_real').Values;
ddxt_real_log = logs.getElement('ddxt_real').Values;

theta_real_log = logs.getElement('theta_real').Values;

%% Trolley and Hoist observed profiles

lh_obs_log = logs.getElement('lh_obs').Values;

xt_obs_log = logs.getElement('xt_obs').Values;

% theta_obs_log = logs.getElement('theta_obs').Values;
% dtheta_obs_log = logs.getElement('dtheta_obs').Values;
% ddtheta_obs_log = logs.getElement('ddtheta_obs').Values;

%% Trolley and Hoist speed references

dlh_ref_log = logs.getElement('dlh_ref').Values;

dxt_ref_log = logs.getElement('dxt_ref').Values;

%sway_ref_log = logs.getElement('sway_ref').Values;


%% Plots

figure(1)
hold on
grid on
title('Posición del carro')
plot(xt_real_log.Time, xt_real_log.Data);
plot(xt_obs_log.Time, xt_obs_log.Data);
xlabel('Tiempo [s]');
ylabel('Posición [m]');
legend('xt real', 'xt obs')

figure(2)
hold on
grid on
title('Posición del izaje')
plot(lh_real_log.Time, lh_real_log.Data);
plot(lh_obs_log.Time, lh_obs_log.Data);
xlabel('Tiempo [s]');
ylabel('Posición [m]');
legend('lh real', 'lh obs')

figure(3)
hold on
grid on
title('Ángulo de Balanceo')
plot(theta_real_log.Time, theta_real_log.Data*180/pi);
xlabel('Tiempo [s]');
ylabel('Ángulo [°]');
legend('theta real')%, 'theta obs')

figure(4)
hold on
grid on
title('trayectoria de la carga')
plot(xl_log.Data, yl_log.Data);
%legend('trayectoria')

figure(5)
hold on
grid on
title('Estimacion de Masa')
plot(real_mass_log.Time, real_mass_log.Data);
plot(est_mass_log.Time, est_mass_log.Data);
xlabel('Tiempo [s]');
ylabel('Masa [kg]');
legend('masa real', 'masa estimada')

figure(6)
hold on
grid on
title('Fuerzas de contacto')
plot(fcx_log.Time, fcx_log.Data);
plot(fcy_log.Time, fcy_log.Data);
xlabel('Tiempo [s]');
ylabel('Fuerza [N]');
legend('fcx', 'fcy')

figure(7)
hold on
grid on
title('Torque en izaje')
plot(thm_ref_log.Time, thm_ref_log.Data);
plot(thm_real_log.Time, thm_real_log.Data);
xlabel('Tiempo [s]');
ylabel('Torque [Nm]');
legend('ref', 'real')

figure(8)
hold on
grid on
title('Torque en carro')
plot(ttm_ref_log.Time, ttm_ref_log.Data);
plot(ttm_real_log.Time, ttm_real_log.Data);
xlabel('Tiempo [s]');
ylabel('Torque [Nm]');
legend('ref', 'real')

figure(9)
hold on
grid on
title('Velocidad de Izaje')
plot(dlh_ref_log.Time, dlh_ref_log.Data);
plot(dlh_real_log.Time, dlh_real_log.Data);
xlabel('Tiempo [s]');
ylabel('Velocidad [m/s]');
legend('ref', 'real')

figure(10)
hold on
grid on
title('Velocidad de Carro')
plot(dxt_ref_log.Time, dxt_ref_log.Data);
plot(dxt_real_log.Time, dxt_real_log.Data);
xlabel('Tiempo [s]');
ylabel('Velocidad [m/s]');
%plot(sway_ref_log.Time, sway_ref_log.Data);
legend('ref', 'real', 'sway ref')

