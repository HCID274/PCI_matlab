% plot contour for R5F
function cont_data_s_ax(obj,file,d_ax)
% obj,file name, axial position
%
% axis(as 0:free, 1:fix)
as=0;
% with/wo mean (ma 0:with, 1:w/o)
ma=1;
%
fid=fopen(file,'r',obj.endian);
%set grid
ugrid=201;
u=0:2*pi/(ugrid-1):2*pi;
[theta,radius]=meshgrid(u,obj.R);
[x,y]=pol2cart(theta,radius);
Rmax=max(obj.R);
%
p2=fread_data_s(5,obj,file);
if ma==1
    p2(:,1,1,:)=0.0;
else
    p2(:,1,1,:)=0.5*p2(:,1,1,:);
end
%
figure(1)
clf;
data2=reshape(p2(:,:,:,4),obj.IRMAX+1,obj.LMAX+1);
ax0=0.0;
num=fix(1.0/d_ax)+1
for a=1:num
ax=ax0+d_ax*2*pi*(a-1);
pha=u.'*obj.LKY.'-ax*ones(ugrid,1)*obj.LKZ.';
%pha=repmat(u.'*obj.LKY.',1,1,obj.LZM)-repmat(reshape(ax*ones(ugrid,1)*obj.LKZ.',ugrid,1,obj.LZM),1,obj.KYM,1);
%pha=repmat(u.'*obj.LKY.',1,obj.LZM) ...
%    -reshape(repmat(ax*ones(ugrid,1)*obj.LKZ.',obj.KYM,1),ugrid,obj.KYM*obj.LZM);
cos_pha=cos(pha).';
sin_pha=sin(pha).';
%
%NE
subplot(1,num,a);
str_d=sprintf('ax=%4.2f',ax/2/pi)
z=real(data2)*cos_pha-imag(data2)*sin_pha;
contourf((x/Rmax).',(y/Rmax).',(2*z).',10,'LineStyle','none');
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
end
drawnow
%
figure(2)
clf;
num2=101;
ene_p=zeros(num2,1);
ax0=0.0;
ax1=ax0+2*pi*[0:num2-1]/(num2-1);
data2=reshape(p2(:,:,:,4),obj.IRMAX+1,obj.LMAX+1);
for a=1:num2
ax=ax1(a);
pha=u.'*obj.LKY.'-ax*ones(ugrid,1)*obj.LKZ.';
%pha=repmat(u.'*obj.LKY.',1,1,obj.LZM)-repmat(reshape(ax*ones(ugrid,1)*obj.LKZ.',ugrid,1,obj.LZM),1,obj.KYM,1);
%pha=repmat(u.'*obj.LKY.',1,obj.LZM) ...
%    -reshape(repmat(ax*ones(ugrid,1)*obj.LKZ.',obj.KYM,1),ugrid,obj.KYM*obj.LZM);
cos_pha=cos(pha).';
sin_pha=sin(pha).';
%
%NE
subplot(1,1,1);
z=real(data2)*cos_pha-imag(data2)*sin_pha;
ene_p(a)=sum(sum(z.^2));
end
%ymax=max(ene_p);
plot(ax1/2.0/pi,ene_p)
xlabel('ax / 2 \pi');
ylabel('energy');
ylim([0,Inf]);
%
end
