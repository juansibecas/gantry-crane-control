function [output_data] = Level2_OPC(input)
persistent init_server;
persistent init_nodes;
persistent uaClient;
persistent var_node_in;
persistent %alert alert_t alert_h alert_wd;
persistent %fdct_r fdct_l fdch_up fdch_down emergency_button;
persistent %wd_in wd_reset manual_reset;

Alert_t = 0;
Alert_wd = 0;
Alert_h = 0;
Alert = 0;

if (isempty(init_server) || input(9)==0)
    init_server = 0;
    init_nodes = 0;
end
if init_server == 0
    init_server = 1;
    uaClient = opcua('localhost',4840);
    connect(uaClient);
end

if uaClient.isConnected == 1 && init_nodes == 0
    init_nodes = 1;
    % OPC nodes %%cambiar PLC_PRG si hace falta
    var_node_in = findNodeByName(uaClient.Namespace,'PLC_PRG','-once');
    % Inputs
    %fdct_l = findNodeByName(var_node_in,'fdct_l','-once');

    % Outputs
    %alert_t = findNodeByName(var_node_in,'alert_t','-once');

end

if uaClient.isConnected == 1 && init_nodes == 1
    % Read values from OPC server (CODESYS)
    %[Alert_t,~,~]= readValue(uaClient,alert_t);

    % Write values to OPC server (CODESYS)
    %writeValue(uaClient,fdct_r,input(1));

end

%% Write output data
%output_data = double([Alert_t,Alert_h,Alert,Alert_wd]);

end