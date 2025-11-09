% plot contour for GENE
function data3 = cont_data2_s(obj,file,ax,t)
%
p1=fread_data_s(5,obj,file);
tol = 1;  %poloidal cross-sections to be displayed.
p1=p1(:,:,tol);
p1=[p1; p1(1,:)];
p1=[p1,zeros(length(p1),1)];

data1=zeros(obj.LYM2/(obj.KZMt+1)+1, obj.nx0+1+obj.inside+obj.outside);
data1(:,obj.inside+1:end-obj.outside) = p1;

xmesh = zeros(obj.LYM2/(obj.KZMt+1)+1,obj.nx0+obj.inside+obj.outside);
ymesh = zeros(obj.LYM2/(obj.KZMt+1)+1,obj.nx0+obj.inside+obj.outside);
for theta = 1:obj.LYM2/(obj.KZMt+1)+1
    for R = 1:obj.nx0+obj.inside+obj.outside+1
        xmesh(theta,R) = -R*(obj.trpeps*obj.major_R*obj.L_ref/(obj.nx0+obj.inside+obj.outside+1))*cos((2*pi/(obj.LYM2/(obj.KZMt+1)))*(theta-1)) + obj.major_R*obj.L_ref;
        ymesh(theta,R) = -R*(obj.trpeps*obj.major_R*obj.L_ref/(obj.nx0+obj.inside+obj.outside+1))*sin((2*pi/(obj.LYM2/(obj.KZMt+1)))*(theta-1));
    end
end

figure(1) % circular closs-section
contourf(xmesh,ymesh,data1,10,'LineStyle','none')
xlabel('R');
ylabel('Z');
axis square
colorbar;

p2=fread_data_s(5,obj,file);
tol = 1;  %poloidal cross-sections to be displayed.
p2=p2(:,:,tol);
p2=[p2,zeros(length(p2),1)];

data2=zeros(obj.LYM2/(obj.KZMt+1), obj.nx0+1+obj.inside+obj.outside);
data2(:,obj.inside+1:end-obj.outside) = p2;

data3=zeros(size(data2,1),size(data2,2));
for i = 1:obj.NTGMAX
    md = mod(i+(obj.NTGMAX/2),obj.NTGMAX);
    data3(md+1,:) = data2(i,:);
end
data3 = [data3; data3(1,:)];

figure(2) % poloidal closs-section
contourf(obj.GRC.',obj.GZC.',data3,30,'LineStyle','none');
xlabel('R');
ylabel('Z');
axis equal
colorbar;

%
% 3D structure
r_idx = 420;
tol = 60;

p2=fread_data_s(5,obj,file);
p2_s=zeros(obj.LYM2/(obj.KZMt+1), obj.nx0+1, obj.KZMt+1+1);

for i = 1:obj.KZMt+1
    p2_s(:,:,i)=[p2(:,:,i),zeros(length(p2),1,1)];
end
p2_s(:,:,end) = p2_s(:,:,1);

data2=zeros(obj.LYM2/(obj.KZMt+1), obj.nx0+1+obj.inside+obj.outside,obj.KZMt+1+1);

data2(:,obj.inside+1:end-obj.outside,:) = p2_s;

data3=zeros(size(data2,1),size(data2,2),size(data2,3));
for i = 1:obj.NTGMAX
    md = mod(i+(obj.NTGMAX/2),obj.NTGMAX);
    data3(md+1,:,:) = data2(i,:,:);
end
data2 = [data2; data2(1,:,:)];
data3 = [data3; data3(1,:,:)];
data5 = data2(:, r_idx, :);  

z_steps = size(data3, 3);  
Data3D = zeros(z_steps, size(data3, 1));
for phi = 1:size(data3, 3)
    Data3D(phi, :) = data5(:, 1, phi).'; 
end


figure(3) % 3D circular closs-section
xxx = xmesh(:,r_idx)*cos([0:size(data5-1, 3)]*2*pi/size(data5-1, 3));
yyy = xmesh(:,r_idx)*sin([0:size(data5-1, 3)]*2*pi/size(data5-1, 3));
zzz = repmat(ymesh(:,r_idx),1,size(data5-1, 3)+1);

surf(xxx(1:end,1:tol).',yyy(1:end,1:tol).',zzz(1:end,1:tol).', Data3D(1:tol,:), 'EdgeColor', 'none');
xlabel("X")
ylabel("Y")
zlabel("Z")
colorbar;
hold on

xxx2=xmesh(:,:)*cos((tol-1)*2*pi/size(data5-1, 3));
yyy2=xmesh(:,:)*sin((tol-1)*2*pi/size(data5-1, 3));
zzz2=ymesh(:,:);

surf(xxx2,yyy2,zzz2, data2(:,:,(tol-1)), 'EdgeColor', 'none');

xxx3=xmesh(:,:)*cos(0*2*pi/size(data5, 3));
yyy3=xmesh(:,:)*sin(0*2*pi/size(data5, 3));
zzz3=ymesh(:,:);

surf(xxx3,yyy3,zzz3, data2(:,:,1), 'EdgeColor', 'none');
hold off


figure(4) % 3D poloidal closs-section
% for LS_condition_beam
f_condition='./LS_condition_JT60SA.txt';
fread_param2(obj);
fread_EQ1(obj);
%
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
plot3(B2(:,1),B2(:,2),B2(:,3),'o');
hold on
%
%Plot the path of the beam
plot3(xls1,yls1,zls1,'.');

% fluctuation
p2=fread_data_s(5,obj,file);
p2_s=zeros(obj.LYM2/(obj.KZMt+1), obj.nx0+1, obj.KZMt+1+1);

for i = 1:obj.KZMt+1
    p2_s(:,:,i)=[p2(:,:,i),zeros(length(p2),1,1)];
end
p2_s(:,:,end) = p2_s(:,:,1);

data2=zeros(obj.LYM2/(obj.KZMt+1), obj.nx0+1+obj.inside+obj.outside,obj.KZMt+1+1);
data2(:,obj.inside+1:end-obj.outside,:) = p2_s;

data5=zeros(size(data2,1),size(data2,2),size(data2,3));
for i = 1:obj.NTGMAX
    md = mod(i+(obj.NTGMAX/2),obj.NTGMAX);
    data5(md+1,:,:) = data2(i,:,:);
end
data5 = [data5; data5(1,:,:)];

data6 = data5(:, r_idx, :);

z_steps = size(data5, 3);  
Data3D2 = zeros(z_steps, size(data5, 1));
for phi = 1:size(data5, 3)
    Data3D2(phi, :) = data6(:, 1, phi).';  
end

xls_b=obj.GRC(r_idx,:).'*cos([0:size(data5, 3)]*2*pi/size(data5, 3));
yls_b=obj.GRC(r_idx,:).'*sin([0:size(data5, 3)]*2*pi/size(data5, 3));
zls_b=repmat(obj.GZC(r_idx,:).',1,size(data5, 3)+1);
surf(xls_b(1:end,1:tol).',yls_b(1:end,1:tol).',zls_b(1:end,1:tol).', Data3D2(1:tol,:), 'EdgeColor', 'none');
xlabel("X")
ylabel("Y")
zlabel("Z")

xls_b2=obj.GRC(:,:).'*cos((tol-1)*2*pi/size(data5, 3));
yls_b2=obj.GRC(:,:).'*sin((tol-1)*2*pi/size(data5, 3));
zls_b2=obj.GZC(:,:).';
surf(xls_b2,yls_b2,zls_b2, data5(:,:,(tol-1)), 'EdgeColor', 'none');

xls_b3=obj.GRC(:,:).'*cos(0*2*pi/size(data5, 3));
yls_b3=obj.GRC(:,:).'*sin(0*2*pi/size(data5, 3));
zls_b3=obj.GZC(:,:).';
surf(xls_b3,yls_b3,zls_b3, data5(:,:,1), 'EdgeColor', 'none');

hold off
%
end