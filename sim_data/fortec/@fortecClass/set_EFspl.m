function set_EFspl(obj)
% from obj.PLASMA_PHI_total(num2,num3,num1)
% theta[0,2pi], phi[0,2pi/10*2], rho[0,1]
poten=obj.PLASMA_PHI_total;
num1=obj.num1;
num2=obj.num2;
num3=obj.num3;
E1=zeros(num2,num3,num1);
E2=zeros(num2,num3,num1);
E3=zeros(num2,num3,num1);
%
% r
E1(:,:,2:end-1)=-(poten(:,:,3:end)-poten(:,:,1:end-2)) ...
    ./(obj.radius(:,:,3:end)-obj.radius(:,:,1:end-2));
E1(:,:,1)=0;
E1(:,:,end)=0;
unitE1=zeros(3,num2,num3,num1);
unitE1(1,:,:,2:end-1)=obj.R(:,:,3:end)-obj.R(:,:,1:end-2);
unitE1(2,:,:,2:end-1)=obj.R(:,:,2:end-1).*(obj.phi(:,:,3:end)-obj.phi(:,:,1:end-2));
unitE1(3,:,:,2:end-1)=obj.z(:,:,3:end)-obj.z(:,:,1:end-2);
unit=squeeze(sqrt(sum(unitE1.^2,1)));
inv_unit=1.0./unit;
inv_unit(isnan(inv_unit))=0.0;
for a=1:3
unitE1(a,:,:,:)=squeeze(unitE1(a,:,:,:)).*inv_unit;
end
%
% theta
theta=repmat(obj.theta_si,1,num3,num1);
E2(2:end-1,:,:)=-(poten(3:end,:,:)-poten(1:end-2,:,:)) ...
    ./(theta(3:end,:,:)-theta(1:end-2,:,:))./obj.radius(2:end-1,:,:);
E2(1,:,:)=-(poten(2,:,:)-poten(end-1,:,:)) ...
    ./(theta(2,:,:)-theta(end,:,:))./obj.radius(1,:,:);
E2(end,:,:)=E2(1,:,:);
E2(:,:,1)=0.0;
unitE2=zeros(3,num2,num3,num1);
unitE2(1,1,:,:)=obj.R(2,:,:)-obj.R(end-1,:,:);
unitE2(2,1,:,:)=obj.R(1,:,:).*(obj.phi(2,:,:)-obj.phi(end-1,:,:));
unitE2(3,1,:,:)=obj.z(2,:,:)-obj.z(end-1,:,:);
unitE2(1,2:end-1,:,:)=obj.R(3:end,:,:)-obj.R(1:end-2,:,:);
unitE2(2,2:end-1,:,:)=obj.R(2:end-1,:,:).*(obj.phi(3:end,:,:)-obj.phi(1:end-2,:,:));
unitE2(3,2:end-1,:,:)=obj.z(3:end,:,:)-obj.z(1:end-2,:,:);
unitE2(1,end,:,:)=unitE2(1,1,:,:);
unitE2(2,end,:,:)=unitE2(2,1,:,:);
unitE2(3,end,:,:)=unitE2(3,1,:,:);
unit=squeeze(sqrt(sum(unitE2.^2,1)));
inv_unit=1.0./unit;
inv_unit(isnan(inv_unit))=0.0;
for a=1:3
unitE2(a,:,:,:)=squeeze(unitE2(a,:,:,:)).*inv_unit;
end
% phi
phi=repmat(obj.phi_si.',num2,1,num1);
E3(:,2:end-1,:)=-(poten(:,3:end,:)-poten(:,1:end-2,:)) ...
    ./(phi(:,3:end,:)-phi(:,1:end-2,:))./obj.R(:,2:end-1,:);
E3(:,1,:)=-(poten(:,2,:)-poten(:,end-1,:)) ...
    ./(phi(:,2,:)-phi(:,end,:))./obj.R(:,1,:);
E3(:,end,:)=E3(:,1,:);
unitE3=zeros(3,num2,num3,num1);
unitE3(1,:,1,:)=obj.R(:,2,:)-obj.R(:,end-1,:);
unitE3(2,:,1,:)=obj.R(:,1,:).*(obj.phi(:,2,:)-obj.phi(:,end-1,:));
unitE3(3,:,1,:)=obj.z(:,2,:)-obj.z(:,end-1,:);
unitE3(1,:,2:end-1,:)=obj.R(:,3:end,:)-obj.R(:,1:end-2,:);
unitE3(2,:,2:end-1,:)=obj.R(:,2:end-1,:).*(obj.phi(:,3:end,:)-obj.phi(:,1:end-2,:));
unitE3(3,:,2:end-1,:)=obj.z(:,3:end,:)-obj.z(:,1:end-2,:);
unitE3(1,:,end,:)=unitE3(1,:,1,:);
unitE3(2,:,end,:)=unitE3(2,:,1,:);
unitE3(3,:,end,:)=unitE3(3,:,1,:);
unit=squeeze(sqrt(sum(unitE3.^2,1)));
inv_unit=1.0./unit;
inv_unit(isnan(inv_unit))=0.0;
for a=1:3
unitE3(a,:,:,:)=squeeze(unitE3(a,:,:,:)).*inv_unit;
end
%
EF=zeros(3,num2,num3,num1);
unitE0=zeros(3,3);
for a=1:num2
    for b=1:num3
        for c=2:num1-1
            unitE0(1,:)=unitE1(:,a,b,c);
            unitE0(2,:)=unitE3(:,a,b,c);
            unitE0(3,:)=unitE2(:,a,b,c);
            EF(:,a,b,c)=unitE0\[E1(a,b,c) E3(a,b,c) E2(a,b,c)].';
        end
    end
end
%EF(isnan(EF))=0.0;
%EF=unitE1+unitE2+unitE3;%EF(3,num2,num3,num1) (R,phi,z) components
%
obj.EF3D=zeros(3,num2+6,num3+6,num1+6);
obj.EF3D(1,4:end-3,4:end-3,4:end-3)=EF(1,:,:,:);
obj.EF3D(2,4:end-3,4:end-3,4:end-3)=EF(2,:,:,:);
obj.EF3D(3,4:end-3,4:end-3,4:end-3)=EF(3,:,:,:);
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
obj.splEF=SPLIN3_2(XSD,XLD, YSD,YLD, ZSD,ZLD, NCDX6,NCDY6,NCDZ6);
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
data2=squeeze(obj.EF3D(1,4:end-3,p_phi+3,4:end-3));
contourf(R,Z,data2,100,'LineStyle','none')
colorbar
title('E_R')
axis equal
subplot(1,3,2)
data2=squeeze(obj.EF3D(2,4:end-3,p_phi+3,4:end-3));
contourf(R,Z,data2,100,'LineStyle','none')
colorbar
title('E_{phi}')
axis equal
subplot(1,3,3)
data2=squeeze(obj.EF3D(3,4:end-3,p_phi+3,4:end-3));
contourf(R,Z,data2,100,'LineStyle','none')
colorbar
title('E_Z')
axis equal
end
%
end