% local value of data1
%function [g_R, g_Z, g_T]=probeEQ_local_grad(obj,R0,Z0,PHI0,dR,dZ)
function [g_R, g_Z, g_T]=probeEQ_local_grad(obj,R0,Z0,PHI0,data1,dR,dZ)
%{
g_R=(probeEQ_local(obj,R0+dR/2,Z0,PHI0,data1)-probeEQ_local(obj,R0-dR/2,Z0,PHI0,data1))/dR;
g_Z=(probeEQ_local(obj,R0,Z0+dZ/2,PHI0,data1)-probeEQ_local(obj,R0,Z0-dZ/2,PHI0,data1))/dZ;
%}
%
data11=obj.PHIt_re;
data12=obj.PHIt_im;
g_R=(probeEQ_local1(obj,R0+dR/2,Z0,PHI0,data11,data12)-probeEQ_local1(obj,R0-dR/2,Z0,PHI0,data11,data12))/dR;
g_Z=(probeEQ_local1(obj,R0,Z0+dZ/2,PHI0,data11,data12)-probeEQ_local1(obj,R0,Z0-dZ/2,PHI0,data11,data12))/dZ;
%}
%{
g_R=(probeEQ_local(obj,R0+dR/2,Z0,PHI0)-probeEQ_local(obj,R0-dR/2,Z0,PHI0))/dR;
g_Z=(probeEQ_local(obj,R0,Z0+dZ/2,PHI0)-probeEQ_local(obj,R0,Z0-dZ/2,PHI0))/dZ;
%}
%g_T=(probeEQ_local(obj,R0,Z0,PHI0+dPHI/2,data1)-probeEQ_local(obj,R0,Z0,PHI0-dPHI/2,data1))/dPHI/R0;
%g_R=0.0;
%g_Z=0.0;
g_T=0.0;
%
end

%{
% local value of data1
function z=probeEQ_local(obj,R0,Z0,PHI0,data1)
%function z=probeEQ_local(obj,R0,Z0,PHI0)
%
%x0=obj.RG1(1)+[0:obj.NRGM-1]*obj.DR1;
%y0=obj.RG2(1)+[0:obj.NZGM-1]*obj.DR2;
%z0=obj.RG3(1)+[0:obj.NPHIGM-1]*obj.DR3;
%
poid_cyl=zeros(3,1);
da_cyl=zeros(3,1);
r=sqrt((R0-obj.PA(1)).^2+(Z0-obj.PA(2)).^2);
theta=mod(atan2(Z0-obj.PA(2),R0-obj.PA(1)),2*pi);
theta_p=bisec(theta,obj.GTC_c(end,:));
%
if((r < obj.GAC(end,theta_p(1))) && (r < obj.GAC(end,theta_p(2))))
    poid_cyl(2)=theta_p(1);
    r_p=bisec(r,obj.GAC(:,poid_cyl(2)).');
    poid_cyl(1)=r_p(1);
    poid_cyl(3)=fix((PHI0-obj.RG3(1))/obj.DR3)+1;
    pcs_1=1.0;
else
    %pcs_1=0.0;
    %poid_cyl(1:3)=1;
    %da_cyl(1:3)=0.0;
    z=0.0;
    return
end
%
m1=poid_cyl(1);
n1=poid_cyl(2);
m2=m1+1;
n2=n1+1;
%aa=[obj.GRC(m1,n1) obj.GZC(m1,n1); obj.GRC(m2,n1) obj.GZC(m2,n1); ...
%    obj.GRC(m1,n2) obj.GZC(m1,n2); obj.GRC(m2,n2) obj.GZC(m2,n2);];
%plot(aa(:,1),aa(:,2),'+')
%hold on
%plot(R0,Z0,'o')
%hold off
%pause
ya=obj.GTC_c(m1,n1);
yb=obj.GTC_c(m1,n2);
da_cyl(2)=(yb-theta)/(yb-ya);
pl(1)=(obj.GAC(m2,n1)-r)/(obj.GAC(m2,n1)-obj.GAC(m1,n1));
pl(2)=(obj.GAC(m2,n2)-r)/(obj.GAC(m2,n2)-obj.GAC(m1,n2));
da_cyl(1)=pl(1)*da_cyl(2)+pl(2)*(1.0-da_cyl(2));
GBPR=obj.GTC_f;
theta_f0=da_cyl(2)*(da_cyl(1)*GBPR(m1,n1)+(1.0-da_cyl(1))*GBPR(m2,n1)) ...
    + (1.0-da_cyl(2))*(da_cyl(1)*GBPR(m1,n2)+(1-da_cyl(1))*GBPR(m2,n2));
pha=theta_f0*obj.LKY-PHI0*obj.LKZ;
tic
cos_pha=cos(pha);
sin_pha=sin(pha);
toc
%
%data2(:)=da_cyl(1)*data1(m1,:)+(1.0-da_cyl(1))*data1(m2,:);
%{}
tic
data2=da_cyl(1)*data1(:,m1)+(1.0-da_cyl(1))*data1(:,m2);
data2 = data2.';
toc
tic
data21=da_cyl(1)*data1(:,m1);
data22=(1.0-da_cyl(1))*data1(:,m2);
data2=data21+data22;
data2 = data2.';
whos data2
toc
%data21=da_cyl(1)*obj.PHIt(:,m1);
%data22=(1.0-da_cyl(1))*obj.PHIt(:,m2);
%whos data2
%data2 = (data21+data22).';
%
z=2*(real(data2)*cos_pha-imag(data2)*sin_pha);
%z=pcs_1*2*z;
%
pause
end
%}

function z=probeEQ_local1(obj,R0,Z0,PHI0,data11,data12)
%
%x0=obj.RG1(1)+[0:obj.NRGM-1]*obj.DR1;
%y0=obj.RG2(1)+[0:obj.NZGM-1]*obj.DR2;
%z0=obj.RG3(1)+[0:obj.NPHIGM-1]*obj.DR3;
%
poid_cyl=zeros(3,1);
da_cyl=zeros(3,1);
r=sqrt((R0-obj.PA(1)).^2+(Z0-obj.PA(2)).^2);
theta=mod(atan2(Z0-obj.PA(2),R0-obj.PA(1)),2*pi);
theta_p=obj.bisec(theta,obj.GTC_c(end,:));
%
if((r < obj.GAC(end,theta_p(1))) && (r < obj.GAC(end,theta_p(2))))
    poid_cyl(2)=theta_p(1);
    r_p=obj.bisec(r,obj.GAC(:,poid_cyl(2)).');
    poid_cyl(1)=r_p(1);
    poid_cyl(3)=fix((PHI0-obj.RG3(1))/obj.DR3)+1;
    pcs_1=1.0;
else
    %pcs_1=0.0;
    %poid_cyl(1:3)=1;
    %da_cyl(1:3)=0.0;
    z=0.0;
    return
end
%
m1=poid_cyl(1);
n1=poid_cyl(2);
m2=m1+1;
n2=n1+1;
%aa=[obj.GRC(m1,n1) obj.GZC(m1,n1); obj.GRC(m2,n1) obj.GZC(m2,n1); ...
%    obj.GRC(m1,n2) obj.GZC(m1,n2); obj.GRC(m2,n2) obj.GZC(m2,n2);];
%plot(aa(:,1),aa(:,2),'+')
%hold on
%plot(R0,Z0,'o')
%hold off
%pause
ya=obj.GTC_c(m1,n1);
yb=obj.GTC_c(m1,n2);
da_cyl(2)=(yb-theta)/(yb-ya);
pl(1)=(obj.GAC(m2,n1)-r)/(obj.GAC(m2,n1)-obj.GAC(m1,n1));
pl(2)=(obj.GAC(m2,n2)-r)/(obj.GAC(m2,n2)-obj.GAC(m1,n2));
da_cyl(1)=pl(1)*da_cyl(2)+pl(2)*(1.0-da_cyl(2));
GBPR=obj.GTC_f;
theta_f0=da_cyl(2)*(da_cyl(1)*GBPR(m1,n1)+(1.0-da_cyl(1))*GBPR(m2,n1)) ...
    + (1.0-da_cyl(2))*(da_cyl(1)*GBPR(m1,n2)+(1-da_cyl(1))*GBPR(m2,n2));
pha=theta_f0*obj.LKY-PHI0*obj.LKZ;
cos_pha=cos(pha);
sin_pha=sin(pha);

%data2(:)=da_cyl(1)*data1(m1,:)+(1.0-da_cyl(1))*data1(m2,:);
%{});
data21=da_cyl(1)*data11(:,m1)+(1.0-da_cyl(1))*data11(:,m2);
data22=da_cyl(1)*data12(:,m1)+(1.0-da_cyl(1))*data12(:,m2);
data21=data21.';
data22=data22.';
%
z=2*(data21*cos_pha-data22*sin_pha);
end