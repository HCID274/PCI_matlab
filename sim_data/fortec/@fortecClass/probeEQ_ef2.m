% local value of ER, EZ, ET
function [ER, EZ, ET]=probeEQ_ef2(obj,R0,Z0,PHI0)

%ER=0.0;
%EZ=0.0;
%ET=0.0;
%return

%
NF=3;
NCDX=obj.num2;
NCDY=obj.num3;
NCDZ=obj.num1;
%FA=zeros(NF,NCDX,NCDY,NCDZ);
%FA(1,:,:,:)=obj.BF1;
%FA(2,:,:,:)=obj.BF2;
%FA(3,:,:,:)=obj.BF3;
W0=zeros(NF,1);
%
rho=probeEQ_local_s(obj,R0,Z0,PHI0,obj.rho);
if rho < 1.0 & rho > 0.0
    PHI0=mod(PHI0-obj.phi_si(1),obj.phi_si(end)-obj.phi_si(1))+obj.phi_si(1);%within phi_min-phi_max
    yc=bisec(PHI0,obj.phi_si);
    ya=yc(1);
    yb=yc(2);
    Rax=((obj.phi_si(yb)-PHI0)*obj.Rax(ya)+(PHI0-obj.phi_si(ya))*obj.Rax(yb))/(obj.phi_si(yb)-obj.phi_si(ya));
    zax=((obj.phi_si(yb)-PHI0)*obj.zax(ya)+(PHI0-obj.phi_si(ya))*obj.zax(yb))/(obj.phi_si(yb)-obj.phi_si(ya));
    XD=mod(atan2(Z0-zax,R0-Rax),2*pi);
    YD=PHI0;
    ZD=rho;
    pcs_1=1.0;
    W0=SPL3DF_2(obj.splEF,NF, obj.EF3D, XD, YD, ZD);
    ER=W0(1);
    ET=W0(2);
    EZ=W0(3);
else
    pcs_1=0.0;
    ER=0.0;
    EZ=0.0;
    ET=0.0;
end
%
end
