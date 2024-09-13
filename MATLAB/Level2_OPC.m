function [output_data] = Level2_OPC(input)
persistent init_server;
persistent init_nodes;
persistent uaClient;
persistent var_node_in;
persistent Thm_ref_node Ttm_ref_node;
persistent dlh_ref dxt_ref dlh dxt Fhw theta m lh ddxt_ref;

Ttm_ref = 0;
Thm_ref = 0;

if (isempty(init_server) || input(10)==0)
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
    dlh_ref = findNodeByName(var_node_in,'dlh_ref','-once');
    dxt_ref = findNodeByName(var_node_in,'dxt_ref','-once');
    dlh = findNodeByName(var_node_in,'dlh','-once');
    dxt = findNodeByName(var_node_in,'dxt','-once');
    Fhw = findNodeByName(var_node_in,'Fhw','-once');
    theta = findNodeByName(var_node_in,'theta','-once');
    m = findNodeByName(var_node_in,'m','-once');
    lh = findNodeByName(var_node_in,'lh','-once');
    ddxt_ref = findNodeByName(var_node_in,'ddxt_ref','-once');

    % Outputs
    %alert_t = findNodeByName(var_node_in,'alert_t','-once');
    Ttm_ref_node = findNodeByName(var_node_in,'Ttm_ref','-once');
    Thm_ref_node = findNodeByName(var_node_in,'Thm_ref','-once');

end

if uaClient.isConnected == 1 && init_nodes == 1
    % Read values from OPC server (CODESYS)
    Ttm_ref = readValue(uaClient, Ttm_ref_node);
    Thm_ref = readValue(uaClient, Thm_ref_node);

    % Write values to OPC server (CODESYS)
    writeValue(uaClient, dlh_ref, input(1));
    writeValue(uaClient, dxt_ref, input(2));
    writeValue(uaClient, dlh, input(3));
    writeValue(uaClient, dxt, input(4));
    writeValue(uaClient, Fhw, input(5));
    writeValue(uaClient, theta, input(6));
    writeValue(uaClient, lh, input(7));
    writeValue(uaClient, m, input(8));
    writeValue(uaClient, ddxt_ref, input(9));
end

%% Write output data
output_data = double([Ttm_ref, Thm_ref]);

end