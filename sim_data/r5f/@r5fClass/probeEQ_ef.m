% local value of ER, EZ, ET
function [ER, EZ, ET]=probeEQ_ef(obj,R0,Z0,PHI0)
%
dR=obj.DR1/5.0;
dZ=obj.DR2/5.0;
dphi=obj.DR3/5.0;
ER=(probeEQ_local_s(obj,R0+dR,Z0,PHI0,obj.PLASMA_PHI_total) ...
    -probeEQ_local_s(obj,R0-dR,Z0,PHI0,obj.PLASMA_PHI_total))/(2*dR);
EZ=(probeEQ_local_s(obj,R0,Z0+dZ,PHI0,obj.PLASMA_PHI_total) ...
    -probeEQ_local_s(obj,R0,Z0-dZ,PHI0,obj.PLASMA_PHI_total))/(2*dZ);
ET=(probeEQ_local_s(obj,R0,Z0,PHI0+dphi,obj.PLASMA_PHI_total) ...
    -probeEQ_local_s(obj,R0,Z0,PHI0-dphi,obj.PLASMA_PHI_total))/(2*dphi*R0);
return
%
end

