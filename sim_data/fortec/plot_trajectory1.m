% plot HIBP trajectory on perturbed fields from trace_scan data
%in_con=[4.0 0.955 1];%data(in_ene,abg1,t)
%in_con=[5.0 0.948 1];
in_con=[6.0 0.9434 1];
%
oldpath=addpath('../../com','../../hibp','../magLHD');
f_path='path.txt';
data_n=1;
t=1;
dataC=hibpClass_fortec(f_path,data_n);
f_condition='condition.txt';
fread_condition(dataC,f_condition);
fread_param2(dataC);
fread_EQ1(dataC);
fread_plasma1(dataC,t);
%
str2=dataC.outdir;
%str2='E:/syncSSD/naohiro/計測シミュレータ/HIBP/LHD/PFR2023/trace02/phi1_0/';
str=sprintf('%strace_scan_ene%.2f_ang%06.4f_t%d.mat',str2,in_con(1),in_con(2),in_con(3))
load(str);
%'param_out','bp_out','n1_out','inten_out','xout','yout','zout','vout');
%
figure(7)
subplot(111)
load bwr.mat bwr
while 1
b=input('data# = ');
if b <= 0
    path(oldpath);
    return
end
%XD_in=sqrt(xout(1,b)^2+yout(1,b)^2);
%YD_in=atan2(yout(1,b),xout(1,b));
%ZD_in=zout(1,b);
%XD_out=sqrt(xout(bp_out(b,1),b)^2+yout(bp_out(b,1))^2,b);
%YD_out=atan2(yout(bp_out(b,1),b),xout(bp_out(b,1),b));
%ZD_out=zout(bp_out(b,1),b);
%phi_d=(YD_in+YD_out)/2;
R0=sqrt(xout(n1_out(b,1),b).^2+yout(n1_out(b,1),b).^2);
Z0=zout(n1_out(b,1),b);
PHI0=atan2(yout(n1_out(b,1),b),xout(n1_out(b,1),b));
phi_d=PHI0;
p_phi=fix((dataC.num3-1)*phi_d)+1;
R=squeeze(dataC.R(:,p_phi,:));
Z=squeeze(dataC.z(:,p_phi,:));
rho_poten=probeEQ_local_s(dataC,R0,Z0,PHI0,dataC.rho);
%data2=squeeze(dataC.EQ_poten(:,p_phi,:));
data2=squeeze(dataC.PLASMA_PHI(:,p_phi,:));
contourf(R,Z,data2,100,'LineStyle','none')
colormap(bwr);
axis equal
cmax=max(max(abs(data2)));
clim([-cmax,cmax]);
colorbar
hold on
    plot(R0,Z0,'ro', 'linewidth',1);
    plot(sqrt(xout(1:bp_out(b,1),b).^2+yout(1:bp_out(b,1),b).^2),zout(1:bp_out(b,1),b),'k', 'linewidth',1);
    plot(sqrt(xout(bp_out(b,1),b).^2+yout(bp_out(b,1),b).^2),zout(bp_out(b,1),b),'k*');
hold off
[phi_d,rho_poten]
end
