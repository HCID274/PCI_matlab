% rho at (R0, Z0)
function rho=probeEQ_rho(obj,R0,Z0,PHI0)
%
%x0=EQ.RG1(1)+[0:EQ.NRGM-1]*EQ.DR1;
%y0=EQ.RG2(1)+[0:EQ.NZGM-1]*EQ.DR2;
%z0=EQ.RG3(1)+[0:EQ.NPHIGM-1]*EQ.DR3;
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
  pcs_1=0.0;
  poid_cyl(1:3)=1;
  da_cyl(1:3)=0.0;
  rho=0.0;
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
rho=da_cyl(2)*(da_cyl(1)*m1+(1.0-da_cyl(1))*m2) ...
    + (1.0-da_cyl(2))*(da_cyl(1)*m1+(1-da_cyl(1))*m2);
rho=rho/(obj.nx0+1+obj.inside+obj.outside);
return
%
end

