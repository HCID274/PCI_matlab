% local value of ER, EZ, ET
function [ER, EZ, ET]=probeEQ_ef1(obj,R0,Z0,PHI0)

%ER=0.0;
%EZ=0.0;
%ET=0.0;
%return

%
%[R0,Z0,PHI0]
dR=(obj.R(1,1,5)-obj.R(1,1,4))/10.0;
dZ=(obj.z(2,1,5)-obj.z(1,1,5))/10.0;
dphi=(obj.phi(1,2,5)-obj.phi(1,1,5))/10.0;
ER=-(probeEQ_local_s(obj,R0+dR,Z0,PHI0,obj.PLASMA_PHI_total) ...
    -probeEQ_local_s(obj,R0-dR,Z0,PHI0,obj.PLASMA_PHI_total))/(2*dR);
EZ=-(probeEQ_local_s(obj,R0,Z0+dZ,PHI0,obj.PLASMA_PHI_total) ...
    -probeEQ_local_s(obj,R0,Z0-dZ,PHI0,obj.PLASMA_PHI_total))/(2*dZ);
ET=-(probeEQ_local_s(obj,R0,Z0,PHI0+dphi,obj.PLASMA_PHI_total) ...
    -probeEQ_local_s(obj,R0,Z0,PHI0-dphi,obj.PLASMA_PHI_total))/(2*dphi*R0);
return
%
end

