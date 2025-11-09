%f_path='C:/Users/kasuya/Documents/naohiro/計測シミュレータ/MATLAB/TDS_class/hibp/';
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
plot_3d(dataC);
YD0=2*pi/10*2*0;
dd=600;
%
num0=6;
in_con=zeros(3,num0);
%in_con(:,1)=[2.9845 1000 1];
%in_con(:,2)=[2.9719 1000 1];
%in_con(:,3)=[2.9638 1000 1];
%in_con(:,4)=[2.9511 1000 1];
%in_con(:,5)=[2.9405 1000 1];
%in_con(:,6)=[2.9311 1000 1];
%in_con(:,1)=[4.0 0.95 1];
%in_con(:,2)=[5.0 0.946 1];
%in_con(:,3)=[6.0 0.9434 1];
%in_con(:,4)=[6.0 0.9434 1];
%in_con(:,5)=[8.0 0.9360 1];
%in_con(:,6)=[9.0 0.933 1];
in_con(:,1)=[4.0 0.955 1];
in_con(:,2)=[5.0 0.948 1];
in_con(:,3)=[6.0 0.9434 1];
in_con(:,4)=[4.0 0.955 2];
in_con(:,5)=[5.0 0.948 2];
in_con(:,6)=[6.0 0.9434 2];
%
str2=dataC.outdir;
%str2='E:/syncSSD/naohiro/計測シミュレータ/HIBP/LHD/PFR2023/trace02/phi1_0/';
a=1;
str=sprintf('%strace_scan_ene%.2f_ang%06.4f_t%d.mat',str2,in_con(1,a),in_con(2,a),in_con(3,a))
load(str);
%'param_out','bp_out','n1_out','inten_out','xout','yout','zout','vout');
[num1,num2]=size(bp_out);
%(num1 must be same for all num0)(num2 must be 1)
out_CS=zeros(3,num0,num1);
rho_poten=zeros(num0,num1);
hibp_poten=zeros(num0,num1);
del_hibp_poten=zeros(num0,num1);
local_poten=zeros(num0,num1);
del_local_poten=zeros(num0,num1);
hibp_inten=zeros(num0,num1);
%
for a=1:num0
%str=sprintf('%strace_%08.4f_scan_%d_t%d.mat',dataC.outdir,in_con(1,a),in_con(2,a),in_con(3,a))
str=sprintf('%strace_scan_ene%.2f_ang%06.4f_t%d.mat',str2,in_con(1,a),in_con(2,a),in_con(3,a))
load(str);
%'param_out','bp_out','n1_out','inten_out','xout','yout','zout','vout');
%
for c=1:num2
    for b=1:num1
        XD=sqrt(xout(n1_out(b,c))^2+yout(n1_out(b,c))^2);
        YD=atan2(yout(n1_out(b,c)),xout(n1_out(b,c)));
        ZD=zout(n1_out(b,c));
        YDD=-(YD-YD0)/dd;
        XYZ=zeros(3,dd+1);
%
% by linear interpolation 
[XD,YD/(2*pi),ZD]
XYZ(1,1)=XD;
XYZ(2,1)=YD;
XYZ(3,1)=ZD;
for aa=1:dd
[W0(1), W0(3), W0(2)]=probeEQ_mag(dataC,XD,ZD,YD);
XD=XD+W0(1)*YDD*XD/W0(2);
YD=YD+YDD;
ZD=ZD+W0(3)*YDD*XD/W0(2);
XYZ(1,aa+1)=XD;
XYZ(2,aa+1)=YD;
XYZ(3,aa+1)=ZD;
end
%
out_CS(1,a,b)=XD;
out_CS(2,a,b)=YD;
out_CS(3,a,b)=ZD;
in_ene=param_out(4,b,c);
out_ene=(vout(bp_out(b,c)-1,b,c)/13.8)^2*dataC.mass;
R0=sqrt(xout(n1_out(b,c),b,c)^2+yout(n1_out(b,c),b,c)^2);
PHI0=atan2(yout(n1_out(b,c),b,c),xout(n1_out(b,c),b,c));
Z0=zout(n1_out(b,c),b,c);
rho_poten(a,b)=probeEQ_local_s(dataC,R0,Z0,PHI0,dataC.rho);
hibp_poten(a,b)=-(in_ene-out_ene)*1e6;
del_hibp_poten(a,b)=hibp_poten(a,b)-probeEQ_local_s(dataC,R0,Z0,PHI0,dataC.EQ_poten);
local_poten(a,b)=probeEQ_local_s(dataC,R0,Z0,PHI0,dataC.PLASMA_PHI_total);
del_local_poten(a,b)=probeEQ_local_s(dataC,R0,Z0,PHI0,dataC.PLASMA_PHI);
%del_local_poten(a,b)=local_poten(a,b)-probeEQ_local_s(dataC,R0,Z0,PHI0,dataC.EQ_poten);
hibp_inten(a,b)=inten_out(b,c);
%
figure(2)
hold on
plot3(XYZ(1,1).*cos(XYZ(2,1)),XYZ(1,1).*sin(XYZ(2,1)),XYZ(3,1),'ro');
plot3(XYZ(1,:).*cos(XYZ(2,:)),XYZ(1,:).*sin(XYZ(2,:)),XYZ(3,:),'k-', 'linewidth',1);
plot3(XYZ(1,end).*cos(XYZ(2,end)),XYZ(1,end).*sin(XYZ(2,end)),XYZ(3,end),'b*');
hold off
%
    end
end
end
%
figure(5)
p_phi=fix((dataC.num3-1)*YD0/(4*pi/10))+1;
R=squeeze(dataC.R(:,p_phi,:));
Z=squeeze(dataC.z(:,p_phi,:));
data2=squeeze(dataC.EQ_poten(:,p_phi,:));
contour(R,Z,data2,10,'k');
axis equal
hold on
plot(squeeze(out_CS(1,:,:)).',squeeze(out_CS(3,:,:)).','+');
hold off
pause
%
figure(4)
p_phi=fix((dataC.num3-1)*YD0/(4*pi/10))+1;
R=squeeze(dataC.R(:,p_phi,:));
Z=squeeze(dataC.z(:,p_phi,:));
data2=squeeze(dataC.EQ_poten(:,p_phi,:));
contour(R,Z,data2,10,'k');
axis equal
hold on
del_hibp_inten=hibp_inten(1:3,:)-hibp_inten(4:6,:);
%del_hibp_inten=(hibp_inten(1:3,:)-hibp_inten(4:6,:))./hibp_inten(4:6,:);
%cdata=hibp_inten;
cdata=del_hibp_inten;
%contourf(squeeze(out_CS(1,:,:)).',squeeze(out_CS(3,:,:)).',hibp_poten.',100,'LineStyle','none')
%contourf(squeeze(out_CS(1,:,:)).',squeeze(out_CS(3,:,:)).',del_hibp_poten.',100,'LineStyle','none')
%contourf(squeeze(out_CS(1,:,:)).',squeeze(out_CS(3,:,:)).',hibp_inten.',100,'LineStyle','none')
contourf(squeeze(out_CS(1,1:3,:)).',squeeze(out_CS(3,1:3,:)).',cdata.',100,'LineStyle','none')
cmax=max(max(abs(cdata)));
clim([-cmax,cmax]);
%clim([0,cmax]);
%clim([-cmax,0]);
colorbar
hold off
figure(5)
p_phi=fix((dataC.num3-1)*YD0/(4*pi/10))+1;
R=squeeze(dataC.R(:,p_phi,:));
Z=squeeze(dataC.z(:,p_phi,:));
data2=squeeze(dataC.EQ_poten(:,p_phi,:));
contour(R,Z,data2,10,'k');
axis equal
hold on
%contourf(squeeze(out_CS(1,:,:)),squeeze(out_CS(3,:,:)),local_poten,100,'LineStyle','none')
contourf(squeeze(out_CS(1,:,:)),squeeze(out_CS(3,:,:)),del_local_poten,100,'LineStyle','none')
cmax=max(max(abs(del_local_poten)));
clim([-cmax,cmax]);
colorbar
plot(squeeze(out_CS(1,:,:)).',squeeze(out_CS(3,:,:)).','+');
hold off
%
figure(6)
a=3;
rr=[0:0.01:1.0];
EQ_poten=108.7+6180.8*rr.^2-3951.6*rr.^4+2209.2*rr.^6-(4547.1);%[V]
plot(rr,EQ_poten,'k--','Linewidth',1.5);
hold on
plot(rho_poten(a,:),hibp_poten(a,:),'ro','Linewidth',1.5);
plot(rho_poten(a,:),local_poten(a,:),'kx','Linewidth',1.5);
hold off
set(gca,'FontSize',14);
xlabel('\rho','FontSize',20);
ylabel('potential [V]','FontSize',20);
%
path(oldpath);
