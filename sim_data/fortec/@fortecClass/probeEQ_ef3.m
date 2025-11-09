% local value of ER, EZ, ET
function [ER, EZ, ET]=probeEQ_ef3(obj,R0,Z0,PHI0)

%ER=0.0;
%EZ=0.0;
%ET=0.0;
%return

%
%[R0,Z0,PHI0]
dR=(obj.R(1,1,5)-obj.R(1,1,4))/32.0;
dZ=(obj.z(2,1,5)-obj.z(1,1,5))/32.0;
dphi=(obj.phi(1,2,5)-obj.phi(1,1,5))/32.0;
ER=-(probePOTENspl(obj,R0+dR,Z0,PHI0) ...
    -probePOTENspl(obj,R0-dR,Z0,PHI0))/(2*dR);
EZ=-(probePOTENspl(obj,R0,Z0+dZ,PHI0) ...
    -probePOTENspl(obj,R0,Z0-dZ,PHI0))/(2*dZ);
ET=-(probePOTENspl(obj,R0,Z0,PHI0+dphi) ...
    -probePOTENspl(obj,R0,Z0,PHI0-dphi))/(2*dphi*R0);
return
%
end