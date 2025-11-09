%f_path='C:/Users/kasuya/Documents/naohiro/計測シミュレータ/MATLAB/TDS_class/hibp/';
oldpath=addpath('../../hibp','../magLHD');
f_path='path.txt';
data_n=1;
t=1;
dataC=hibpClass_fortec(f_path,data_n);
f_condition='condition.txt';
fread_condition(dataC,f_condition);
fread_param2(dataC);
fread_EQ1(dataC);
plot_3d(dataC);
%
str=sprintf('%strace_%08.4f_scan_%d_t%d.mat',dataC.outdir,dataC.in_ang1,dataC.tracemax,t)
load(str);
%'param_out','bp_out','n1_out','inten_out','xout','yout','zout','vout');
[num1,num2]=size(bp_out);
YD0=2*pi/10*2*0;
dd=600;
out_CS=zeros(3,num1,num2);
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
for a=1:dd
[W0(1), W0(3), W0(2)]=probeEQ_mag(dataC,XD,ZD,YD);
XD=XD+W0(1)*YDD*XD/W0(2);
YD=YD+YDD;
ZD=ZD+W0(3)*YDD*XD/W0(2);
XYZ(1,a+1)=XD;
XYZ(2,a+1)=YD;
XYZ(3,a+1)=ZD;
end
%
out_CS(1,b,c)=XD;
out_CS(2,b,c)=YD;
out_CS(3,b,c)=ZD;
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
%
figure(4)
p_phi=fix((dataC.num3-1)*YD0/(4*pi/10))+1;
R=squeeze(dataC.R(:,p_phi,:));
Z=squeeze(dataC.z(:,p_phi,:));
data2=squeeze(dataC.EQ_poten(:,p_phi,:));
contour(R,Z,data2,10,'k');
axis equal
%
hold on
plot(squeeze(out_CS(1,:,:)),squeeze(out_CS(3,:,:)),'+');
hold off
path(oldpath);
