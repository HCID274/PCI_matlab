function [dt_p xb]=bdpoint(x0, x1, Rbd)
%  x0(R,phi,z,vr,vp,vz), x1(R,phi,z,vr,vp,vz), R at the cal boundary
  if (x0(1) <= Rbd && x1(1) >= Rbd)
      dt_p=(Rbd-x0(1))/(x1(1)-x0(1));
      xb=(1-dt_p)*x0+dt_p*x1;
  else
      dt_p=0.0;
      xb=x1;
  end
end
