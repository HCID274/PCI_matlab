% plot contour for R5F
function cont_data2_s(obj,file,ax)
% obj,file name, axial position
%
% axis(as 0:free, 1:fix)
as=0;
% with/wo mean (ma 0:with, 1:w/o)
ma=0;
%
fid=fopen(file,'r',obj.endian);
ax=ax*2*pi;
%set grid
ugrid=obj.NTGMAX+1;
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
p2=fread_data_s(5,obj,file);
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
data2=reshape(p2(:,:,:,2),obj.IRMAX+1,obj.LMAX+1);
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
data2=reshape(p2(:,:,:,3),obj.IRMAX+1,obj.LMAX+1);
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
%NE
subplot(234);
str_d='NE';
data2=reshape(p2(:,:,:,4),obj.IRMAX+1,obj.LMAX+1);
z=real(data2)*cos_pha-imag(data2)*sin_pha;
size(z)
size(cos_pha)
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
%TE
subplot(235);
str_d='TE';
data2=reshape(p2(:,:,:,5),obj.IRMAX+1,obj.LMAX+1);
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

size(z)
pause



% for LS_condition_beam
fread_param2(obj);
fread_EQ1(obj);
%
f_condition='./LS_condition_JT60SA.txt';
A=importdata(f_condition,',',5);
pp1=A.data(1,:);
wid1=A.data(2,1);
wid2=A.data(2,2);
div1=A.data(3,1);
div2=A.data(3,2);
divls=A.data(3,3);
%
B1=zeros(2,3);
xl=zeros(2,3);
p1=zeros(3,1);
B1(1,:)=pp1(1:3);
B1(2,:)=pp1(4:6);
B2(:,1)=B1(:,1).*cos(2*pi*B1(:,3));
B2(:,2)=B1(:,1).*sin(2*pi*B1(:,3));
B2(:,3)=B1(:,2);
B2=B2/1000.0;
b2ls=(B2(1,1)-B2(2,1))*(B2(1,1)-B2(2,1)) ...
    +(B2(1,2)-B2(2,2))*(B2(1,2)-B2(2,2)) ...
    +(B2(1,3)-B2(2,3))*(B2(1,3)-B2(2,3));
b2ls=sqrt(b2ls);
%
p1(1)=B2(1,1)-B2(2,1);
p1(2)=B2(1,2)-B2(2,2);
p1(3)=B2(1,3)-B2(2,3)
%
if(p1(1)==0 && p1(2)==0)
    xl(1,1)=wid1/2.0*cos(2*pi*B1(1,3));
    xl(1,2)=wid1/2.0*sin(2*pi*B1(1,3));
    xl(1,3)=0.0;
    xl(2,1)=-wid2/2.0*sin(2*pi*B1(1,3));
    xl(2,2)=wid2/2.0*cos(2*pi*B1(1,3));
    xl(2,3)=0.0;
else
    xl(1,1)=p1(3);
    xl(1,2)=p1(3)*tan(2*pi*B1(1,3));
    xl(1,3)=-(p1(1)+p1(2)*tan(2*pi*B1(1,3)));
    xl0=1.0/sqrt(xl(1,1)^2+xl(1,2)^2+xl(1,3)^2)*wid1/2.0;
    xl(1,1)=xl(1,1)*xl0;
    xl(1,2)=xl(1,2)*xl0;
    xl(1,3)=xl(1,3)*xl0;
    xl(2,1)=p1(1)*p1(2)+(p1(2)^2+p1(3)^2)*tan(2*pi*B1(1,3));
    xl(2,2)=-p1(1)^2-p1(3)^2-p1(1)*p1(2)*tan(2*pi*B1(1,3));
    xl(2,3)=p1(2)*p1(3)-p1(1)*p1(3)*tan(2*pi*B1(1,3));
    xl0=1.0/sqrt(xl(2,1)^2+xl(2,2)^2+xl(2,3)^2)*wid2/2.0;
    xl(2,1)=xl(2,1)*xl0;
    xl(2,2)=xl(2,2)*xl0;
    xl(2,3)=xl(2,3)*xl0;
end
%{
l1 = 1/sqrt(p1(1)^2 + p1(2)^2)
xl(1,1)=l1*p1(2);
xl(1,2)=-l1*p1(1);
xl(1,3)=l1*p1(3);
l2 = 1/sqrt((p1(1)*p1(3))^2 + (p1(2)*p1(3))^2 + (p1(1)^2 + p1(2)^2)^2)
xl(2,1)=l2*(p1(1)*p1(3));
xl(2,2)=l2*(p1(2)*p1(3));
xl(2,3)=-(p1(1)^2 + p1(2)^2);
%}
divls_2=divls+1;
div1_2=2*div1+1;
div2_2=2*div2+1;
num=div1_2*div2_2;
b2ls=b2ls/divls;
replix=zeros(div1_2,div2_2,divls_2);
xls=ones(div1_2,div2_2,divls_2)*B2(2,1);
yls=ones(div1_2,div2_2,divls_2)*B2(2,2);
zls=ones(div1_2,div2_2,divls_2)*B2(2,3);
%
for j=1:div1_2
    replix(j,:,:)=ones(div2_2,divls_2)*(real(j-1)-div1)/div1;
end
xls=xls+replix*xl(1,1);
yls=yls+replix*xl(1,2);
zls=zls+replix*xl(1,3);
for j=1:div2_2
    replix(:,j,:)=ones(div1_2,divls_2)*(real(j-1)-div2)/div2;
end
xls=xls+replix*xl(2,1);
yls=yls+replix*xl(2,2);
zls=zls+replix*xl(2,3);
for j=1:divls_2
    replix(:,:,j)=ones(div1_2,div2_2)*real(j-1)/divls;
end
xls=xls+replix*p1(1);
yls=yls+replix*p1(2);
zls=zls+replix*p1(3);
xls1=reshape(xls,div1_2*div2_2*divls_2,1);
yls1=reshape(yls,div1_2*div2_2*divls_2,1);
zls1=reshape(zls,div1_2*div2_2*divls_2,1);
%
%Plot the start and end points of the beam



axmax = 300

figure(10)
clf;

z2 = zeros(obj.IRMAX+1,obj.LMAX+1,axmax);
KZMt = (obj.LZM2-1)*2;

xmesh = zeros(KZMt+2,obj.IRMAX);
ymesh = zeros(KZMt+2,obj.IRMAX);
for theta = 1:KZMt+2
    for R = 1:obj.IRMAX+1
        xmesh(theta,R) = -R/(obj.IRMAX+2)*cos((2*pi/(KZMt+2))*(theta-1)) + 2;
        ymesh(theta,R) = -R/(obj.IRMAX+2)*sin((2*pi/(KZMt+2))*(theta-1));
    end
end

r_idx = 900
tol = axmax*0.6

xxx = xmesh(:,r_idx)*cos([0:size(z2, 3)]*2*pi/size(z2, 3));
yyy = xmesh(:,r_idx)*sin([0:size(z2, 3)]*2*pi/size(z2, 3));
zzz = repmat(ymesh(:,r_idx),1,size(z2-1, 3)+1);
plot3(xxx(1:end,1:tol),yyy(1:end,1:tol),zzz(1:end,1:tol),'k-');
axis equal;



pause
figure(2)
clf;
plot3(B2(:,1),B2(:,2),B2(:,3),'o');
hold on
%
%Plot the path of the beam
plot3(xls1,yls1,zls1,'.');
for ax = 1:axmax
    axi = ax/100;
    axi=axi*2*pi;
    %set grid
    ugrid=obj.NTGMAX+1;
    u=0:2*pi/(ugrid-1):2*pi;
    [theta,radius]=meshgrid(u,obj.R);
    [x,y]=pol2cart(theta,radius);
    Rmax=max(obj.R);
    %
    pha=u.'*obj.LKY.'-axi*ones(ugrid,1)*obj.LKZ.';
    %pha=repmat(u.'*obj.LKY.',1,1,obj.LZM)-repmat(reshape(ax*ones(ugrid,1)*obj.LKZ.',ugrid,1,obj.LZM),1,obj.KYM,1);
    %pha=repmat(u.'*obj.LKY.',1,obj.LZM) ...
    %    -reshape(repmat(ax*ones(ugrid,1)*obj.LKZ.',obj.KYM,1),ugrid,obj.KYM*obj.LZM);
    cos_pha=cos(pha).';
    sin_pha=sin(pha).';
    data2=reshape(p2(:,:,:,1),obj.IRMAX+1,obj.LMAX+1);
    z2(:,:,ax)=real(data2)*cos_pha-imag(data2)*sin_pha;
    ax
end
z3 = z2;
z3(:,:,axmax+1) = z3(:,:,1);


z4 = z3(r_idx,:,:);

xls_b=obj.GRC(r_idx,:).'*cos([0:size(z2, 3)]*2*pi/size(z2, 3));
yls_b=obj.GRC(r_idx,:).'*sin([0:size(z2, 3)]*2*pi/size(z2, 3));
zls_b=repmat(obj.GZC(r_idx,:).',1,size(z2, 3)+1);
size(xls_b)
size(zls_b)
size(squeeze(z4))

z5 = squeeze(z4);


surf(xls_b(1:end,1:tol),yls_b(1:end,1:tol),zls_b(1:end,1:tol), z5(:,1:tol), 'EdgeColor', 'none');
xlabel("X")
ylabel("Y")
zlabel("Z")
xlim([-5,5])
ylim([-5,5])
zlim([-3,3])

pause
xls_b2=obj.GRC(:,:).'*cos((tol-1)*2*pi/size(z2, 3));
yls_b2=obj.GRC(:,:).'*sin((tol-1)*2*pi/size(z2, 3));
zls_b2=obj.GZC(:,:).';

size(xls_b2)
size(zls_b2)
surf(xls_b2,yls_b2,zls_b2, z3(:,:,(tol-1)).', 'EdgeColor', 'none');


xls_b3=obj.GRC(:,:).'*cos(0*2*pi/size(z2, 3));
yls_b3=obj.GRC(:,:).'*sin(0*2*pi/size(z2, 3));
zls_b3=obj.GZC(:,:).';

surf(xls_b3,yls_b3,zls_b3, z3(:,:,1).', 'EdgeColor', 'none');



figure(3)
clf;
KZMt = (obj.LZM2-1)*2;

xmesh = zeros(KZMt+2,obj.IRMAX);
ymesh = zeros(KZMt+2,obj.IRMAX);
for theta = 1:KZMt+2
    for R = 1:obj.IRMAX+1
        xmesh(theta,R) = -R/(obj.IRMAX+2)*cos((2*pi/(KZMt+2))*(theta-1)) + 2;
        ymesh(theta,R) = -R/(obj.IRMAX+2)*sin((2*pi/(KZMt+2))*(theta-1));
    end
end





z7 = z2;
z7(:,:,axmax+1) = z7(:,:,1);
z8=zeros(size(z7,1),size(z7,2),size(z7,3));
z8(:,65:end,:)=z7(:,1:65,:);
z8(:,1:64,:)=z7(:,66:end,:);


%{
for i = 1:129
    md = mod(64+i,129);
    z6(md+1,:) = z5(i,:);
end
%}

%
z6=zeros(size(z5,1),size(z5,2));
z6(65:end,:)=z5(1:65,:);
z6(1:64,:)=z5(66:end,:);
z6 = [z6; z6(1,:)];
%

xxx = xmesh(:,r_idx)*cos([0:size(z2, 3)]*2*pi/size(z2, 3));
yyy = xmesh(:,r_idx)*sin([0:size(z2, 3)]*2*pi/size(z2, 3));
zzz = repmat(ymesh(:,r_idx),1,size(z2-1, 3)+1);
size(xxx)
size(yyy)
size(zzz)
size(z5)

surf(xxx(1:end,1:tol),yyy(1:end,1:tol),zzz(1:end,1:tol), z6(:,1:tol), 'EdgeColor', 'none');
xlabel("X")
ylabel("Y")
zlabel("Z")
xlim([-5,5])
ylim([-5,5])
zlim([-5,5])
colorbar;
axis equal;

hold on

xxx2=xmesh(:,:)*cos((tol-1)*2*pi/size(z2-1, 3));
yyy2=xmesh(:,:)*sin((tol-1)*2*pi/size(z2-1, 3));
zzz2=ymesh(:,:);

surf(xxx2,yyy2,zzz2, z8(:,:,(tol-1)).', 'EdgeColor', 'none');


xxx3=xmesh(:,:)*cos(0*2*pi/size(z2, 3));
yyy3=xmesh(:,:)*sin(0*2*pi/size(z2, 3));
zzz3=ymesh(:,:);

surf(xxx3,yyy3,zzz3, z8(:,:,1).', 'EdgeColor', 'none');
hold off





%{
figure(4)
str_d='TE';
data2=reshape(p2(:,:,:,5),obj.IRMAX+1,obj.LMAX+1);
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
hold on;
plot(obj.GRC.',obj.GZC.',".")
hold off

%}
%{
figure(10)
data2=reshape(p2(:,:,:,1),obj.IRMAX+1,obj.LMAX+1);
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
%hold on;
%plot(obj.GRC.',obj.GZC.',".")
%hold off
%}
end
