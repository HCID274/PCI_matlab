% rho scan
function search_trajectory_test(dataC,t)
num=1;

% plasma
fread_plasma1(dataC,t);
%data_convert1(dataC)%fine mesh
%data_convert(dataC)%extended mesh
plot_plasma1(dataC,(dataC.in_pos(2)+dataC.out_pos(2))/2);
%
%
%dataC.ion_p=dataC.tracemax*0.3; %move to fread_condition1.m
vini=sqrt(dataC.in_ene/dataC.mass)*13.8; %[m/microsec]
%
%in_ang1=2.9845; %vacuum
%in_ang2=0.05687;
%ion_p=1649.0772;
%tracemax=5000;
%in_ang1=2.9845;%vacuum+VMEC
%in_ang2=0.07901;
%ion_p=1547.9373;
%tracemax=5000;
%in_ang1=2.9845;%vacuum
%in_ang2=0.08074;
%ion_p=1542.1789;
%tracemax=5000;
%in_ang1=2.9782;%vacuum+VMEC
%in_ang2=0.06085;
%ion_p=1642.2709;
%tracemax=5000;
%in_ang1=2.9782;%vacuum
%in_ang2=0.06139;
%ion_p=1639.1203;
%tracemax=5000;
%in_ang1=2.9782;%vacuum w/o E
%in_ang2=0.06175;
%ion_p=1638.6752;
%tracemax=5000;
in_ang1=0.945*pi;%vacuum w/o E
in_ang2=0.02316*pi;
%ion_p=0.314124;
ion_p=0.3265;
tracemax=100000;
%
ion_p=ion_p*tracemax;
%
%param_out=[ion_p,in_ang1,in_ang2,tracemax];
bp_out=zeros(num,1);
n1_out=zeros(num,1);
inten_out=zeros(num,1);
xout=zeros(tracemax,num);
yout=xout;
zout=xout;
vout=xout;
%inten_trj=xout;
%b_trj=zeros(dataC.tracemax,3,num);
%poten_trj=xout;
%
    x0=zeros(6,1);
    x0(1)=dataC.in_pos(1);
    x0(4)=-vini*sin(in_ang1)*cos(in_ang2);
    x0(2)=dataC.in_pos(2);
    x0(5)=vini*sin(in_ang2)/x0(1);
    x0(3)=dataC.in_pos(3);
    x0(6)=-vini*cos(in_ang1)*cos(in_ang2);
    %
    [x, y, z, v, bp,inten,inten_trj,b_trj,ef_trj,poten_trj,ne_trj,te_trj]=hibp_inj_test(dataC,x0,tracemax,ion_p);
    n1=fix(ion_p);
    %
    %0.5*(v(bp)^2-v(1)^2)*dataC.mass/9.58*1.0e5
    %0.5*(v(bp)^2-v(1)^2)*dataC.mass/9.58*1.0e5/Te
    %
    %[v(bp), v(1), 0.5*(v(bp)^2-v(1)^2)*dataC.mass/9.58*1.0e5];
    %
    R0=sqrt(x(n1)^2+y(n1)^2);
    PHI0=atan2(y(n1),x(n1));
    Z0=z(n1);
    [x(n1),y(n1),z(n1)]
    %[R0,PHI0,Z0,probeEQ_local_s(dataC,R0,Z0,PHI0,dataC.PHI)]
    %[R0,PHI0,Z0,probeEQ_local1(dataC,R0,Z0,PHI0,dataC.PHIt_re,dataC.PHIt_im)]
    %}
    % plot the final result
    if 1 ==1
    figure(1)
    hold on
    plot(sqrt(x(n1).^2+y(n1).^2),z(n1),'ro', 'linewidth',2);
    plot(sqrt(x(1:bp).^2+y(1:bp).^2),z(1:bp),'k', 'linewidth',1.5);
    plot(sqrt(x(bp).^2+y(bp).^2),z(bp),'k*');
    %axis equal
    drawnow
    hold off
    figure(2)
    hold on
	plot3(x(n1),y(n1),z(n1),'ro');
	plot3(x(1:bp),y(1:bp),z(1:bp),'k-', 'linewidth',1);
	plot3(x(bp),y(bp),z(bp),'k*');
	hold off
    drawnow
    end
    %
    b=1;
    bp_out(b)=bp;
    n1_out(b)=n1;
    inten_out(b)=inten;
    xout(:,b)=x(:);
    yout(:,b)=y(:);
    zout(:,b)=z(:);
    vout(:,b)=v(:);
    out_ene=(v(bp-1)/13.8)^2*dataC.mass;
    local_poten=probeEQ_local_s(dataC,R0,Z0,PHI0,dataC.PLASMA_PHI_total)*1.0E-6;
    [dataC.in_ene,out_ene]
    {'ene',[dataC.in_ene-out_ene, -local_poten, dataC.in_ene-out_ene+local_poten]}
% data output
    param_out=zeros(5,1);
    param_out(1)=ion_p/tracemax;
    param_out(2)=in_ang1;
    param_out(3)=in_ang2;
    param_out(4)=dataC.in_ene;
    param_out(5)=tracemax;
str=sprintf('%strace_%08.4f_%08.4f_%d_t%d.mat',dataC.outdir,in_ang1,in_ang2,tracemax,t)
save(str,'param_out','bp_out','n1_out','inten_out','xout','yout','zout','vout','inten_trj' ...
    ,'b_trj','ef_trj','poten_trj','ne_trj','te_trj');
end
