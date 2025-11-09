%
obj=dataC;
[Z,R]=meshgrid(obj.Z_mag,obj.R_mag);
maxBR=max(max(max(abs(obj.BF1))));
maxBphi=max(max(max(abs(obj.BF2))));
maxBZ=max(max(max(abs(obj.BF3))));
figure(3)
for a=1:101
%for a=1
p_phi=a
subplot(1,3,1)
data2=squeeze(obj.BF1(:,p_phi,:));
contourf(R,Z,data2,100,'LineStyle','none')
%caxis([-maxBR,maxBR]);
colorbar
title('B_R')
axis equal
subplot(1,3,3)
data2=squeeze(obj.BF2(:,p_phi,:));
contourf(R,Z,data2,100,'LineStyle','none')
%caxis([-maxBphi,maxBphi]);
colorbar
title('B_{phi}')
axis equal
subplot(1,3,2)
data2=squeeze(obj.BF3(:,p_phi,:));
contourf(R,Z,data2,100,'LineStyle','none')
%caxis([-maxBZ,maxBZ]);
colorbar
title('B_Z')
axis equal
drawnow
%pause
end
