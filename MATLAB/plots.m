%% Plots and performance checks
logs = out.logsout;
time = out.tout;
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
deltalh_obs_log = logs.getElement('deltalh_obs').Values;
dlh_obs_log = logs.getElement('dlh_obs').Values;
ddlh_obs_log = logs.getElement('ddlh_obs').Values;

xt_obs_log = logs.getElement('xt_obs').Values;
deltaxt_obs_log = logs.getElement('deltaxt_obs').Values;
dxt_obs_log = logs.getElement('dxt_obs').Values;
ddxt_obs_log = logs.getElement('ddxt_obs').Values;

theta_obs_log = logs.getElement('theta_obs').Values;
dtheta_obs_log = logs.getElement('dtheta_obs').Values;
ddtheta_obs_log = logs.getElement('ddtheta_obs').Values;


%% Plots

figure(1)
hold on
grid on
title('observador carro')
plot(xt_real_log.Time, xt_real_log.Data);
plot(xt_obs_log.Time, xt_obs_log.Data);
legend('xt real', 'xt obs')

figure(2)
hold on
grid on
title('observador izaje')
plot(lh_real_log.Time, lh_real_log.Data);
plot(lh_obs_log.Time, lh_obs_log.Data);
legend('lh real', 'lh obs')

figure(3)
hold on
grid on
title('observador balanceo')
plot(theta_real_log.Time, theta_real_log.Data);
plot(theta_obs_log.Time, theta_obs_log.Data);
legend('theta real', 'theta obs')

figure(4)
hold on
grid on
title('trayectoria de la carga')
plot(xl_log.Data, yl_log.Data);
%legend('trayectoria')

figure(5)
hold on
grid on
title('estimacion de masa')
plot(real_mass_log.Time, real_mass_log.Data);
plot(est_mass_log.Time, est_mass_log.Data);
legend('masa real', 'masa estimada')

figure(6)
hold on
grid on
title('Fuerzas de contacto')
plot(fcx_log.Time, fcx_log.Data);
plot(fcy_log.Time, fcy_log.Data);
legend('fcx', 'fcy')

figure(7)
hold on
grid on
title('Torque en izaje')
plot(thm_ref_log.Time, thm_ref_log.Data);
plot(thm_real_log.Time, thm_real_log.Data);
legend('ref', 'real')

figure(8)
hold on
grid on
title('Torque en carro')
plot(ttm_ref_log.Time, ttm_ref_log.Data);
plot(ttm_real_log.Time, ttm_real_log.Data);
legend('ref', 'real')

