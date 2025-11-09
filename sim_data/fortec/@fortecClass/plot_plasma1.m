function plot_plasma1(obj,phi_d)
%
num1=obj.num1;
num2=obj.num2;
num3=obj.num3;
%
p_phi=fix((num3-1)*phi_d)+1
%p_phi=phi_d;
%
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
hold on
plot(obj.out_pos(1),obj.out_pos(3),'r+');
hold off
%
figure(4)
subplot(111)
%data2=squeeze(obj.EQ_poten(:,p_phi,:));
data2=squeeze(obj.rho(:,p_phi,:));
contourf(R,Z,data2,100,'LineStyle','none')
axis equal
hold on
plot(obj.out_pos(1),obj.out_pos(3),'r+');
hold off

[Z,R]=meshgrid(obj.Z_mag,obj.R_mag);
figure(3)
subplot(1,3,1)
data2=squeeze(obj.BF1(:,p_phi,:));
contourf(R,Z,data2,100,'LineStyle','none')
colorbar
title('B_R')
axis equal
subplot(1,3,2)
data2=squeeze(obj.BF2(:,p_phi,:));
contourf(R,Z,data2,100,'LineStyle','none')
colorbar
title('B_{phi}')
axis equal
subplot(1,3,3)
data2=squeeze(obj.BF3(:,p_phi,:));
contourf(R,Z,data2,100,'LineStyle','none')
colorbar
title('B_Z')
axis equal

%
plot_3d(obj)
%
%data_convert(obj)
end