% plot a time evolution of poloidal profile with EQ
function probe_poloidal(obj,r0,ax0,data1)
% radius(0:1), axial/2pi(0:1)
%global poid podr cos_pha sin_pha;% position data
%
LMAX=obj.LMAX;
IRMAX=obj.IRMAX;
R=obj.R;
LKY=obj.LKY;
LKZ=obj.LKZ;
%
%tic;
if (r0 < 0.0) || (r0 > 1.0) || (ax0 < 0.0) || (ax0 > 1.0)
    xa=IRMAX+2;
else
    ra=r0*R(IRMAX+1);
    [xa;xb]=bisec(ra,R);
end
poid0=xa;
da0=(R(xb)-ra)/(R(xb)-R(xa));
%
num=64;
r=r0*ones(num,1);
ax=ax0*ones(num,1);
theta=2.0/num*([0:num-1].')-1.0;
poid=poid0*ones(num,1);
pha=(pi*theta*LKY-2*pi*ax*LKZ);
podr=da0*ones(num,LMAX+1);
cos_pha=cos(pha);
sin_pha=sin(pha);
%



pout=probe_1(str,num,var);
fprintf(fid1,'%f',t);
fprintf(fid1,'\t%f',pout);
fprintf(fid1,'\t%f',pout(1));
fprintf(fid1,'\n');
tt=tt+1;
end
end
%
else
str=sprintf('%s%08d.dat',dir,t*100)
pout=probe_1(str,num,var);
fprintf(fid1,'%f',t);
fprintf(fid1,'\t%f',pout);
fprintf(fid1,'\t%f',pout(1));
fprintf(fid1,'\n');
end
fclose(fid1);
%toc
end