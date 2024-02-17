function [OUTPUT, WAVEFORM] = swim2(data,spermid,Tend)
%please first run 'global data' outside function to declare 'data' a global variable

%sperm #spermid swims for periodcount periods
%spermid and periodcount are integers



% global data
% data = data;

xymat = data{spermid}.cartesian; %cartesian data for 1 period


L = data{spermid}.flagellum_length*10^-6; %flagellum length in m
T = data{spermid}.period; %period in seconds

Nt = size(xymat,1);
Ns = size(xymat,2);

dt = 1/(Nt-1);
ds = 1/(size(xymat,2)-1);

periodcount = ceil(Tend/T);

xymat(size(xymat,1)+1,:,:) = xymat(1,:,:); %add t=0 waveform to end of period 
                %for calculating time derivative at end of period

%swimmer position and orientation
XMAT = zeros(2,(size(xymat,1)-1));
THETAVEC = zeros(1,(size(xymat,1)-1));


%resistance coeffs
xipara = 0.69*10^-3;    %flagellum 
xiperp = 1.81*xipara;
xi1 = 40.3*10^-9/L;     %spheroidal head; longitudinal
xi2 = 46.1*10^-9/L;     %perpendicular
xirot = 0.84*10^(-18)/L^3;  %resistance coeff for torque

bb = 5*10^-6/L; %semimajor axis of spheroidal head
    
    for i = 1:(Nt) %loop over time
    xvec = xymat(i,:,1); %t
    yvec  = xymat(i,:,2);
    xvec2 = xymat(i+1,:,1);% t + dt
    yvec2  = xymat(i+1,:,2);

    xdotfull = (xvec2 - xvec)/dt;
    ydotfull = (yvec2 - yvec)/dt;

    xdot = (xdotfull(1:end-1) + xdotfull(2:end))/2;%midpoint velocity
    ydot = (ydotfull(1:end-1) + ydotfull(2:end))/2;


    xs = (xvec(2:end)-xvec(1:end-1))/ds;%tangent
    ys = (yvec(2:end)-yvec(1:end-1))/ds;
    xx = (xvec(2:end)+xvec(1:end-1))/2;%midpoint
    yy = (yvec(2:end)+yvec(1:end-1))/2;

    %RFT
    %     f(s) = xiperp*uperp(s) + xipara*upara(s) 
    %          = R(s)*[U_x U_y Omega]' + f_local(s) 
    % where
    %     R(s)  = [a1(s)   b1(s)   c1(s);
    %            a2(s)   b2(s)   c2(s)]
    %   and
    %           f_local(s) = [d1 d2]';
    %
    %torque density along filament is arot(s)*Ux + brot*Uy + crot*Omega + drot
    %       
    a1 = xipara*xs.^2 + xiperp*(1 - xs.^2);
    a2  = xipara*xs.*ys - xiperp*xs.*ys;
    arot = xx.*a2 - yy.*a1;

    b1 = xipara*xs.*ys - xiperp*xs.*ys;
    b2 = xipara*ys.^2 + xiperp*(1 - ys.^2);
    brot = xx.*b2 - yy.*b1;

    c1 = xipara*(-yy.*xs.^2 + xx.*xs.*ys) + xiperp*(-yy+yy.*xs.^2-xx.*xs.*ys);
    c2 = xipara*(-yy.*xs.*ys + xx.*ys.^2) + xiperp*(xx + yy.*xs.*ys - xx.*ys.^2);
    crot = xx.*c2 - yy.*c1;

    d1 = xipara*(xdot.*xs.^2 + ydot.*xs.*ys) + xiperp*(xdot - xdot.*xs.^2 - ydot.*xs.*ys);
    d2 = xipara*(xdot.*xs.*ys + ydot.*ys.^2) + xiperp*(ydot - xdot.*ys.*xs - ydot.*ys.^2);
    drot = xx.*d2 - yy.*d1;


    %integrate force/torque density along filament
    % A_i = int_0^2 a_i(s) ds, etc
    A1 = sum(a1)*ds; A2 = sum(a2)*ds; Arot = sum(arot)*ds;
    B1 = sum(b1)*ds; B2 = sum(b2)*ds; Brot = sum(brot)*ds;
    C1 = sum(c1)*ds; C2 = sum(c2)*ds; Crot = sum(crot)*ds;
    D1 = sum(d1)*ds; D2 = sum(d2)*ds; Drot = sum(drot)*ds;


    mat = [A1 B1 C1; A2 B2 C2; Arot Brot Crot]+... %drag from flagellum
        [xi1 0 0; 0 xi2 -xi2*bb; 0 0 xirot];        %drag from head
    vec = [-D1; -D2; -Drot] ; %force/torque from time-varying waveform


    soln = mat\vec; %invert matrix to pbtaom soln := [Ux Uy Omega]';
    Ux = soln(1);
    Uy = soln(2);
    Omega = soln(3);

    % Uxvec(i) = soln(1)*L/T;
    % Uyvec(i) = soln(3)*L/T;
    % Omegavec(i) = soln(3);

    theta = THETAVEC(i);
    e1 = [cos(theta); sin(theta)]; %longitudinal basis vector in swimmer frame
    e2 = [-sin(theta);cos(theta)]; %normal to e1

    %advance swimmer position and orientation
    XMAT(:,i+1) = XMAT(:,i) + dt*(Ux*e1 + Uy*e2);
    THETAVEC(i+1) = theta + Omega*dt;
    end

XMAT = XMAT*L/10^-6; %reintroduce dimensions, XMAT now in um

 
%extend to multiple periods
XMAT1PERIOD = XMAT;
THETAVEC1PERIOD = THETAVEC;

 for i = 1:periodcount-1
     theta = THETAVEC(end);
     XMAT = [XMAT(:,1:end-1) [cos(theta) -sin(theta); sin(theta) cos(theta)]*XMAT1PERIOD+XMAT(:,end)];
     THETAVEC = [THETAVEC(1:end-1) THETAVEC(end)+THETAVEC1PERIOD];
 end

%store data
OUTPUT = [XMAT; THETAVEC; (0:length(THETAVEC)-1)*dt*T];
%
Ncut = find(OUTPUT(4,:)>Tend,1,'first');
OUTPUT(:,Ncut:end) = [];

%   vbar = norm([OUTPUT(1,end),OUTPUT(2,end)])/Tend

%waveform matrix in swimmer frame for periodcount periods
xymat(size(xymat,1),:,:) = []; 
WAVEFORM = zeros(Nt*periodcount+1,Ns,2);
for i = 1:periodcount
WAVEFORM((i-1)*Nt+1:i*Nt,:,:) = xymat;
end
WAVEFORM(end,:,:) = xymat(1,:,:);
 
 %cut off t>T_end
 WAVEFORM(Ncut:end,:,:) = [];
 
 %dimensionalise WAVEFORM
 WAVEFORM = WAVEFORM*L/10^-6;
 
 %translate+rotate to lab frame
 for i = 1:size(WAVEFORM,1)
    wavex = WAVEFORM(i,:,1); wavey = WAVEFORM(i,:,2);
    WAVEFORM(i,:,1) = cos(THETAVEC(i))*wavex -sin(THETAVEC(i))*wavey + XMAT(1,i);
        WAVEFORM(i,:,2) = sin(THETAVEC(i))*wavex +cos(THETAVEC(i))*wavey + XMAT(2,i);
 end

% 
%  figure
%  for i = 1:size(WAVEFORM,1)
%     plot(WAVEFORM(i,:,1),WAVEFORM(i,:,2)); 
%         axis equal
% 
%     drawnow
%  end 
% wavemat = 
%  
% %  %%%%  plot trajectories
% %  hold on
% % quiver(XMAT(1,:),XMAT(2,:),-cos(THETAVEC),-sin(THETAVEC))
% %     axis equal
% 
