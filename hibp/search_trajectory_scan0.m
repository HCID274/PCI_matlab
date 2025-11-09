% rho scan
function search_trajectory_scan(dataC,t)
global result
% plasma
fread_plasma1(dataC,t);
%data_convert(dataC,t)
plot_plasma1(dataC,(dataC.in_pos(2)+dataC.out_pos(2))/2);
%
%
%dataC.ion_p=dataC.tracemax*0.3; %move to fread_condition1.m
vini=sqrt(dataC.in_ene/dataC.mass)*13.8; %[m/microsec]
%
num1=3;
num2=6;
in_ang1_s=0.936*pi;
in_ang1_s=0.939*pi;
in_ang1_e=0.92*pi;
in_ang2_s=0.005*pi;
in_ang2_e=0.025*pi;
ion_p_s=0.36;
ion_p_e=0.39;
tracemax_s=1000;
tracemax_e=2000;
tracemax=max(tracemax_s,tracemax_e);
%
ion_p_se=ion_p_s+(ion_p_e-ion_p_s)*[0:num1-1]/(num1-1);
%
in_ang1_se=in_ang1_s+(in_ang1_e-in_ang1_s)*[0:num2-1]/(num2-1);
in_ang2_se=in_ang2_s+(in_ang2_e-in_ang2_s)*[0:num2-1]/(num2-1);
tracemax_se=fix(tracemax_s+(tracemax_e-tracemax_s)*[0:num2-1]/(num2-1));
%
param_out=zeros(4,num1,num2);%ion_p,in_ang1,in_ang2,tracemax
bp_out=zeros(num1,num2);
n1_out=zeros(num1,num2);
inten_out=zeros(num1,num2);
xout=zeros(tracemax,num1,num2);
yout=xout;
zout=xout;
vout=xout;
%pause
in_ang1=in_ang1_s;
in_ang2=in_ang2_s;
tracemax=tracemax_s;
ion_p=ion_p_s*tracemax;
%
%parfor (b=1:num,5)
for b=1:num2
    for a=1:num1
    %tracemax=tracemax_se(b);
    ion_p=ion_p_se(a)*tracemax;
    %in_ang1=in_ang1_se(b);
    in_ang2=in_ang2_se(b);
%    
    x0=zeros(6,1);
    x0(1)=dataC.in_pos(1);
    x0(4)=-vini*sin(in_ang1)*cos(in_ang2);
    x0(2)=dataC.in_pos(2);
    x0(5)=vini*sin(in_ang2)/x0(1);
    x0(3)=dataC.in_pos(3);
    x0(6)=-vini*cos(in_ang1)*cos(in_ang2);
    %
    [x, y, z, v, bp, inten]=hibp_inj(dataC,x0,tracemax,ion_p);
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
    plot(sqrt(x(n1).^2+y(n1).^2),z(n1),'ro', 'linewidth',1);
    plot(sqrt(x(1:bp).^2+y(1:bp).^2),z(1:bp),'k', 'linewidth',1);
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
    bp_out(a,b)=bp;
    n1_out(a,b)=n1;
    inten_out(a,b)=inten;
    xout(1:tracemax,a,b)=x(:);
    yout(1:tracemax,a,b)=y(:);
    zout(1:tracemax,a,b)=z(:);
    vout(1:tracemax,a,b)=v(:);
    param_out(1,a,b)=ion_p;
    param_out(2,a,b)=in_ang1;
    param_out(3,a,b)=in_ang2;
    param_out(4,a,b)=tracemax;
    out_ene=(v(bp-1)/13.8)^2*dataC.mass;
    local_poten=probeEQ_local_s(dataC,R0,Z0,PHI0,dataC.PLASMA_PHI_total)*1.0E-6;
    [dataC.in_ene,out_ene];
    [b, dataC.in_ene-out_ene, -local_poten]
    dataC.in_ene-out_ene+local_poten;
    end
end
%{
fig_name = sprintf('%strace_2D%08.4f.png',dataC.outdir,dataC.in_ang1)
saveas(gcf,fig_name);
%}
result.bp=bp_out;
result.n1=n1_out;
result.inten=inten_out;
result.xout=xout;
result.yout=yout;
result.zout=zout;
result.vout=vout;
% data output
%str=sprintf('%strace_%08.4f_rho_%d.mat',dataC.outdir,dataC.in_ang1,dataC.tracemax)
str=sprintf('%strace_%08.4f_scan_%d_t%d.mat',dataC.outdir,dataC.in_ang1,dataC.tracemax,t)
save(str,'bp_out','n1_out','inten_out','xout','yout','zout','vout');
end
