% local value of data1
function z=probeEQ_local_s_p(obj,R0,Z0,PHI0,data1)
%
[poid2,aw,bw,cw]=probe_local_PID_p(obj,R0,Z0,PHI0);
z=probe_local_1(obj,poid2,aw,bw,cw,data1);
return
%
end

