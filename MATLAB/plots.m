%% Plots and performance checks
logs = out.logsout;
time = out.tout;
%% Torque inputs

thm_ref_log = logs.getElement('Thm*').Values.Data;
thm_real_log = logs.getElement('Thm').Values.Data;
ttm_ref_log = logs.getElement('Ttm*').Values.Data;
ttm_real_log = logs.getElement('Ttm').Values.Data;

%% Mass estimation

loadcell_log = logs.getElement('loadcell').Values.Data;
est_mass_log = logs.getElement('est_mass').Values.Data;

%% Load X-Y coordinates

xl_log = logs.getElement('xl').Values.Data;
yl_log = logs.getElement('yl').Values.Data;

vlx_log = logs.getElement('vlx').Values.Data;
vly_log = logs.getElement('vly').Values.Data;


%% Trolley and Hoist real profiles

lh_real_log = logs.getElement('lh_real').Values.Data;
dlh_real_log = logs.getElement('dlh_real').Values.Data;
ddlh_real_log = logs.getElement('ddlh_real').Values.Data;

xt_real_log = logs.getElement('xt_real').Values.Data;
dxt_real_log = logs.getElement('dxt_real').Values.Data;
ddxt_real_log = logs.getElement('ddxt_real').Values.Data;

theta_real_log = logs.getElement('theta_real').Values.Data;

%% Trolley and Hoist observed profiles

lh_obs_log = logs.getElement('lh_obs').Values.Data;
dlh_obs_log = logs.getElement('dlh_obs').Values.Data;
ddlh_obs_log = logs.getElement('ddlh_obs').Values.Data;

xt_obs_log = logs.getElement('xt_obs').Values.Data;
dxt_obs_log = logs.getElement('dxt_obs').Values.Data;
ddxt_obs_log = logs.getElement('ddxt_obs').Values.Data;

theta_obs_log = logs.getElement('theta_obs').Values.Data;
dtheta_obs_log = logs.getElement('dtheta_obs').Values.Data;
ddtheta_obs_log = logs.getElement('ddtheta_obs').Values.Data;


%% Observer performance

figure(1)
hold on
grid on
plot(time, lh_real_log);
plot(time, lh_obs_log);
legend('lh real', 'lh obs')

figure(2)
hold on
grid on
plot(time, dlh_real_log);
plot(time, dlh_obs_log);
legend('dlh real', 'dlh obs')

figure(3)
hold on
grid on
plot(time, ddlh_real_log);
plot(time, ddlh_obs_log);
legend('ddlh real', 'ddlh obs')


