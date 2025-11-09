% PID for the position(step 1)
%
function [poid2, aw, bw, cw]=probe_local_PID(obj,R0,Z0,PHI0)
%
%obj:theta_si(num2),phi_si(num3),radius(num2,num3,num1),Rax(num3),zax(num3)
%
[num2 num3 num1]=size(obj.radius);
poid2=zeros(2,2,2);%poid2(b,c,a)
%
RG3=zeros(2,1);%phi
RG3(1)=obj.phi_si(1);
RG3(2)=obj.phi_si(end);
DR3=obj.phi_si(2)-obj.phi_si(1);
RG4=zeros(2,1);%theta
RG4(1)=obj.theta_si(1);
RG4(2)=obj.theta_si(end);
DR4=obj.theta_si(2)-obj.theta_si(1);
%
% for phi direction
PHI0=mod(PHI0-RG3(1),RG3(2)-RG3(1))+RG3(1);%within RG3(1)-RG3(2)
cw=((PHI0-RG3(1))/DR3)+1;
c1=fix(cw);
c2=c1+1;
cw=cw-c1;
%
% for theta direction
THETA0=zeros(2,1);
bw=zeros(2,1);
b1=zeros(2,1);
%b2=zeros(2,1);
cp=zeros(2,1);
cp(1)=c1;
cp(2)=c2;
r0=zeros(2,1);
for c=1:2
    THETA0(c)=mod(atan2(Z0-obj.zax(cp(c)),R0-obj.Rax(cp(c))),2*pi);
    bw(c)=((THETA0(c)-RG4(1))/DR4)+1;
    b1(c)=fix(bw(c));
    bw(c)=bw(c)-b1(c);
end
b2=b1+1;
%
% for r direction
bp=zeros(2,2);%bp(b,c)
rdata=zeros(num1,1);
aw=zeros(2,2);
rp=zeros(2,2,2);
bp(1,1)=b1(1);
bp(2,1)=b2(1);
bp(1,2)=b1(2);
bp(2,2)=b2(2);
bp;
cp;
for c=1:2
    r0(c)=sqrt((Z0-obj.zax(cp(c))).^2+(R0-obj.Rax(cp(c))).^2);
    for b=1:2
        rdata=squeeze(obj.radius(bp(b,c),cp(c),:));
        %[r0(c) bp(b,c) cp(c) rdata(1) rdata(end)]
        if (r0(c) > rdata(1) && r0(c) < rdata(end))
            yc=bisec(r0(c),rdata);
            rp(b,c,1)=yc(1);
            rp(b,c,2)=yc(2);
            aw(b,c)=(r0(c)-rdata(rp(b,c,1)))/(rdata(rp(b,c,2))-rdata(rp(b,c,1)));
            poid2(b,c,1)=bp(b,c)+num2*(cp(c)-1)+num2*num3*(rp(b,c,1)-1);
            poid2(b,c,2)=bp(b,c)+num2*(cp(c)-1)+num2*num3*(rp(b,c,2)-1);
        else
            poid2=0;
            return
        end
    end
end
return
end