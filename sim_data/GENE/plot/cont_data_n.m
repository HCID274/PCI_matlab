% plot contour for R5F
function cont_data_n(obj,file,ax,n)
% obj,file name, axial position
%
% axis(as 0:free, 1:fix)
as=0;
% with/wo mean (ma 0:with, 1:w/o)
ma=1;
%
fid=fopen(file,'r',obj.endian);
ax=ax*2*pi;
%set grid
ugrid=201;
u=0:2*pi/(ugrid-1):2*pi;
[theta,radius]=meshgrid(u,obj.R);
[x,y]=pol2cart(theta,radius);
Rmax=max(obj.R);
%
pha=u.'*obj.LKY.'-ax*ones(ugrid,1)*obj.LKZ.';
%pha=repmat(u.'*obj.LKY.',1,1,obj.LZM)-repmat(reshape(ax*ones(ugrid,1)*obj.LKZ.',ugrid,1,obj.LZM),1,obj.KYM,1);
%pha=repmat(u.'*obj.LKY.',1,obj.LZM) ...
%    -reshape(repmat(ax*ones(ugrid,1)*obj.LKZ.',obj.KYM,1),ugrid,obj.KYM*obj.LZM);
cos_pha=cos(pha).';
sin_pha=sin(pha).';
%
p1=fread_data_s(5,obj,file);
p2=zeros(obj.IRMAX+1,obj.LYM2,obj.LZM2,5);
p2(:,:,n+1,:)=p1(:,:,n+1,:);
if ma==1
    p2(:,1,1,:)=0.0;
else
    p2(:,1,1,:)=0.5*p2(:,1,1,:);
end
clf;
%FI
subplot(231);
str_d='PHI';
data2=reshape(p2(:,:,:,1),obj.IRMAX+1,obj.LMAX+1);
z=real(data2)*cos_pha-imag(data2)*sin_pha;
contourf((x/Rmax).',(y/Rmax).',(2*z).',30,'LineStyle','none');
shading flat;
title(str_d);
xlabel('x');
ylabel('y');
axis([-1,1,-1,1])
%axis([-0.2,0.15,-0.5,-0.15])
axis square
if (as==1)
cmax=2e-4;
else
cmax=max(max(abs(2*z)));
end
caxis([-cmax,cmax])
colorbar
%
%PSI
subplot(232);
str_d='PSI';
data2=reshape(p2(:,:,:,2),obj.IRMAX+1,obj.LMAX+1);
z=real(data2)*cos_pha-imag(data2)*sin_pha;
contourf((x/Rmax).',(y/Rmax).',(2*z).',30,'LineStyle','none');
shading flat;
title(str_d);
xlabel('x');
ylabel('y');
axis([-1,1,-1,1])
%axis([-0.2,0.15,-0.5,-0.15])
axis square
if (as==1)
cmax=2e-4;
else
cmax=max(max(abs(2*z)));
end
caxis([-cmax,cmax])
colorbar
%
%VPL
subplot(233);
str_d='VPL';
data2=reshape(p2(:,:,:,3),obj.IRMAX+1,obj.LMAX+1);
z=real(data2)*cos_pha-imag(data2)*sin_pha;
contourf((x/Rmax).',(y/Rmax).',(2*z).',30,'LineStyle','none');
shading flat;
title(str_d);
xlabel('x');
ylabel('y');
axis([-1,1,-1,1])
%axis([-0.2,0.15,-0.5,-0.15])
axis square
if (as==1)
cmax=2e-4;
else
cmax=max(max(abs(2*z)));
end
caxis([-cmax,cmax])
colorbar
%
%NE
subplot(234);
str_d='NE';
data2=reshape(p2(:,:,:,4),obj.IRMAX+1,obj.LMAX+1);
z=real(data2)*cos_pha-imag(data2)*sin_pha;
contourf((x/Rmax).',(y/Rmax).',(2*z).',30,'LineStyle','none');
shading flat;
title(str_d);
xlabel('x');
ylabel('y');
axis([-1,1,-1,1])
%axis([-0.2,0.15,-0.5,-0.15])
axis square
if (as==1)
cmax=2e-4;
else
cmax=max(max(abs(2*z)));
end
caxis([-cmax,cmax])
colorbar
%
%TE
subplot(235);
str_d='TE';
data2=reshape(p2(:,:,:,5),obj.IRMAX+1,obj.LMAX+1);
z=real(data2)*cos_pha-imag(data2)*sin_pha;
contourf((x/Rmax).',(y/Rmax).',(2*z).',30,'LineStyle','none');
shading flat;
title(str_d);
xlabel('x');
ylabel('y');
axis([-1,1,-1,1])
%axis([-0.2,0.15,-0.5,-0.15])
axis square
if (as==1)
cmax=2e-4;
else
cmax=max(max(abs(2*z)));
end
caxis([-cmax,cmax])
colorbar
%
end
