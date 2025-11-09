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
NF=3;
NCDX=obj.NRGM;
NCDY=obj.NPHIGM;
NCDZ=obj.NZGM;
%FA=zeros(NF,NCDX,NCDY,NCDZ);
%FA(1,:,:,:)=obj.BF1;
%FA(2,:,:,:)=obj.BF2;
%FA(3,:,:,:)=obj.BF3;
W0=zeros(NF,1);
%
r_min=obj.R_mag(1);
r_max=obj.R_mag(end);
z_min=obj.Z_mag(1);
z_max=obj.Z_mag(end);
phi_min=obj.Phi_mag(end);
phi_max=obj.Phi_mag(1);
if((R0 < r_max) && (R0 > r_min) && (Z0 < z_max) && (Z0 > z_min) )
XD=R0;
PHI0=mod(PHI0-phi_min,phi_max-phi_min)+phi_min;%within phi_min-phi_max
YD=PHI0;
ZD=Z0;
%[R0,Z0,PHI0]
pcs_1=1.0;
W0=SPL3DF(NF, obj.BF3D, XD, YD, ZD);
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

