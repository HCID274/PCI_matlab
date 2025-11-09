test_read;
XSD=dataC.R_mag(1);
XLD=dataC.R_mag(end);
YSD=dataC.Phi_mag(end);
YLD=dataC.Phi_mag(1);
ZSD=dataC.Z_mag(1);
ZLD=dataC.Z_mag(end);
NCDX=dataC.NRGM;
NCDY=dataC.NPHIGM;
NCDZ=dataC.NZGM;
NCDX6=NCDX+6;
NCDY6=NCDY+6;
NCDZ6=NCDZ+6;
SPLIN3(XSD,XLD, YSD,YLD, ZSD,ZLD, NCDX6,NCDY6,NCDZ6);
%
NF=3;
FA=zeros(NF,NCDX6,NCDY6,NCDZ6);
FA(1,4:end-3,4:end-3,4:end-3)=dataC.BF1;
%FA(1,:,1:3,:)=FA(1,:,end-6:end-4,:);%cyclic
%FA(1,:,end-2:end,:)=FA(1,:,5:7,:);%cyclic
FA(2,4:end-3,4:end-3,4:end-3)=dataC.BF2;
%FA(2,:,1:3,:)=FA(2,:,end-6:end-4,:);
%FA(2,:,end-2:end,:)=FA(2,:,5:7,:);
FA(3,4:end-3,4:end-3,4:end-3)=dataC.BF3;
%FA(3,:,1:3,:)=FA(3,:,end-6:end-4,:);
%FA(3,:,end-2:end,:)=FA(3,:,5:7,:);
W0=zeros(NF,1);
%
XD=4.0;
YD=0.1*pi;
ZD=0.0;
YD0=0.0;
dd=100;
%
% by spline
YDD=-(YD-YD0)/dd;
XYZ=zeros(3,dd+1);
%
XYZ(1,1)=XD;
XYZ(2,1)=YD;
XYZ(3,1)=ZD;
for a=1:dd
W0=SPL3DF(NF, FA, XD, YD, ZD);
XD=XD+W0(1)*YDD/(XD*W0(2));
YD=YD+YDD;
ZD=ZD+W0(3)*YDD/(XD*W0(2));
XYZ(1,a+1)=XD;
XYZ(2,a+1)=YD;
XYZ(3,a+1)=ZD;
end
%
plot3(XYZ(1,:).*cos(XYZ(2,:)),XYZ(1,:).*sin(XYZ(2,:)),XYZ(3,:),'r+');
%
% by linear interpolation 
XD=XYZ(1,1);
YD=XYZ(2,1);
ZD=XYZ(3,1);
YD0=0.0;
YDD=-(YD-YD0)/dd;
XYZ=zeros(3,dd+1);
%
XYZ(1,1)=XD;
XYZ(2,1)=YD;
XYZ(3,1)=ZD;
for a=1:dd
[W0(1), W0(3), W0(2)]=probeEQ_mag(dataC,XD,ZD,YD);
XD=XD+W0(1)*YDD/(XD*W0(2));
YD=YD+YDD;
ZD=ZD+W0(3)*YDD/(XD*W0(2));
XYZ(1,a+1)=XD;
XYZ(2,a+1)=YD;
XYZ(3,a+1)=ZD;
end
%
hold on
plot3(XYZ(1,:).*cos(XYZ(2,:)),XYZ(1,:).*sin(XYZ(2,:)),XYZ(3,:),'k+');
hold off