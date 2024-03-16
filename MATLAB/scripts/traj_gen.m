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