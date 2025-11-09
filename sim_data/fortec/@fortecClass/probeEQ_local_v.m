% local vector of data2
function [BR, BZ, BT]=probeEQ_local_v(obj,R0,Z0,PHI0,data2)
%
[poid2,aw,bw,cw]=probe_local_PID(obj,R0,Z0,PHI0);
z=probe_local_3(obj,poid2,aw,bw,cw,data2);
BR=z(1);
BZ=z(2);
BT=z(3);
return
%
end
