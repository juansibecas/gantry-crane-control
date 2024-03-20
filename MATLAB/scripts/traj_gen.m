%function traj=traj_gen(profile,P0,Pf)
clear
close
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
P0=[15 4];
hseg=3;
xbox=3;
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
plot(profile(:,1),profile(:,2))
hold on
plot(profile_r(:,1),profile_r(:,2))
plot(x02,Hmax,'x')
plot(xf2,Hmax,'x')
plot(P0(1),H0,'x')
plot(Pf(1),Hf,'x')
plot(P0(1),P0(2),'x')
plot(Pf(1),Pf(2),'x')
%end
%=========================================================================
%Calculo de trajectoria
%=========================================================================


[Q, vf_real] = trap_acc_prof([P0(1) H0],[x02 Hmax],[0,1],[1,0],[1,1],[0 0],[10,10],[20,20]);


plot(Q(1,:),Q(2,:))


function [Q, vf_real] = trap_acc_prof(p0, pf, v0, vf, a0, vmax, amax, j)
    
 %Etapa 1 - jerk constante 
    t1=(amax-a0)/j;
    v1=v0+a0*t1+0.5*j*t1^2;
    p1=p0+v0*t1+0.5*a0*t1^2+(1/6)*j*t1^3;
    
 %Etapa 3 - jerk constante
    t3=amax/j;
    v2=vmax-amax*t3+0.5*t3^2;
    %p3=?
    
 %Etapa 2 - aceleracion constante
    t2=(v2-v1)/amax;
    p2=p1+v1*t2+0.5*amax*t2^2;
    %etapa 3
    p3=p2+v2*t3+0.5*amax*t3^2-(1/6)*j*t3^3;
 
 %Etapa 7 - jerk constante
    af=[0 0];
    t7=(af-(-amax))/j;
    v6=vf+amax*t7-0.5*j*t7^2;
    p6=pf-v6*t7+0.5*amax*t7^2-(1/6)*j*t7^3;
 
 %Etapa 5 - jerk constante
    t5=amax/j;
    v5=vmax-0.5*j*t5^2;
    %p4=?
    
 %Etapa 6 - aceleracion constante
    t6=(v6-v5)/-amax;
    p5=p6-v5*t6+0.5*amax*t6^2;
    %etapa 5
    p4=p5-vmax*t5+(1/6)*j*t6^3;
    
    
 %Etapa 4 - velocidad constante
    t4=(p4-p3)/vmax;
    
 dt=0.1;
 Q1=const_j(p0,v0,a0,j,0:dt:t1);
 Q2=const_j(Q1(1,-1),Q1(2,-1),amax,0,0:dt:t2);
 Q3=const_j(Q2(1,-1),Q2(2,-1),amax,-j,0:dt:t2);
 Q4=const_j(Q3(1,-1),vmax,0,0,0:dt:t2);


 
 
 Q=[Q1;Q2;Q3;Q4];
 
 
    
    
    
end


function Q=const_j(p0,v0,a0,j,t)
Q=zeros(4);
Q(4)=j;
Q(3)=a0+j*t;
Q(2)=v0+a0*t+0.5*j*t^2;
Q(1)=p0+v0*t+0.5*a0*t^2+(1/6)*j*t^3;

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