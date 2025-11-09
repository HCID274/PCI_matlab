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
%(r,phi,z)
r_min=obj.R_mag(1);
r_max=obj.R_mag(end);
z_min=obj.Z_mag(1);
z_max=obj.Z_mag(end);
phi_min=obj.Phi_mag(1);
phi_max=obj.Phi_mag(end);
%[R0,Z0,r_min,r_max,z_min,z_max]

DR=obj.R_mag(2)-obj.R_mag(1);
DZ=obj.Z_mag(2)-obj.Z_mag(1);
Dphi=obj.Phi_mag(2)-obj.Phi_mag(1);
%
if((R0 < r_max) && (R0 >= r_min) && (Z0 < z_max) && (Z0 >= z_min) )
    rw=((R0-r_min)/DR)+1;
    poid_r(1)=fix(rw);
    poid_r(2)=poid_r(1)+1;
    rw=rw-poid_r(1);
    zw=((Z0-z_min)/DZ)+1;
    poid_z(1)=fix(zw);
    poid_z(2)=poid_z(1)+1;
    zw=zw-poid_z(1);
    % for phi direction
    PHI0=mod(PHI0-phi_min,phi_max-phi_min)+phi_min;%within phi_min-phi_max
    cw=((PHI0-phi_min)/Dphi)+1;
    poid_phi(1)=fix(cw);
    poid_phi(2)=poid_phi(1)+1;
    cw=cw-poid_phi(1);
    pcs_1=1.0;
else
    %pcs_1=0.0;
    %poid_mag(1:3)=1;
    %da_mag(1:3)=0.0;
    BR=0.0;
    BZ=0.0;
    BT=0.0;
    return
end
data=obj.BF1;
BR=((data(poid_r(1),poid_phi(1),poid_z(1))*(1.0-cw)+data(poid_r(1),poid_phi(2),poid_z(1))*cw)*(1.0-zw)...
        +(data(poid_r(1),poid_phi(1),poid_z(2))*(1.0-cw)+data(poid_r(1),poid_phi(2),poid_z(2))*cw)*(1.0-zw))*(1.0-rw)...
    +((data(poid_r(2),poid_phi(1),poid_z(1))*(1.0-cw)+data(poid_r(2),poid_phi(2),poid_z(1))*cw)*(1.0-zw)...
        +(data(poid_r(2),poid_phi(1),poid_z(2))*(1.0-cw)+data(poid_r(2),poid_phi(2),poid_z(2))*cw)*(1.0-zw))*rw;
BR=pcs_1*BR;
data=obj.BF3;
BZ=((data(poid_r(1),poid_phi(1),poid_z(1))*(1.0-cw)+data(poid_r(1),poid_phi(2),poid_z(1))*cw)*(1.0-zw)...
        +(data(poid_r(1),poid_phi(1),poid_z(2))*(1.0-cw)+data(poid_r(1),poid_phi(2),poid_z(2))*cw)*(1.0-zw))*(1.0-rw)...
    +((data(poid_r(2),poid_phi(1),poid_z(1))*(1.0-cw)+data(poid_r(2),poid_phi(2),poid_z(1))*cw)*(1.0-zw)...
        +(data(poid_r(2),poid_phi(1),poid_z(2))*(1.0-cw)+data(poid_r(2),poid_phi(2),poid_z(2))*cw)*(1.0-zw))*rw;
BZ=pcs_1*BZ;
data=obj.BF2;
BT=((data(poid_r(1),poid_phi(1),poid_z(1))*(1.0-cw)+data(poid_r(1),poid_phi(2),poid_z(1))*cw)*(1.0-zw)...
        +(data(poid_r(1),poid_phi(1),poid_z(2))*(1.0-cw)+data(poid_r(1),poid_phi(2),poid_z(2))*cw)*(1.0-zw))*(1.0-rw)...
    +((data(poid_r(2),poid_phi(1),poid_z(1))*(1.0-cw)+data(poid_r(2),poid_phi(2),poid_z(1))*cw)*(1.0-zw)...
        +(data(poid_r(2),poid_phi(1),poid_z(2))*(1.0-cw)+data(poid_r(2),poid_phi(2),poid_z(2))*cw)*(1.0-zw))*rw;
BT=pcs_1*BT;
%}
end

