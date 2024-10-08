%% GENERATE FULL OBSTACLE PROFILE
cols = length(containerLayout);
containerWidth_ = 2.5;
xmin = -35;
xmax = 55;
dx = 0.1;
N = (xmax - xmin)/dx + 1;
Ob_profile = zeros(N,2);
Ob_profile(:,1) = (xmin:dx:xmax)';

% Loading Bay1 - Bahia de carga 
Ob_profile=ObstUpdate(Ob_profile, -23.25, -20.75, 1);

% Loading Bay2 - Bahia de carga 
Ob_profile=ObstUpdate(Ob_profile, -16.25, -13.75, 3.5);

% Loading Bay3 - Bahia de carga 
Ob_profile=ObstUpdate(Ob_profile, -9.25, -6.75, 3.5);

% Sill Beam - Viga Grua
Ob_profile=ObstUpdate(Ob_profile,-2,0,Ysb);

% Gap 
Ob_profile=ObstUpdate(Ob_profile,0,0.5,-2);

% Ship wall - Pared barco
Ob_profile=ObstUpdate(Ob_profile,0.5,1.5,5);

% Ship floor - Piso barco
Ob_profile=ObstUpdate(Ob_profile,1.5,24,-19);

% Container stack
for i=1:cols
    Ob_profile=ObstUpdate(Ob_profile, 1.5+(i-1)*Hc, 1.5+i*Hc, containerLayout(i)*Hc-19);
end

% Ship wall - Pared barco
Ob_profile=ObstUpdate(Ob_profile,24,25,5);

% plot(Ob_profile(:,1), Ob_profile(:,2))
    
function NewProfile=ObstUpdate(OldProfile,x0,x1,y)
    NewProfile=OldProfile;
    i=1;
    while NewProfile(i,1)<x0
        i=i+1;
    end
    while NewProfile(i,1)<x1
        i=i+1;
        NewProfile(i,2)=y;
    end
end