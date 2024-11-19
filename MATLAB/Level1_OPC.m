function [output_data] = Level1_OPC(input)
%% declare opc nodes
persistent init_server;
persistent init_nodes;
persistent uaClient;
persistent var_node_in;
persistent hoist_switches trolley_switches loadcell sway_angle hoist_angle trolley_angle;
persistent hoist_speed trolley_speed homing;
persistent HOS LiDAR CycleSelect Mode AnalogH AnalogT DropOnBay DropOnShip;
persistent PickUpFromBay PickUpFromShip startAuto TLock;

persistent hoist_reference_node trolley_reference_node sway_reference_node;
persistent m_node TLK_node hoist_brake1_node trolley_brake1_node;
persistent display_node L0_node X0_node ddxt_ref_node ddlh_ref_node sway_control_node;

%% init outputs = 0
hoist_reference = 0;
trolley_reference = 0;
sway_reference = 0;
m = 0;
TLK = 0;
hoist_brake1 = 0;
trolley_brake1 = 0;
display = 0;
L0 = 0;
X0 = 0;
ddxt_ref = 0;
ddlh_ref = 0;
sway_control = 0;


if (isempty(init_server) || input(24) == 0) %1 mas que el total de inputs
    init_server = 0;
    init_nodes = 0;
end
if init_server == 0
    init_server = 1;
    uaClient = opcua('localhost',4840);
    connect(uaClient);
end

%% Init OPC Nodes
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
    hoist_speed = findNodeByName(var_node_in,'hoist_speed','-once');
    trolley_angle = findNodeByName(var_node_in,'trolley_angle','-once');
    trolley_speed = findNodeByName(var_node_in,'trolley_speed','-once');
    HOS = findNodeByName(var_node_in,'HOS','-once');
    LiDAR = findNodeByName(var_node_in,'LiDAR','-once');
    CycleSelect = findNodeByName(var_node_in,'CycleSelect','-once');
    AnalogH = findNodeByName(var_node_in,'AnalogH','-once');
    AnalogT = findNodeByName(var_node_in,'AnalogT','-once');
    Mode = findNodeByName(var_node_in,'Mode','-once');
    DropOnShip = findNodeByName(var_node_in,'DropOnShip','-once');
    DropOnBay = findNodeByName(var_node_in,'DropOnBay','-once');
    PickUpFromShip = findNodeByName(var_node_in,'PickUpFromShip','-once');
    PickUpFromBay = findNodeByName(var_node_in,'PickUpFromBay','-once');
    startAuto = findNodeByName(var_node_in,'startAuto','-once');
    TLock = findNodeByName(var_node_in,'TLock','-once');
    homing = findNodeByName(var_node_in,'homing','-once');

    % Outputs
    hoist_reference_node = findNodeByName(var_node_in,'hoist_reference','-once');
    trolley_reference_node = findNodeByName(var_node_in,'trolley_reference','-once');
    sway_reference_node = findNodeByName(var_node_in,'sway_reference','-once');
    m_node = findNodeByName(var_node_in,'m','-once');
    TLK_node = findNodeByName(var_node_in,'TLK','-once');
    hoist_brake1_node = findNodeByName(var_node_in,'hoist_brake','-once');
    trolley_brake1_node = findNodeByName(var_node_in,'trolley_brake','-once');
    display_node = findNodeByName(var_node_in,'display','-once');
    L0_node = findNodeByName(var_node_in,'L0','-once');
    X0_node = findNodeByName(var_node_in,'X0','-once');
    ddxt_ref_node = findNodeByName(var_node_in,'ddxt_ref','-once');
    ddlh_ref_node = findNodeByName(var_node_in,'ddlh_ref','-once');
    sway_control_node = findNodeByName(var_node_in,'sway_control','-once');

end

%% Read/Write OPC

if uaClient.isConnected == 1 && init_nodes == 1
    % Read values from OPC server (CODESYS)
    hoist_reference = readValue(uaClient,hoist_reference_node);
    trolley_reference = readValue(uaClient,trolley_reference_node);
    sway_reference = readValue(uaClient,sway_reference_node);
    m = readValue(uaClient,m_node);
    display = readValue(uaClient, display_node);
    TLK = readValue(uaClient,TLK_node);
    hoist_brake1 = readValue(uaClient,hoist_brake1_node);
    trolley_brake1 = readValue(uaClient,trolley_brake1_node);
    L0 = readValue(uaClient,L0_node);
    X0 = readValue(uaClient,X0_node);
    ddxt_ref = readValue(uaClient,ddxt_ref_node);
    ddlh_ref = readValue(uaClient,ddlh_ref_node);
    sway_control = readValue(uaClient,sway_control_node);
    

    % Write values to OPC server (CODESYS)
    writeValue(uaClient,hoist_switches,input(1));
    writeValue(uaClient,trolley_switches,input(2));
    writeValue(uaClient,loadcell,input(3));
    writeValue(uaClient,sway_angle,input(4));
    writeValue(uaClient,hoist_angle,input(5));
    writeValue(uaClient,hoist_speed,input(6));
    writeValue(uaClient,trolley_angle,input(7));
    writeValue(uaClient,trolley_speed,input(8));
    writeValue(uaClient,HOS,input(9));
    writeValue(uaClient,LiDAR,input(10));
    writeValue(uaClient,CycleSelect,input(11));
    writeValue(uaClient,AnalogH,input(12));
    writeValue(uaClient,AnalogT,input(13));
    writeValue(uaClient,Mode,input(14));
    writeValue(uaClient,PickUpFromShip,input(15));
    writeValue(uaClient,DropOnShip,input(16));
    writeValue(uaClient,PickUpFromBay,input(17));
    writeValue(uaClient,DropOnBay,input(18));
    writeValue(uaClient,startAuto,input(19));
    writeValue(uaClient,TLock,input(20));
    writeValue(uaClient,homing,input(21));

end

%% Write output signal
output_data = double([
    hoist_reference,
    trolley_reference, 
    sway_reference, 
    display, 
    hoist_brake1, 
    trolley_brake1, 
    TLK, 
    m, 
    L0, 
    X0, 
    ddxt_ref, 
    ddlh_ref, 
    sway_control]);

end