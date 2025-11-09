function x1=Runge_motion(obj,x0,dt,cof1,cof2)
% x0(1:6)-(r,phi,z,r',phi',z')
%
x1=zeros(6,1);
xt=zeros(6,1);
k=zeros(6,4);
B=zeros(3,1);
E=zeros(3,1);
B1=zeros(3,1);
%
%dR=(obj.R(5,1)-obj.R(4,1))/2.0;
%dZ=(obj.z(5,5)-obj.z(5,4))/2.0;
%
xt=x0;
%[xt(1),xt(3),xt(2)]
[B(1), B(3), B(2)]=probeEQ_mag(obj,xt(1),xt(3),xt(2));
[E(1), E(3), E(2)]=probeEQ_ef(obj,xt(1),xt(3),xt(2));
%B;
%E;
k(:,1)=rhs(xt,B,E,cof1,cof2)*dt;
xt=x0+k(:,1)/2.0;
[B(1), B(3), B(2)]=probeEQ_mag(obj,xt(1),xt(3),xt(2));
[E(1), E(3), E(2)]=probeEQ_ef(obj,xt(1),xt(3),xt(2));
k(:,2)=rhs(xt,B,E,cof1,cof2)*dt;
xt=x0+k(:,2)/2.0;
[B(1), B(3), B(2)]=probeEQ_mag(obj,xt(1),xt(3),xt(2));
[E(1), E(3), E(2)]=probeEQ_ef(obj,xt(1),xt(3),xt(2));
k(:,3)=rhs(xt,B,E,cof1,cof2)*dt;
xt=x0+k(:,3);
[B(1), B(3), B(2)]=probeEQ_mag(obj,xt(1),xt(3),xt(2));
[E(1), E(3), E(2)]=probeEQ_ef(obj,xt(1),xt(3),xt(2));
k(:,4)=rhs(xt,B,E,cof1,cof2)*dt;
%
x1=x0+k(:,1)/6.0+k(:,2)/3.0+k(:,3)/3.0+k(:,4)/6.0;
end
%
function f=rhs(x0,B,E,cof1,cof2) 
f(1)=x0(4);
f(2)=x0(5);
f(3)=x0(6);
f(4)=cof1*E(1)+x0(1)*x0(5)^2+cof2*(x0(1)*x0(5)*B(3)-x0(6)*B(2));
f(5)=cof1*E(2)/x0(1)-2.0/x0(1)*x0(4)*x0(5)+cof2*(x0(6)*B(1)-x0(4)*B(3))/x0(1);
f(6)=cof1*E(3)+cof2*(x0(4)*B(2)-x0(1)*x0(5)*B(1));
end