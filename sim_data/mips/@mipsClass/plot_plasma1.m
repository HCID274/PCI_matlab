function plot_plasma1(obj,phi_d)
%
lrnet=obj.NRGM;
lznet=obj.NZGM;
lphinet=obj.NPHIGM;
rmin=obj.RG1(1);
rmax=obj.RG1(2);
zmin=obj.RG2(1);
zmax=obj.RG2(2);
phimin=obj.RG3(1);
phimax=obj.RG3(2);
%
R=[0:lrnet-1]/lrnet*(rmax-rmin)+rmin;
Z=[0:lznet-1]/lznet*(zmax-zmin)+zmin;
PHI=[0:lphinet-1]/lphinet*(phimax-phimin)+phimin;
%lphinet=lphinet/2.0;
%
p_phi=fix((lphinet-1)*phi_d)+1;
[x,y]=meshgrid(R,Z);
pp=1;
%
data1=obj.PLASMA_NE_total;
subplot(111)
contourf(x(:,pp:end),y(:,pp:end),data1(pp:end,:,p_phi).',50,'LineStyle','none')
axis equal
%
end