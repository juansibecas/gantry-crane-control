%function traj=traj_gen(profile,P0,Pf)
clear
close all
clc
%=========================================================================
profile(:,1)=(-10:0.1:20);
N=length(profile(:,1));
for i=1:N
    if i<N/3
        profile(i,2)=2;
    elseif i<N*1/2
        profile(i,2)=10;
    else
        profile(i,2)=4;
    end
end    

Pf=[-5 2];
P0=[14 4];
hseg=3;
xbox=3;
jh=1000;
jt=1000;


[T,Qhoist,Qtroley]=Traj_gen(profile,P0,Pf,3,2,5,5,10,10,50,50);


figure(10)
plot(profile(:,1),profile(:,2))
hold on
plot(Qtroley(1,:),Qhoist(1,:),'g')
% figure(3)
% plot(T,Qtroley(1,:))
% hold on
% plot(T,Qhoist(1,:))

function [T,Qhoist,Qtroley]=Traj_gen(profile,P0,Pf,v0h,vfh,vmaxh,vmaxt,a0h,afh,amaxh,amaxt)
% Esta función genera una trayectoria para un sistema de elevación, como un
% montacargas o una grúa, en función de un perfil de elevación dado. 
% La trayectoria contempla aceleración con perfil trapeziodal.
% Busca generar una trayectoria eficiente donde evite los obstaculos con un
% marquen dado.
% Además admite casos donde la la aceleracion maxima o la velocidad maxima sean
% mayores a las posible para un determinado recorrido. Estos casos de
% diminuye automaticamente su valor para cumplir con los otros
% requirimientos.
%
% Argumentos de entrada:
% - profile: matriz que contiene el perfil de elevación. Cada fila representa
%   un punto en el perfil, donde la primera columna contiene las coordenadas
%   horizontales y la segunda columna contiene las alturas correspondientes.
% - P0: punto inicial de la trayectoria, dado como [x0, y0].
% - Pf: punto final de la trayectoria, dado como [xf, yf].
% - v0h: velocidad inicial de elevación.
% - vfh: velocidad final de elevación.
% - vmaxh: velocidad máxima de elevación.
% - vmaxt: velocidad máxima de desplazamiento horizontal.
% - a0h: aceleración inicial de elevación.
% - afh: aceleración final de elevación.
% - amaxh: aceleración máxima de elevación.
% - amaxt: aceleración máxima de desplazamiento horizontal.
%
% Las siguientes variables se toman del espacio de trabajo (workspace):
% - hseg: altura de seguridad adicional a considerar.
% - xbox: distancia horizontal alrededor de los puntos iniciales y finales
%   para buscar el perfil.
% - jh: jerk máximo permitido en la elevación.
% - jt: jerk máximo permitido en el desplazamiento horizontal.
%
% Argumentos de salida:
% - T: vector de tiempo de la trayectoria generada.
% - Qhoist: matriz que describe la trayectoria de elevación generada.
%   Siento las filas Q(1,:) la posición, Q(2,:) la velocidad,
%   Q(3,:)aceleracion y Q(4,:) el jerk
% - Qtroley: matriz que describe la trayectoria de desplazamiento horizontal
%   generada. misma estructura que Qtroley
    hseg = evalin('caller', 'hseg');
    xbox = evalin('caller', 'xbox');
    jh = evalin('caller', 'jh');
    jt = evalin('caller', 'jt');
    


    %=========================================================================
    %Calculo de puntos
    %=========================================================================
    %recortar profile entre x0 y xf (profile_r)
    profile_r=subprofile(profile,P0(1),Pf(1));

    %Hmax es igual a la altula maxima en profile_r mas una altura de seguridad "h_seg"
    Hmax=max(profile_r(:,2))+hseg;

    %H0 es la altura que parte de Y0 y termina cuando el profile es superado en
    %un entorno de 1.5 xbox de X0 mas h_seg.
    H0=max(subprofile(profile,P0(1)-xbox*1.5,P0(1)+xbox*1.5))+hseg;
    H0=H0(2);
    %H1 lo mismo
    Hf=max(subprofile(profile,Pf(1)-xbox*1.5,Pf(1)+xbox*1.5))+hseg;
    Hf=Hf(2);
    %se traza una recta entre xo y el se la hace "tangente" (que solo toca un 
    %punto del profile)

    if Pf(1)>P0(1)
        xl=P0(1);
        xh=Pf(1);
        Hl=H0;
        Hh=Hf;
    else
        xh=P0(1);
        xl=Pf(1);
        Hh=H0;
        Hl=Hf;
    end

    mmax=0;
    prof=subprofile(profile,xl+xbox*0.5,inf);
    for i=1:length(prof)
        if prof(i,2)+hseg<Hl
            continue
        end
        if (prof(i,2)+hseg-Hl)/(prof(i,1)-xbox-xl(1))>mmax
            mmax=(prof(i,2)-Hl+hseg)/(prof(i,1)-xl(1)-xbox);
        end
    end
    DXl=(Hmax-Hl)/mmax;

    mmax=0;
    prof=subprofile(profile,xh-xbox*0.5,-inf);
    for i=1:length(prof)
        if prof(i,2)+hseg<Hh
            continue
        end
        if (prof(i,2)+hseg-Hh)/(prof(i,1)+xbox-xh(1))<mmax
            mmax=(prof(i,2)-Hh+hseg)/(prof(i,1)-xh(1)+xbox);
        end
    end
    DXh=(Hmax-Hh)/mmax;

    if Pf(1)>P0(1)
        x02=P0(1)+DXl;
        xf2=Pf(1)+DXh;
    else
        x02=P0(1)+DXh;
        xf2=Pf(1)+DXl;
    end

    %graficar
    %figure(10)
    %plot(profile(:,1),profile(:,2))
    %hold on
    %plot(profile_r(:,1),profile_r(:,2))
    %plot(x02,Hmax,'x')
    %plot(xf2,Hmax,'x')
    %plot(P0(1),H0,'x')
    %plot(Pf(1),Hf,'x')
    %plot(P0(1),P0(2),'x')
    %plot(Pf(1),Pf(2),'x')

    %end
    %=========================================================================
    %Calculo de trayectoria
    %=========================================================================
    %trap_acc_prof(p0, pf, v0, vf, a0, af, vmax, amax, jk)
    %disp("raise---------------------------")
    [Traise,Qraise] = trap_acc_prof(P0(2),Hmax,v0h,0,a0h,0,vmaxh,amaxh,jh);
    %disp("lower-------------------------------")
    [Tlower,Qlower] = trap_acc_prof(Hmax,Pf(2),0,vfh,0,afh,vmaxh,amaxh,jh);
    %disp("slide----------------------")
    [Tslide, Qslide] = trap_acc_prof(P0(1),Pf(1),0,0,0,0,vmaxt,amaxt,jt);
    %disp("----")

    % Configuración de los subplots
%     num_plots = size(Qslide, 1); % Número de vectores en Qslide
%     num_rows = ceil(sqrt(num_plots)); % Número de filas de subplots
%     num_cols = ceil(num_plots / num_rows); % Número de columnas de subplots

    % Crear figura para subplots
%     figure;
% 
%     % Plotear los vectores Qslide utilizando subplots
%     for i = 1:num_plots
%         subplot(num_rows, num_cols, i);
%         plot(Tslide, Qslide(i, :));
%         title(['Qslide(', num2str(i), ', :)']);
    %    xlabel('Tiempo');
    %    ylabel('Qslide');
    %end
    %disp(Qlower(1,:))
    %figure(2)
    %plot(Tlower,Qlower(1,:))
    %figure(3)
    %plot(Tlower,Qlower(2,:))
    %figure(4)
    %plot(Tlower,Qlower(3,:))
    %figure(5)
    %plot(Tlower,Qlower(4,:))
    %-----------------------------------------------------------------------
    N0x=time_between(Qslide(1,:),Tslide,P0(1),x02);
    N0y=time_between(Qraise(1,:),Traise,Hmax,H0);

    if N0y>N0x
        Qtroley=zeros(4,length(Traise)-N0x);
        Qtroley(1,:)=Qslide(1,1);
        Qtroley=[Qtroley Qslide];
        T=[Traise(1:length(Traise)-N0x) Tslide+Traise(length(Traise)-N0x)];
    else
        Qtroley=zeros(4,length(Traise)-N0y);
        Qtroley(1,:)=Qslide(1,1);
        Qtroley=[Qtroley Qslide];
        T=[Traise(1:length(Traise)-N0y) Tslide+Traise(length(Traise)-N0y)];
    end
    %-----------------------------------------------------------------------
    Nfx=time_between(Qslide(1,:),Tslide,Pf(1),xf2);
    Nfy=time_between(Qlower(1,:),Tlower,Hmax,Hf);

    if Nfx>Nfy
        aux=zeros(4,length(Tlower)-Nfy);
        aux(1,:)=Qslide(1,end);
        Qtroley=[Qtroley aux];
        T=[T T(end)+Tlower(1:length(Tlower)-Nfy)];
    else
        aux=zeros(4,length(Tlower)-Nfx);
        aux(1,:)=Qslide(1,end);
        Qtroley=[Qtroley aux];
        T=[T T(end)+Tlower(1:length(Tlower)-Nfx)];
    end
    
    %-----------------------------------------------------------------------
    Qhoist=zeros(4,length(Qtroley)-length(Qlower)-length(Qraise));
    Qhoist(1,:)=Hmax;
    Qhoist=[Qraise Qhoist Qlower];
end






function [T,Q] = trap_acc_prof(p0, pf, v0, vf, a0, af, vmax, amax, jk)
    if p0>pf
        vmax=-vmax;
        amax=-amax;
        jk=-jk;    
    end
    amax0=amax;
    amaxf=amax;
  
    [t1,t2,t3,t4,t5,t6,t7]=times_trap_acc_prof(p0, pf, v0, vf, a0, af, vmax, amax0, amaxf, jk);
    

        while t2<0
            amax0=amax0*0.99;
            [t1,t2,t3,t4,t5,t6,t7]=times_trap_acc_prof(p0, pf, v0, vf, a0, af, vmax, amax0, amaxf, jk);
        end
        if t2<=0
            a=-1/jk;
            c=vmax-v0+a0^2/jk/2;
            amax0=sign(amax)*abs(sqrt(- 4 * a * c) / 2 / a);
            [t1,t2,t3,t4,t5,t6,t7]=times_trap_acc_prof(p0, pf, v0, vf, a0, af, vmax, amax0, amaxf, jk);   
        end

        if t6<=0
            a=1/jk;
            c=vf-vmax-af^2/jk/2;
            amaxf=sign(amax)*abs(sqrt(- 4 * a * c) / 2 / a);
            [t1,t2,t3,t4,t5,t6,t7]=times_trap_acc_prof(p0, pf, v0, vf, a0, af, vmax, amax0, amaxf, jk);   
        end
        
        while t2<0 || t6<0 ||t4<0
            if t2<0
                amax0=amax0*0.97;
            end
            if t6<0
                amaxf=amaxf*0.97;
            end
            if t4<0
                vmax=vmax*0.97;
            end
                
            [t1,t2,t3,t4,t5,t6,t7]=times_trap_acc_prof(p0, pf, v0, vf, a0, af, vmax, amax0, amaxf, jk);   
        end



dt=0.00001;
T1=0:sign(t1)*dt:t1;
T2=0:sign(t2)*dt:t2;
T3=0:sign(t3)*dt:t3;
T4=0:sign(t4)*dt:t4;
T5=0:sign(t5)*dt:t5;
T6=0:sign(t6)*dt:t6;
T7=0:sign(t7)*dt:t7;


Q1=zeros(4,length(T1));
Q2=zeros(4,length(T2));
Q3=zeros(4,length(T3));
Q4=zeros(4,length(T4));
Q5=zeros(4,length(T5));
Q6=zeros(4,length(T6));
Q7=zeros(4,length(T7));


for i=1:length(T1)
Q1(:,i)=const_j(p0,v0,a0,jk,T1(i));
end
for i=1:length(T2)
Q2(:,i)=const_j(Q1(1,end),Q1(2,end),amax0,0,T2(i));
end

for i=1:length(T3)
Q3(:,i)=const_j(Q2(1,end),Q2(2,end),amax0,-jk,T3(i));
end
for i=1:length(T4)
Q4(:,i)=const_j(Q3(1,end),vmax,0,0,T4(i));
end
for i=1:length(T5)
Q5(:,i)=const_j(Q4(1,end),vmax,0,-jk,T5(i));
end
for i=1:length(T6)
Q6(:,i)=const_j(Q5(1,end),Q5(2,end),-amaxf,0,T6(i));
end
for i=1:length(T7)
Q7(:,i)=const_j(Q6(1,end),Q6(2,end),-amaxf,jk,T7(i));
end
 
 Q=[Q1 Q2 Q3 Q4 Q5 Q6 Q7];
 
 T=[T1 T2+t1 T3+t1+t2 T4+t1+t2+t3 T5+t1+t2+t3+t4 T6+t1+t2+t3+t4+t5 T7+t1+t2+t3+t4+t5+t6];

end


function [t1,t2,t3,t4,t5,t6,t7] = times_trap_acc_prof(p0, pf, v0, vf, a0, af, vmax, amax0, amaxf, jk)

 %Etapa 1 - jerk constante 
    t1=(amax0-a0)/jk;
    v1=v0+a0*t1+0.5*jk*t1^2;
    p1=p0+v0*t1+0.5*a0*t1^2+(1/6)*jk*t1^3;

 %Etapa 3 - jkerk constante
    t3=amax0/jk;
    v2=vmax-amax0*t3+0.5*jk*t3^2;
    %p3=?
    
 %Etapa 2 - aceleracion constante
    t2=(v2-v1)/amax0;
    p2=p1+v1*t2+0.5*amax0*t2^2;
    %etapa 3
    p3=p2+v2*t3+0.5*amax0*t3^2-(1/6)*jk*t3^3;
 
 %Etapa 7 - jerk constante
    t7=(af-(-amaxf))/jk;
    v6=vf+amaxf*t7-0.5*jk*t7^2;
    p6=pf-v6*t7+0.5*amaxf*t7^2-(1/6)*jk*t7^3; 
 
 %Etapa 5 - jerk constante
    t5=amaxf/jk;
    v5=vmax-0.5*jk*t5^2;
    %p4=?
    
 %Etapa 6 - aceleracion constante
    t6=(v6-v5)/-amaxf;
    p5=p6-v5*t6+0.5*amaxf*t6^2;
    %etapa 5
    p4=p5-vmax*t5+(1/6)*jk*t5^3;

 %Etapa 4 - velocidad constante
    t4=(p4-p3)/vmax;
 
end


function Q=const_j(p0,v0,a0,jk,t)
Q=zeros(4,1);
Q(4)=jk;
Q(3)=a0+jk*t;
Q(2)=v0+a0*t+0.5*jk*t^2;
Q(1)=p0+v0*t+0.5*a0*t^2+(1/6)*jk*t^3;

 
end

function num_puntos = time_between(Q, ~, x0, x1)
    % Encontrar el índice más cercano a x0 en Q
    [~, i0] = min(abs(Q - x0));
    
    % Verificar si x0 es menor o mayor que el valor correspondiente en Q
    if x0 < Q(i0)
        i0 = i0 - 1;
    end
    
    % Encontrar el índice más cercano a x1 en Q
    [~, i1] = min(abs(Q - x1));
    
    % Verificar si x1 es menor o mayor que el valor correspondiente en Q
    if x1 < Q(i1)
        i1 = i1 - 1;
    end
    
    % Calcular la cantidad de puntos entre las posiciones x0 y x1
    num_puntos = abs(i1 - i0);
end










function subprof=subprofile(vector,x0,xf)
    if x0>xf
        xmin=xf;
        xmax=x0;
    else
        xmin=x0;
        xmax=xf;
    end
    imin=1;
    while vector(imin,1)<xmin
        imin=imin+1;
        if imin>=length(vector(:,1))
            break
        end
    end
    imax=length( vector(:,1));
    while vector(imax,1)>xmax
        imax=imax-1;
        if imin<=1
            break
        end
    end
    subprof=vector(imin:imax,:);
end