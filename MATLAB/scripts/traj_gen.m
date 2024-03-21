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
figure(10)
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
%Calculo de trayectoria
%=========================================================================

[Traise,Qraise] = trap_acc_prof(P0(2),Hmax,0,0,0,5,30,500);
[Tlower,Qlower] = trap_acc_prof(Hmax,Pf(2),0,0,0,5,30,500);
[Tslide, Qslide] = trap_acc_prof(P0(1),Pf(1),0,0,0,5,30,500);

%figure(2)
%plot(Tlower,Qlower(1,:))
%figure(3)
%plot(Tlower,Qlower(2,:))
%figure(4)
%plot(Tlower,Qlower(3,:))
%figure(5)
%plot(Tlower,Qlower(4,:))

iy=length(Traise);
while Qraise(1,iy)>H0
    iy=iy-1;
end
T02y=Tlower(end)-Tlower(iy);
ix=1;
while Qslide(1,ix)<x02
    ix=ix+1;
end
T02x=Tslide(ix);

if T02y>T02x
    Qtroley=zeros(4,length(Traise)-ix);
    Qtroley(1,:)=Qslide(1,1);
    Qtroley=[Qtroley Qslide];
    T=[Traise(1:length(Traise)-ix) Tslide+Traise(length(Traise)-ix)];
else
    Qtroley=zeros(4,length(Traise)-iy);
    Qtroley(1,:)=Qslide(1,1);
    Qtroley=[Qtroley Qslide];
    T=[Traise(1:length(Traise)-iy) Tslide+Traise(length(Traise)-iy)];
end







function [T,Q] = trap_acc_prof(p0, pf, v0, vf, a0, vmax, amax, j)
    
 %Etapa 1 - jerk constante 
    t1=(amax-a0)/j;
    v1=v0+a0*t1+0.5*j*t1^2;
    p1=p0+v0*t1+0.5*a0*t1^2+(1/6)*j*t1^3;
    
 %Etapa 3 - jerk constante
    t3=amax/j;
    v2=vmax-amax*t3+0.5*j*t3^2;
    %p3=?
    
 %Etapa 2 - aceleracion constante
    t2=(v2-v1)/amax;
    p2=p1+v1*t2+0.5*amax*t2^2;
    %etapa 3
    p3=p2+v2*t3+0.5*amax*t3^2-(1/6)*j*t3^3;
 
 %Etapa 7 - jerk constante
    af=0;
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
    t4=abs(p4-p3)/vmax;
    
dt=0.001;
T1=0:dt:t1;
T2=0:dt:t2;
T3=0:dt:t3;
T4=0:dt:t4;
T5=0:dt:t5;
T6=0:dt:t6;
T7=0:dt:t7;
Q1=zeros(4,length(T1));
Q2=zeros(4,length(T2));
Q3=zeros(4,length(T3));
Q4=zeros(4,length(T4));
Q5=zeros(4,length(T5));
Q6=zeros(4,length(T6));
Q7=zeros(4,length(T7));
disp("--------------")
disp(t1)
disp(t2)
disp(t3)
disp(t4)
disp(t5)
disp(t6)
disp(t7)

for i=1:length(T1)
Q1(:,i)=const_j(p0,v0,a0,j,T1(i));
end
for i=1:length(T2)
Q2(:,i)=const_j(Q1(1,end),Q1(2,end),amax,0,T2(i));
end
for i=1:length(T3)
Q3(:,i)=const_j(Q2(1,end),Q2(2,end),amax,-j,T3(i));
end
for i=1:length(T4)
Q4(:,i)=const_j(Q3(1,end),vmax,0,0,T4(i));
end
for i=1:length(T5)
Q5(:,i)=const_j(Q4(1,end),vmax,0,-j,T5(i));
end
for i=1:length(T6)
Q6(:,i)=const_j(Q5(1,end),Q5(2,end),-amax,0,T6(i));
end
for i=1:length(T7)
Q7(:,i)=const_j(Q6(1,end),Q6(2,end),-amax,j,T7(i));
end
 
 Q=[Q1 Q2 Q3 Q4 Q5 Q6 Q7];
 
 T=[T1 T2+t1 T3+t1+t2 T4+t1+t2+t3 T5+t1+t2+t3+t4 T6+t1+t2+t3+t4+t5 T7+t1+t2+t3+t4+t5+t6];
end



function Q=const_j(p0,v0,a0,j,t)
Q=zeros(4,1);
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