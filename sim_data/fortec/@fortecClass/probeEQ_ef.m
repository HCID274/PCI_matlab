function [ER, EZ, ET]=probeEQ_ef(obj,R0,Z0,PHI0)
ER=0.0;
EZ=0.0;
ET=0.0;
%rho=probeEQ_local_s(obj,R0,Z0,PHI0,obj.rho);
%if rho < 1.0 & rho > 0.0
%[ER, EZ, ET]=probeEQ_ef1(obj,R0,Z0,PHI0);%finite def
[ER, EZ, ET]=probeEQ_ef1_p(obj,R0,Z0,PHI0);%extended mesh with data_convert
%[ER, EZ, ET]=probeEQ_ef2(obj,R0,Z0,PHI0);%spline E
%[ER, EZ, ET]=probeEQ_ef3(obj,R0,Z0,PHI0);%spline potential
%[ER, EZ, ET, p]=probeEQ_ef4(obj,R0,Z0,PHI0);%model prof
%end
end

