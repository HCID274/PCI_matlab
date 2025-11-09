% plot contour single mode for R5F
function cont_data2_1(obj,file,ax,m,n)
% obj,file name, axial position
%
% axis(as 0:free, 1:fix)
as=0;
fid=fopen(file,'r',obj.endian);
ax=ax*2*pi;
%set grid
ugrid=obj.NTGMAX+1;
u=0:2*pi/(ugrid-1):2*pi;
[theta,radius]=meshgrid(u,obj.R);
[x,y]=pol2cart(theta,radius);
Rmax=max(obj.R);
%
pha=u*m-ax*ones(1,ugrid)*n;
cos_pha=cos(pha);
sin_pha=sin(pha);
%
p2=fread_data_1(5,obj,file,m,n);
clf;
%{
%FI
subplot(231);
str_d='PHI';
data2=p2(:,1);
z=real(data2)*cos_pha-imag(data2)*sin_pha;
%contourf((x/Rmax).',(y/Rmax).',(2*z).',10,'LineStyle','none');
contourf(obj.GRC,obj.GZC,(2*z),30,'LineStyle','none');
shading flat;
title(str_d);
xlabel('x');
ylabel('y');
axis equal
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
data2=p2(:,2);
z=real(data2)*cos_pha-imag(data2)*sin_pha;
contourf(obj.GRC,obj.GZC,(2*z),30,'LineStyle','none');
shading flat;
title(str_d);
xlabel('x');
ylabel('y');
axis equal
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
data2=p2(:,3);
z=real(data2)*cos_pha-imag(data2)*sin_pha;
contourf(obj.GRC,obj.GZC,(2*z),30,'LineStyle','none');
shading flat;
title(str_d);
xlabel('x');
ylabel('y');
axis equal
if (as==1)
cmax=2e-4;
else
cmax=max(max(abs(2*z)));
end
caxis([-cmax,cmax])
colorbar
%
%}
%NE
subplot(234);
str_d='NE';
data2=p2;
size(data2)

xmesh = zeros(obj.LYM2,obj.IRMAX);
ymesh = zeros(obj.LYM2,obj.IRMAX);
i = 0;
for theta2 = 1:obj.LYM2;
    for R2 = 1:obj.IRMAX;
        xmesh(theta2,R2) = -R2*cos((2*pi/obj.LYM2)*(theta2-1));
        ymesh(theta2,R2) = R2*sin((2*pi/obj.LYM2)*(theta2-1));
        i = i + 1
    end
end

contourf(xmesh,ymesh,data2,10,'LineStyle','none')
pause


%{
subplot(234);
str_d='NE';
data2=p2(:,4);
z=real(data2)*cos_pha-imag(data2)*sin_pha;
contourf(obj.GRC,obj.GZC,(2*z),30,'LineStyle','none');
shading flat;
title(str_d);
xlabel('x');
ylabel('y');
axis equal
if (as==1)
cmax=2e-4;
else
cmax=max(max(abs(2*z)));
end
caxis([-cmax,cmax])
colorbar
%}
%{
%TE
subplot(235);
str_d='TE';
data2=p2(:,5);
z=real(data2)*cos_pha-imag(data2)*sin_pha;
contourf(obj.GRC,obj.GZC,(2*z),30,'LineStyle','none');
shading flat;
title(str_d);
xlabel('x');
ylabel('y');
axis equal
if (as==1)
cmax=2e-4;
else
cmax=max(max(abs(2*z)));
end
caxis([-cmax,cmax])
colorbar
%}
end
