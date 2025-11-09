% detection along lines of sight
function [pout1, pout2] = LSview_com(sim,data_n,t,var)
% simulation type: 2(DISA),3(R4F),3.5(R5F),5(GENE)
% data#, time(0:time series), var
% using the condition file 'LS_condition.txt'
%
oldpath=path;
path('../com',oldpath);
f_path='path.txt';
%
switch sim
    case {'R5F', 'r5f'}
        FVER=3.5;
        oldpath=addpath('../sim_data/r5f','../sim_data/task_eq','../sim_data/r5f/plot');
        dataC=r5fClass(f_path,data_n);
    case {'MIPS', 'mips'}
        FVER=4;
        oldpath=addpath('../sim_data/mips','../sim_data/mips/plot');
        dataC=hibpClass_mips(f_path,data_n);
    case {'GENE', 'gene'}
        FVER=5;
        oldpath=addpath('../sim_data/GENE','../sim_data/task_eq','../sim_data/GENE/plot');
        dataC=GENEClass(f_path,data_n);
    otherwise
        error('Unexpected simulation type.')
end

%f_condition='./LS_condition.txt';
f_condition='./LS_condition_JT60SA.txt';

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
if FVER == 5   % To calculate obj.KYMt and obj.KZMt
    %Generate time data (00****.dat) from TORUSIons_act.dat
    GENEdata = sprintf('%sTORUSIons_act_%.0f.dat', dataC.indir, t*100)
    generate_timedata(dataC,GENEdata,t);
end
% for LS_condition_beam
fread_param2(dataC);
fread_EQ1(dataC);
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
p1(3)=B2(1,3)-B2(2,3);
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
figure(1)
plot3(B2(:,1),B2(:,2),B2(:,3),'o');
hold on
%
%Plot the path of the beam
plot3(xls1,yls1,zls1,'.');
%
%Plot the shape of the tokamak
xls_b=dataC.GRC(end,:).'*cos([0:30]*2*pi/30);
yls_b=dataC.GRC(end,:).'*sin([0:30]*2*pi/30);
zls_b=repmat(dataC.GZC(end,:).',1,31);
%plot3(xls_b,yls_b,zls_b,'k-');
plot3(xls_b(1:2:end,:).',yls_b(1:2:end,:).',zls_b(1:2:end,:).','k-');
%
xlabel("X")
ylabel("Y")
zlabel("Z")
hold off
%
xls_c=zeros(divls_2,3);
xls_c(:,1)=squeeze(xls(div1+1,div2+1,:));
xls_c(:,2)=squeeze(yls(div1+1,div2+1,:));
xls_c(:,3)=squeeze(zls(div1+1,div2+1,:));
xl_c(1,:)=xl(1,:)/norm(xl(1,:));
xl_c(2,:)=xl(2,:)/norm(xl(2,:));
%{
plot3(xls_c(:,1),xls_c(:,2),xls_c(:,3));
%plot3(xls_c(1:10,1),xls_c(1:10,2),xls_c(1:10,3),'o');
hold on
quiver3(xls_c(1,1),xls_c(1,2),xls_c(1,3),xl_c(1,1),xl_c(1,2),xl_c(1,3))
quiver3(xls_c(1,1),xls_c(1,2),xls_c(1,3),xl_c(2,1),xl_c(2,2),xl_c(2,3))
plot3(xls_b,yls_b,zls_b,'k-');
plot3(xls_b.',yls_b.',zls_b.','k-');
hold off
%}
%
LSmag(dataC,divls_2,xls_c,p1);
%
r1=sqrt(xls.*xls+yls.*yls);
phi1=atan2(yls,xls);
%
num1=num*divls_2;
r_p=reshape(r1,num1,1);
zls2=reshape(zls,num1,1);
phi_p=reshape(phi1,num1,1);
%
x1=zeros(num1,3);
x1(:,1)=r_p;
x1(:,2)=zls2;
x1(:,3)=phi_p;
%
if FVER == 5   % GENE
    [pout,R,Z]=probe_multi2(sim,data_n,t,num1,x1,var,p1); %using p1 to calculate beam vector
else
    pout=probe_multi(sim,data_n,t,num1,x1,var);
end
%{
% multi fluctuation
if FVER == 5
    n = 0;
    data_n2 = input('data_n = (Enter 0 to exit.)');
    while data_n2 ~= 0
        n = n + 1;
        data_nlist(n) = data_n2
        data_n2 = input('data_n = (Enter 0 to exit.)');
    end
    [pout,R,Z]=probe_multi3(sim,data_nlist,t,num1,x1,var,p1,n); %using p1 to calculate beam vector
else
    pout=probe_multi(sim,data_n,t,num1,x1,var);
end
%}
if (t~=0)
    pout1=reshape(pout,div1_2,div2_2,divls_2);
    %Line of sight integration
    pout2=sum(pout1,3);
    %
    [xx1,yy1]=meshgrid(wid1/2*[-div1:div1]/div1,-wid2/2*[-div2:div2]/div2);
    xx1 = fliplr(xx1);

    figure(3)
    contourf(yy1.',xx1.',pout2,100,'LineStyle','none');
    shading flat;
    axis equal;
    colorbar
    xlabel('x (m)');
    ylabel('y (m)');
    
    %figure3_path = sprintf('%s%s%s%d',dataC.indir,'figure/','figure3_',t*100)
    %saveas(figure(3),figure3_path)
end
%
%2D Fourier Transform
figure(4)
plotWaveNumberSpace(yy1.',xx1.',pout2,dataC)
%
%figure4_path = sprintf('%s%s%s%d',dataC.indir,'figure/','figure4_',t*100)
%saveas(figure(4),figure4_path)
%
LS_location(dataC,xls1,yls1,zls1,div1_2,div2_2,divls_2)
path(oldpath);

end