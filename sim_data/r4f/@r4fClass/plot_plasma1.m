function plot_plasma1(obj)
%function plot_plasma1(phi_d)
%{
phi_d = self.phi_d;
PLASMA.phi_d = phi_d;

lrnet=EQ.NRGM;
lznet=EQ.NZGM;
lphinet=EQ.NPHIGM;
rmin=EQ.RG1(1);
rmax=EQ.RG1(2);
zmin=EQ.RG2(1);
zmax=EQ.RG2(2);
phimin=EQ.RG3(1);
phimax=EQ.RG3(2);
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
data1=PLASMA.TE;
subplot(111)
contourf(x(:,pp:end),y(:,pp:end),data1(pp:end,:,p_phi).',50,'LineStyle','none')
axis equal
%}

if 1==1
ax=1.0;
data1=obj.PHI;
%set grid
ugrid=obj.NTGMAX+1;
u=0:2*pi/(ugrid-1):2*pi;
%[theta,radius]=meshgrid(u,PRM.R);
%[x,y]=pol2cart(theta,radius);
pha=u.'*obj.LKY.'-ax*ones(ugrid,1)*obj.LKZ.';
cos_pha=cos(pha).';
sin_pha=sin(pha).';
zz=real(data1)*cos_pha-imag(data1)*sin_pha;
contourf(obj.GRC,obj.GZC,(2*zz),30,'LineStyle','none');
axis equal
end
end