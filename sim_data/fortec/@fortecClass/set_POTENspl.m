function set_POTENspl(obj)
% from obj.PLASMA_PHI_total(num2,num3,num1)
% theta[0,2pi], phi[0,2pi/10*2], rho[0,1]
poten=obj.PLASMA_PHI_total;
num1=obj.num1;
num2=obj.num2;
num3=obj.num3;
%
obj.POTEN3D=zeros(1,num2+6,num3+6,num1+6);
obj.POTEN3D(1,4:end-3,4:end-3,4:end-3)=poten(:,:,:);
%
% for spl3d
XSD=obj.theta_si(1);
XLD=obj.theta_si(end);
YSD=obj.phi_si(1);
YLD=obj.phi_si(end);
ZSD=0.0;
ZLD=1.0;
NCDX6=num2+6;
NCDY6=num3+6;
NCDZ6=num1+6;
obj.splPOTEN=SPLIN3_2(XSD,XLD, YSD,YLD, ZSD,ZLD, NCDX6,NCDY6,NCDZ6);
%
if 1==1
figure(3)
subplot(1,3,1)
phi_d=0;
p_phi=fix((num3-1)*phi_d)+1;
R=squeeze(obj.R(:,p_phi,:));
Z=squeeze(obj.z(:,p_phi,:));
%phi=squeeze(obj.phi(:,p_phi,:));
%
data2=squeeze(obj.POTEN3D(1,4:end-3,p_phi+3,4:end-3));
contourf(R,Z,data2,100,'LineStyle','none')
colorbar
title('potential')
axis equal
end
%
end