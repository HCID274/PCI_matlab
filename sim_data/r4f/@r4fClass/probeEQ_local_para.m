% local value of data1
function [z1, z2]=probeEQ_local_para(obj,R0,Z0,PHI0,data11,data12)
%
%x0=obj.RG1(1)+[0:obj.NRGM-1]*obj.DR1;
%y0=obj.RG2(1)+[0:obj.NZGM-1]*obj.DR2;
%z0=obj.RG3(1)+[0:obj.NPHIGM-1]*obj.DR3;
%
%data11=obj.NEt;
%data12=obj.TEt;
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
    %pcs_1=1.0;
else
    %pcs_1=0.0;
    %poid_cyl(1:3)=1;
    %da_cyl(1:3)=0.0;
    z1=0.0;
    z2=0.0;
    return
end
%
m1=poid_cyl(1);
n1=poid_cyl(2);
m2=m1+1;
n2=n1+1;
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
data2=da_cyl(1)*data11(:,m1)+(1.0-da_cyl(1))*data11(:,m2);
data2=data2.';
z1=2*(real(data2)*cos_pha-imag(data2)*sin_pha);
%z1=pcs_1*2*z1;
data2=da_cyl(1)*data12(:,m1)+(1.0-da_cyl(1))*data12(:,m2);
data2=data2.';
z2=2*(real(data2)*cos_pha-imag(data2)*sin_pha);
%z2=pcs_1*2*z2;
%
end