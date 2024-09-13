function [output_data] = Level1_OPC(input)
persistent init_server;
persistent init_nodes;
persistent uaClient;
persistent var_node_in;
persistent hoist_switches trolley_switches loadcell sway_angle hoist_angle trolley_angle;
persistent HOS LiDAR CycleSelect Mode AnalogH AnalogT EButton Reset DropOnBay DropOnShip;
persistent PickUpFromBay PickUpFromShip startAuto TLock Thm_ref Ttm_ref wd_reset
persistent hoist_reference_node dlh_node trolley_reference_node dxt_node sway_reference_node;
persistent m_node lh_node TLK_node hoist_brake_node hoist_ebrake_node trolley_brake_node;
persistent theta_node display_node;

hoist_reference = 0;
dlh = 0;
trolley_reference = 0;
dxt = 0;
sway_reference = 0;
m = 0;
lh = 0;
TLK = 0;
hoist_brake = 0;
hoist_ebrake = 0;
trolley_brake = 0;
theta = 0;
display = 0;


if (isempty(init_server) || input(24) == 0) %1 mas que el total de inputs
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
    hoist_switches = findNodeByName(var_node_in,'hoist_switches','-once');
    trolley_switches = findNodeByName(var_node_in,'trolley_switches','-once');
    loadcell = findNodeByName(var_node_in,'loadcell','-once');
    sway_angle = findNodeByName(var_node_in,'sway_angle','-once');
    hoist_angle = findNodeByName(var_node_in,'hoist_angle','-once');
    trolley_angle = findNodeByName(var_node_in,'hoist_switches','-once');
    HOS = findNodeByName(var_node_in,'HOS','-once');
    LiDAR = findNodeByName(var_node_in,'LiDAR','-once');
    CycleSelect = findNodeByName(var_node_in,'CycleSelect','-once');
    Mode = findNodeByName(var_node_in,'Mode','-once');
    AnalogH = findNodeByName(var_node_in,'AnalogH','-once');
    AnalogT = findNodeByName(var_node_in,'AnalogT','-once');
    EButton = findNodeByName(var_node_in,'EButton','-once');
    Reset = findNodeByName(var_node_in,'Reset','-once');
    DropOnShip = findNodeByName(var_node_in,'DropOnShip','-once');
    DropOnBay = findNodeByName(var_node_in,'DropOnBay','-once');
    PickUpFromShip = findNodeByName(var_node_in,'PickUpFromShip','-once');
    PickUpFromBay = findNodeByName(var_node_in,'PickUpFromBay','-once');
    startAuto = findNodeByName(var_node_in,'startAuto','-once');
    TLock = findNodeByName(var_node_in,'TLock','-once');
    Thm_ref = findNodeByName(var_node_in,'Thm_ref','-once');
    Ttm_ref = findNodeByName(var_node_in,'Ttm_ref','-once');
    wd_reset = findNodeByName(var_node_in,'wd_reset','-once');

    % Outputs
    hoist_reference_node = findNodeByName(var_node_in,'hoist_reference','-once');
    dlh_node = findNodeByName(var_node_in,'dlh','-once');
    trolley_reference_node = findNodeByName(var_node_in,'trolley_reference','-once');
    sway_reference_node = findNodeByName(var_node_in,'sway_reference','-once');
    dxt_node = findNodeByName(var_node_in,'dxt','-once');
    m_node = findNodeByName(var_node_in,'m','-once');
    lh_node = findNodeByName(var_node_in,'lh','-once');
    TLK_node = findNodeByName(var_node_in,'TLK','-once');
    hoist_brake_node = findNodeByName(var_node_in,'hoist_brake','-once');
    hoist_ebrake_node = findNodeByName(var_node_in,'hoist_ebrake','-once');
    trolley_brake_node = findNodeByName(var_node_in,'trolley_brake','-once');
    theta_node = findNodeByName(var_node_in,'theta','-once');
    display_node = findNodeByName(var_node_in,'display','-once');

end

if uaClient.isConnected == 1 && init_nodes == 1
    % Read values from OPC server (CODESYS)
    hoist_reference = readValue(uaClient,hoist_reference_node);
    dlh = readValue(uaClient,dlh_node);
    trolley_reference = readValue(uaClient,trolley_reference_node);
    dxt = readValue(uaClient,dxt_node);
    sway_reference = readValue(uaClient,sway_reference_node);
    m = readValue(uaClient,m_node);
    lh = readValue(uaClient,lh_node);
    TLK = readValue(uaClient,TLK_node);
    hoist_brake = readValue(uaClient,hoist_brake_node);
    hoist_ebrake = readValue(uaClient,hoist_ebrake_node);
    trolley_brake = readValue(uaClient,trolley_brake_node);
    theta = readValue(uaClient,theta_node);
    display = readValue(uaClient,display_node);
    

    % Write values to OPC server (CODESYS)
    writeValue(uaClient,hoist_switches,input(1));
    writeValue(uaClient,trolley_switches,input(2));
    writeValue(uaClient,loadcell,input(3));
    writeValue(uaClient,sway_angle,input(4));
    writeValue(uaClient,hoist_angle,input(5));
    writeValue(uaClient,trolley_angle,input(6));
    writeValue(uaClient,HOS,input(7));
    writeValue(uaClient,LiDAR,input(8));
    writeValue(uaClient,CycleSelect,input(9));
    writeValue(uaClient,Mode,input(10));
    writeValue(uaClient,AnalogH,input(11));
    writeValue(uaClient,AnalogT,input(12));
    writeValue(uaClient,EButton,input(13));
    writeValue(uaClient,Reset,input(14));
    writeValue(uaClient,DropOnBay,input(15));
    writeValue(uaClient,DropOnShip,input(16));
    writeValue(uaClient,PickUpFromBay,input(17));
    writeValue(uaClient,PickUpFromShip,input(18));
    writeValue(uaClient,startAuto,input(19));
    writeValue(uaClient,TLock,input(20));
    writeValue(uaClient,Thm_ref,input(21));
    writeValue(uaClient,Ttm_ref,input(22));
    writeValue(uaClient,wd_reset,input(23));

end

%% Write output data
output_data = double([hoist_reference, dlh, trolley_reference, dxt, sway_reference, m, lh, TLK, hoist_brake, hoist_ebrake, trolley_brake, theta, display]);

end