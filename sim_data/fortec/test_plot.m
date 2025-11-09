phi_d=0.1;
obj=dataC;
%
num1=obj.num1;
num2=obj.num2;
num3=obj.num3;
%
p_phi=fix((num3-1)*phi_d)+1;
%p_phi=phi_d;
%
for a=1:100
    p_phi=a;
R=squeeze(obj.R(:,p_phi,:));
Z=squeeze(obj.z(:,p_phi,:));
phi=squeeze(obj.phi(:,p_phi,:));

%data1=obj.PLASMA_poten_total;
%data1=obj.BF(:,:,:,3);
figure(1)
subplot(111)
data2=squeeze(obj.EQ_poten(:,p_phi,:));
contourf(R,Z,data2,100,'LineStyle','none')
axis equal
colorbar
hold on
data2=squeeze(obj.rho(:,p_phi,:));
contour(R,Z,data2,30,'k')
hold off
%
figure(2)
subplot(111)
data2=squeeze(obj.PLASMA_PHI(:,p_phi,:));
contourf(R,Z,data2,100,'LineStyle','none')
axis equal
colorbar
hold on
data2=squeeze(obj.rho(:,p_phi,:));
contour(R,Z,data2,30,'k')
hold off
%
figure(3)
subplot(111)
data2=squeeze(obj.PLASMA_TE_total(:,p_phi,:));
contourf(R,Z,data2,100,'LineStyle','none')
%contour(R,Z,data2,30,'k')
axis equal
colorbar
hold on
data2=squeeze(obj.rho(:,p_phi,:));
contour(R,Z,data2,30,'k')
hold off
%
figure(4)
subplot(1,3,1)
data2=squeeze(obj.BF(:,p_phi,:,1));
contourf(R,Z,data2,100,'LineStyle','none')
colorbar
title('B_R')
axis equal
hold on
data2=squeeze(obj.rho(:,p_phi,:));
contour(R,Z,data2,10,'k')
hold off
subplot(1,3,2)
data2=squeeze(obj.BF(:,p_phi,:,2));
contourf(R,Z,data2,100,'LineStyle','none')
colorbar
title('B_{Z}')
axis equal
hold on
data2=squeeze(obj.rho(:,p_phi,:));
contour(R,Z,data2,10,'k')
hold off
subplot(1,3,3)
data2=squeeze(obj.BF(:,p_phi,:,3));
contourf(R,Z,data2,100,'LineStyle','none')
colorbar
title('B_{phi}')
axis equal
hold on
data2=squeeze(obj.rho(:,p_phi,:));
contour(R,Z,data2,10,'k')
hold off
drawnow
%
end
