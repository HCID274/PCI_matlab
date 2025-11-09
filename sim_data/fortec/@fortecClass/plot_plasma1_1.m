function plot_plasma1(obj,phi_d)
%
num1=obj.num1;
num2=obj.num2;
num3=obj.num3;
%
p_phi=fix((num3-1)*phi_d)+1;
R=squeeze(obj.R(:,p_phi,:));
Z=squeeze(obj.z(:,p_phi,:));
phi=squeeze(obj.phi(:,p_phi,:));
%
pp=1;
%
data1=obj.PLASMA_PHI_total;
data2=squeeze(data1(:,p_phi,:));
subplot(111)
contourf(R,Z,data2,50,'LineStyle','none')
axis vis3d
end