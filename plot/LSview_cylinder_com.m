% detection along lines of sight for straight cylinder
function LSview_cylinder_com(sim,data_n,t,var)
% simulation type: 1(NLD)
% data#, time(0:time series), var
% using the condition file 'LS_condition_cylinder.txt'
%
oldpath=path;
path('../com',oldpath);
f_path='path.txt';
%
switch sim
    case {'NLD', 'nld'}
        FVER=1;
        oldpath=addpath('../sim_data/nld','../sim_data/nld/plot');
        dataC=nldClass(f_path,data_n);
    otherwise
        error('Unexpected simulation type.')
end
f_condition='./LS_condition_cylinder.txt';
% for LS_condition_multi_line
%A=importdata(f_condition);
%num=A.data(1);
%(R,Z,phi)
%pp1=reshape(A.data(2:end),num,3);
%if FVER==1
%(R,Z,phi)->(r,theta,phi)
%pp2=zeros(num,3);
%pp2(:,1)=sqrt(pp1(:,1).^2+pp1(:,2).~2);
%pp2(:,2)=atan2(pp1(:,2),pp1(:,1));
%pp2(:,3)=pp1(:,3);
%end
%divls=50;
%
% for LS_condition_beam
fread_param2(dataC);
dev_length=dataC.LAMBDA*dataC.RHOS;
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
B2(:,1)=B1(:,1);
B2(:,2)=B1(:,3)*dev_length;
B2(:,3)=B1(:,2);
B2=B2/1000.0;
b2ls=(B2(1,1)-B2(2,1))*(B2(1,1)-B2(2,1)) ...
    +(B2(1,2)-B2(2,2))*(B2(1,2)-B2(2,2)) ...
    +(B2(1,3)-B2(2,3))*(B2(1,3)-B2(2,3));
b2ls=sqrt(b2ls);
%
p1(1)=B2(1,1)-B2(2,1);
p1(2)=B2(1,2)-B2(2,2);
p1(3)=B2(1,3)-B2(2,3);
if(p1(1)==0 & p1(2)==0)
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
%
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
plot3(B2(:,1),B2(:,2),B2(:,3),'o');
hold on
plot3(xls1,yls1,zls1,'.');
xls_b=repmat((dataC.A/1000)*cos([0:30]*2*pi/30).',1,2);
zls_b=repmat((dataC.A/1000)*sin([0:30]*2*pi/30).',1,2);
yls_b=repmat([0,1]*(dev_length/1000),31,1);
plot3(xls_b,yls_b,zls_b,'k-');
plot3(xls_b.',yls_b.',zls_b.','k-');
hold off
pause
%
r1=sqrt(xls.*xls+zls.*zls)/(dataC.A/1000);
theta1=atan2(zls,xls)/pi;
ax1=yls/(dev_length/1000);
%
num1=num*divls_2;
r_p=reshape(r1,num1,1);
theta_p=reshape(theta1,num1,1);
ax_p=reshape(ax1,num1,1);
%
num1
x1=zeros(num1,3);
x1(:,1)=r_p;
x1(:,2)=theta_p;
x1(:,3)=ax_p;
probe_multi(sim,data_n,t,num1,x1,var);
%
path(oldpath);
end
