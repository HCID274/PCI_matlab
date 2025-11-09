function poten=probePOTENspl(obj,R0,Z0,PHI0)
%
NF=1;
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
    poten=SPL3DF_2(obj.splPOTEN,NF, obj.POTEN3D, XD, YD, ZD);
else
    pcs_1=0.0;
    poten=0.0;
end
%
end