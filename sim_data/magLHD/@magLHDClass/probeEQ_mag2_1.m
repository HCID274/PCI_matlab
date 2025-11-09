% local value of BR, BZ, BT
function [BR, BZ, BT]=probeEQ_mag(obj,R0,Z0,PHI0)
%{
[BR, BZ, BT]=probeEQ_local_v(obj,R0,Z0,PHI0,obj.BF);
return
%}
%{
    BR=0.0;
    BZ=0.0;
    BT=-0.2*3.7/R0;
    return
%}
%[R0,Z0,PHI0]
NF=3;
NCDX=obj.NRGM;
NCDY=obj.NPHIGM;
NCDZ=obj.NZGM;
FA=zeros(NF,NCDX,NCDY,NCDZ);
FA(1,:,:,:)=obj.BF1;
FA(2,:,:,:)=obj.BF2;
FA(3,:,:,:)=obj.BF3;
W0=zeros(NF,1);
%
r_min=obj.R_mag(1);
r_max=obj.R_mag(end);
z_min=obj.Z_mag(1);
z_max=obj.Z_mag(end);
phi_min=obj.Phi_mag(1);
phi_max=obj.Phi_mag(end);
if((R0 < r_max) && (R0 >= r_min) && (Z0 < z_max) && (Z0 >= z_min) )
XD=R0;
YD=PHI0;
ZD=Z0;
W0=SPL3DF(NF, FA, XD, YD, ZD);
pcs_1=1.0;
BR=W0(1);
BT=W0(2);
BZ=W0(3);
else
    pcs_1=0.0;
    BR=0.0;
    BZ=0.0;
    BT=0.0;
    return
end
end

