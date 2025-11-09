% local value of BR, BZ, BT, PP
function [BR BZ BT PP]=probeEQ_mag(obj,R0,Z0,PHI0)
%
%x0=EQ.RG1(1)+[0:EQ.NRGM-1]*EQ.DR1;
%y0=EQ.RG2(1)+[0:EQ.NZGM-1]*EQ.DR2;
%z0=EQ.RG3(1)+[0:EQ.NPHIGM-1]*EQ.DR3;
%
poid_mag=zeros(3,1);
da_mag=zeros(3,1);
r_min=obj.RG1(1);
r_max=obj.RG1(2);
z_min=obj.RG2(1);
z_max=obj.RG2(2);
%DR1=obj.DR1;
%DR2=obj.DR2;
DR3=obj.DR3;
DR1=(r_max-r_min)/(obj.NRGM-1);
DR2=(z_max-z_min)/(obj.NZGM-1);
%DR3=(phi_max-phi_min)/(obj.NPHIGM-1);
if((R0 < r_max) && (R0 >= r_min) && (Z0 < z_max) && (Z0 >= z_min))
  poid_mag(1)=fix((R0-obj.RG1(1))/DR1)+1;
  poid_mag(2)=fix((Z0-obj.RG2(1))/DR2)+1;
  poid_mag(3)=fix((PHI0-obj.RG3(1))/DR3)+1;
  pcs_1=1.0;
else
  pcs_1=0.0;
  poid_mag(1:3)=1;
  da_mag(1:3)=0.0;
  BR=0.0;
  BZ=0.0;
  BT=0.0;
  PP=0.0;
  return
end
%
xa=poid_mag(1);
xb=xa+1;
x0=obj.RG1(1)+[0:obj.NRGM-1]*DR1;
da_mag(1)=(x0(xb)-R0)/(x0(xb)-x0(xa));
xa=poid_mag(2);
xb=xa+1;
x0=obj.RG2(1)+[0:obj.NZGM-1]*DR2;
da_mag(2)=(x0(xb)-Z0)/(x0(xb)-x0(xa));
%xa=poid_mag(3);
%xb=xa+1;
%x0=obj.RG3(1)+[0:obj.NPHIGM-1]*DR3;
%da_mag(3)=(x0(xb)-PHI0)/(x0(xb)-x0(xa));
%
m1=poid_mag(1);
n1=poid_mag(2);
m2=m1+1;
n2=n1+1;
GBPR=squeeze(obj.GBPR_3d(:,:,1));
BR=da_mag(2)*(da_mag(1)*GBPR(m1,n1)+(1.0-da_mag(1))*GBPR(m2,n1)) ...
    + (1.0-da_mag(2))*(da_mag(1)*GBPR(m1,n2)+(1-da_mag(1))*GBPR(m2,n2));
BR=pcs_1*BR;
GBPR=squeeze(obj.GBPZ_3d(:,:,1));
BZ=da_mag(2)*(da_mag(1)*GBPR(m1,n1)+(1.0-da_mag(1))*GBPR(m2,n1)) ...
    + (1.0-da_mag(2))*(da_mag(1)*GBPR(m1,n2)+(1-da_mag(1))*GBPR(m2,n2));
BZ=pcs_1*BZ;
GBPR=squeeze(obj.GBTP_3d(:,:,1));
BT=da_mag(2)*(da_mag(1)*GBPR(m1,n1)+(1.0-da_mag(1))*GBPR(m2,n1)) ...
    + (1.0-da_mag(2))*(da_mag(1)*GBPR(m1,n2)+(1-da_mag(1))*GBPR(m2,n2));
BT=pcs_1*BT;
GBPR=squeeze(obj.GBPP_3d(:,:,1));
PP=da_mag(2)*(da_mag(1)*GBPR(m1,n1)+(1.0-da_mag(1))*GBPR(m2,n1)) ...
    + (1.0-da_mag(2))*(da_mag(1)*GBPR(m1,n2)+(1-da_mag(1))*GBPR(m2,n2));
PP=pcs_1*PP;
%[BR BZ BT PP]
return
end

