% read EQ coordinate (adjust the point numbers in r and theta)
% regular theta in the cylindrical real coordinate
function fread_EQcod3(obj, f_EQcod)
%
file=sprintf('%s%s', obj.indir, f_EQcod)
fid=fopen(file,'r','ieee-le');
RET=fread(fid,1,'int');%return key
NSGMAX=fread(fid,1,'int');
NTGMAX=fread(fid,1,'int');
IRMAX=obj.IRMAX;
ITGMAX=128;
GRC2=fread(fid,NSGMAX*NTGMAX,'double');
GZC2=fread(fid,NSGMAX*NTGMAX,'double');
GFC2=fread(fid,NSGMAX*NTGMAX,'double');
GQPS=fread(fid,NSGMAX,'double');
fclose(fid);
%
GRCt=zeros(NSGMAX,NTGMAX+1);
GZCt=zeros(NSGMAX,NTGMAX+1);
GFCt=zeros(NSGMAX,NTGMAX+1);
GRCt2=zeros(IRMAX+1,NTGMAX+1);
GZCt2=zeros(IRMAX+1,NTGMAX+1);
GFCt2=zeros(IRMAX+1,NTGMAX+1);
GRC=zeros(IRMAX+1,ITGMAX+1);
GZC=zeros(IRMAX+1,ITGMAX+1);
GFC=zeros(IRMAX+1,ITGMAX+1);
%
GRCt(:,1:NTGMAX)=reshape(GRC2,NSGMAX,NTGMAX);
GZCt(:,1:NTGMAX)=reshape(GZC2,NSGMAX,NTGMAX);
GFCt(:,1:NTGMAX)=reshape(GFC2,NSGMAX,NTGMAX);
NSG=NSGMAX-1;
s2=0;
for a=1:NSG
    s1=s2+1;
    s2=fix(IRMAX/NSG*a)+1;
    w1=(a-([s1:s2]-1)*NSG/IRMAX).'*ones(1,NTGMAX+1);
    w2=-(a-1-([s1:s2]-1)*NSG/IRMAX).'*ones(1,NTGMAX+1);
    GRCt2(s1:s2,:)=ones(s2-s1+1,1)*GRCt(a,:).*w1+ones(s2-s1+1,1)*GRCt(a+1,:).*w2;
    GZCt2(s1:s2,:)=ones(s2-s1+1,1)*GZCt(a,:).*w1+ones(s2-s1+1,1)*GZCt(a+1,:).*w2;
    GFCt2(s1:s2,:)=ones(s2-s1+1,1)*GFCt(a,:).*w1+ones(s2-s1+1,1)*GFCt(a+1,:).*w2;
end
GRCt2(1,:)=GRCt(1,:);
GRCt2(end,:)=GRCt(end,:);
GZCt2(1,:)=GZCt(1,:);
GZCt2(end,:)=GZCt(end,:);
GFCt2(1,:)=GFCt(1,:);
GFCt2(end,:)=GFCt(end,:);
GRCt2(:,NTGMAX+1)=GRCt2(:,1);
GZCt2(:,NTGMAX+1)=GZCt2(:,1);
GFCt2(:,NTGMAX+1)=GFCt2(:,1);
%
GTC_f_t=zeros(IRMAX+1,NTGMAX+1);
GTC_c_t=zeros(IRMAX+1,NTGMAX+1);
GTC_f=zeros(IRMAX+1,ITGMAX+1);
GTC_c=zeros(IRMAX+1,ITGMAX+1);
PA=[GRCt2(1,1),GZCt2(1,1)];%magnetic axis
GTC_f_t=ones(IRMAX+1,1)*([0:NTGMAX]/NTGMAX*2.0*pi);%theta(0:2pi) flux coord
GTC_c_t=mod(atan2(GZCt2-PA(2),GRCt2-PA(1)),2*pi);%theta(0:2pi) cylindrical coord 
GTC_c_t(:,end)=2.0*pi;
GTC_c=ones(IRMAX+1,1)*([0:ITGMAX]/ITGMAX*2.0*pi);
dtheta1=1.0/NTGMAX*2.0*pi;
dtheta2=1.0/ITGMAX*2.0*pi;
NSG=NTGMAX;
for b=1:IRMAX+1
    s2=0;
    for a=1:NSG
        s1=s2+1;
        s2=fix(GTC_c_t(b,a+1)/dtheta2)+1;
        w1=(GTC_c_t(b,a+1)-([s1:s2]-1)*dtheta2)/(GTC_c_t(b,a+1)-GTC_c_t(b,a));
        w2=-(GTC_c_t(b,a)-([s1:s2]-1)*dtheta2)/(GTC_c_t(b,a+1)-GTC_c_t(b,a));
        GRC(b,s1:s2)=GRCt2(b,a)*ones(1,s2-s1+1).*w1+GRCt2(b,a+1)*ones(1,s2-s1+1).*w2;
        GZC(b,s1:s2)=GZCt2(b,a)*ones(1,s2-s1+1).*w1+GZCt2(b,a+1)*ones(1,s2-s1+1).*w2;
        GFC(b,s1:s2)=GFCt2(b,a)*ones(1,s2-s1+1).*w1+GFCt2(b,a+1)*ones(1,s2-s1+1).*w2;
        GTC_f(b,s1:s2)=GTC_f_t(b,a)*ones(1,s2-s1+1).*w1+GTC_f_t(b,a+1)*ones(1,s2-s1+1).*w2;
    end
end
GRC(:,1)=GRCt2(:,1);
GRC(:,end)=GRCt2(:,end);
GZC(:,1)=GZCt2(:,1);
GZC(:,end)=GZCt2(:,end);
GFC(:,1)=GFCt2(:,1);
GFC(:,end)=GFCt2(:,end);
%clf;
%plot(GRC.',GZC.','o-')
%axis equal
%
obj.NSGMAX=NSGMAX;
obj.NTGMAX=ITGMAX;
%obj.ITGMAX=ITGMAX;
obj.GRC=GRC;
obj.GZC=GZC;
obj.GFC=GFC;
obj.Rmax=max(max(GRC));
obj.Rmin=min(min(GRC));
obj.Zmax=max(max(GZC));
obj.Zmin=min(min(GZC));
PA=[GRC(1,1),GZC(1,1)];
obj.PA=PA;%plasma axis
obj.GAC=sqrt((GRC-PA(1)).^2+(GZC-PA(2)).^2);%minor r
obj.GTC_f=GTC_f;%theta(0:2pi) flux coord
obj.GTC_c=GTC_c;%theta(0:2pi) cylindrical coord 
obj.GTC_c(:,end)=2.0*pi;
%{
    [r,theta]=size(obj.GRC);
    [Xq,Yq]=meshgrid(1:1/3:theta,1:1:r);
    [r,theta]=size(Xq);
    obj.NTGMAX=theta-1;
    GRC=interp2(obj.GRC,Xq,Yq);
    GZC=interp2(obj.GZC,Xq,Yq);
    GFC=interp2(obj.GFC,Xq,Yq);
    GTC_f=interp2(obj.GTC_f,Xq,Yq);
    GTC_c=interp2(obj.GTC_c,Xq,Yq);
    obj.GRC=GRC;
    obj.GZC=GZC;
    obj.GFC=GFC;
    obj.Rmax=max(max(GRC));
    obj.Rmin=min(min(GRC));
    obj.Zmax=max(max(GZC));
    obj.Zmin=min(min(GZC));
    PA=[GRC(1,1),GZC(1,1)];
    obj.PA=PA;%plasma axis
    obj.GAC=sqrt((GRC-PA(1)).^2+(GZC-PA(2)).^2);%minor r
    obj.GTC_f=GTC_f;%theta(0:2pi) flux coord
    obj.GTC_c=GTC_c;%theta(0:2pi) cylindrical coord 
    obj.GTC_c(:,end)=2.0*pi;
%}
end