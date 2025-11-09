% local value of data1
function p=probeEQ_local_s(obj,r0,th0,ax0,data)
% radius/a(0:1), theta/pi(-1:1), axial/L(0:1)
%
data1=reshape(data,obj.IRMAX+1,obj.LMAX+1);
%
LMAX=obj.LMAX;
IRMAX=obj.IRMAX;
R=obj.R;
LKY=obj.LKY;
LKZ=obj.LKZ;
%
%tic;
if (r0<0.0)||(r0>1.0) || (th0<-1.0)||(th0>1.0) || (ax0<0.0)||(ax0>1.0)
    p=0.0;
else
    ra=r0*R(IRMAX+1);
    xx=bisec(ra,R);
    xa=xx(1);
    xb=xx(2);
    poid=xa;
    podr=(R(xb)-ra)/(R(xb)-R(xa));
    pha=(pi*th0*LKY-2*pi*ax0*LKZ);
    cs_pha=cos(pha)+i*sin(pha);
%
    data1(:,1)=0.5*(data1(:,1));
%
    data2=data1(poid+1,:)*(1.0-podr)+data1(poid,:)*podr;
    p=2.0*real(data2*cs_pha);
end
return
%
end

