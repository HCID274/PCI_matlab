% local value of ER, EZ, ET
function [ER, EZ, ET, p]=probeEQ_ef4(obj,R0,Z0,PHI0)

%ER=0.0;
%EZ=0.0;
%ET=0.0;
%return

%
%[R0,Z0,PHI0]
dR=(obj.R(1,1,5)-obj.R(1,1,4))/32.0;
dZ=(obj.z(2,1,5)-obj.z(1,1,5))/32.0;
dphi=(obj.phi(1,2,5)-obj.phi(1,1,5))/32.0;
ER=-(poten(R0+dR,Z0,PHI0) ...
    -poten(R0-dR,Z0,PHI0))/(2*dR);
EZ=-(poten(R0,Z0+dZ,PHI0) ...
    -poten(R0,Z0-dZ,PHI0))/(2*dZ);
ET=-(poten(R0,Z0,PHI0+dphi) ...
    -poten(R0,Z0,PHI0-dphi))/(2*dphi*R0);
p=poten(R0,Z0,PHI0);
return
%
end

function p=poten(R,Z,PHI)
poten0=4.0e3;
R0=3.75;
Z0=0.0;
a=0.6;
r=sqrt((R-R0)^2+(Z-Z0)^2)/a;
if r<1.0
    p=poten0*(1.0-r^2)^2;
else
    p=0;
end
return
end