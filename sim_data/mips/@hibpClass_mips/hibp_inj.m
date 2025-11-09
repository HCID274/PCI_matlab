function [x,y,z,v,bp,inten]=hibp_inj(obj,x0,tracemax,ion_p)
% poid_cyl da_cyl;% position data
%
wid1=0.02; % size of ditector (estimat the sample volume width)  
%
n=fix(tracemax);
n1=fix(ion_p);
dn=ion_p-n1;
rs2=abs(x0(3));
dt=rs2*2*1.5/sqrt(x0(4)^2+(x0(1)*x0(5))^2+x0(6)^2)/n;
dt1=wid1/sqrt(x0(4)^2+(x0(1)*x0(5))^2+x0(6)^2);
cof1=9.58e-5/obj.mass; %q/m/(tau^2), tau=1e6
cof2=95.8/obj.mass; %q/m/tau
%
x=zeros(n,1);
inten0=0.0;
inten1=0.0;
bp=n;
y=x;
z=x;
v=x;
for a=1:n1
NE_local=probeEQ_local_s(obj,x0(1),x0(3),x0(2),obj.PLASMA_NE_total);
TE_local=probeEQ_local_s(obj,x0(1),x0(3),x0(2),obj.PLASMA_TE_total);
CAT=co_atten(obj,TE_local);
x1=Runge_motion(obj,x0,dt,cof1,cof2);
x(a)=x1(1)*cos(x1(2));
y(a)=x1(1)*sin(x1(2));
z(a)=x1(3);
v(a)=sqrt(x1(4)^2+(x1(5)*x1(1))^2+x1(6)^2);
if(x1(1) > obj.out_pos(1))
    [dt_b x1]=bdpoint(x0,x1,obj.out_pos(1));
    bp=a
    x(a)=x1(1)*cos(x1(2));
    y(a)=x1(1)*sin(x1(2));
    z(a)=x1(3);
    v(a)=sqrt(x1(4)^2+(x1(5)*x1(1))^2+x1(6)^2);
    inten0=inten0-CAT(1)*NE_local*dt_b;
    break
else
    x0=x1;
    inten0=inten0-CAT(1)*NE_local;
end
end
%
NE_local=probeEQ_local_s(obj,x0(1),x0(3),x0(2),obj.PLASMA_NE_total);
TE_local=probeEQ_local_s(obj,x0(1),x0(3),x0(2),obj.PLASMA_TE_total);
CAT=co_atten(obj,TE_local);
x1=Runge_motion(obj,x0,dt*dn,cof1,cof2);
inten0=inten0-CAT(1)*NE_local*dn;
% ionization +1->+2
   qi=2.0;
   cof1=cof1*qi;
   cof2=cof2*qi;
%
x(a)=x1(1)*cos(x1(2));
y(a)=x1(1)*sin(x1(2));
z(a)=x1(3);
v(a)=sqrt(x1(4)^2+(x1(5)*x1(1))^2+x1(6)^2);
x0=x1;
NE1=probeEQ_local_s(obj,x0(1),x0(3),x0(2),obj.PLASMA_NE_total)
TE1=probeEQ_local_s(obj,x0(1),x0(3),x0(2),obj.PLASMA_TE_total)
CAT1=co_atten(obj,TE1);
x1=Runge_motion(obj,x0,dt*(1-dn),cof1,cof2);
inten1=inten1-CAT1(2)*NE1*(1-dn);
a=a+1;
x(a)=x1(1)*cos(x1(2));
y(a)=x1(1)*sin(x1(2));
z(a)=x1(3);
v(a)=sqrt(x1(4)^2+(x1(5)*x1(1))^2+x1(6)^2);
x0=x1;
%
for a=n1+2:n
NE_local=probeEQ_local_s(obj,x0(1),x0(3),x0(2),obj.PLASMA_NE_total);
TE_local=probeEQ_local_s(obj,x0(1),x0(3),x0(2),obj.PLASMA_TE_total);
CAT=co_atten(obj,TE_local);
x1=Runge_motion(obj,x0,dt,cof1,cof2);
x(a)=x1(1)*cos(x1(2));
y(a)=x1(1)*sin(x1(2));
z(a)=x1(3);
v(a)=sqrt(x1(4)^2+(x1(5)*x1(1))^2+x1(6)^2);
if(x1(1) > obj.out_pos(1))
    [dt_b x1]=bdpoint(x0,x1,obj.out_pos(1));
    bp=a;
    x(a)=x1(1)*cos(x1(2));
    y(a)=x1(1)*sin(x1(2));
    z(a)=x1(3);
    v(a)=sqrt(x1(4)^2+(x1(5)*x1(1))^2+x1(6)^2);
    inten1=inten1-CAT(2)*NE_local*dt_b;
    break
else
    x0=x1;
    inten1=inten1-CAT(2)*NE_local;
end
end
inten0=inten0*dt;
inten1=inten1*dt;
inten=2.0*CAT1(1)*NE1*dt1*exp(inten0+inten1)
sprintf('%3e\t',2.0*CAT1(1)*NE1*dt1,exp(inten0),exp(inten1))
end