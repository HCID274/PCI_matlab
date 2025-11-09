% test calc (ERROR: not extended data region)
test_read;
XSD=dataC.R_mag(1);
XLD=dataC.R_mag(end);
YSD=dataC.Phi_mag(end);
YLD=dataC.Phi_mag(1);
ZSD=dataC.Z_mag(1);
ZLD=dataC.Z_mag(end);
NCDX=dataC.NRGM;
NCDY=dataC.NPHIGM;
NCDZ=dataC.NZGM;
SPLIN3(XSD,XLD, YSD,YLD, ZSD,ZLD, NCDX,NCDY,NCDZ);
%
NF=3;
FA=zeros(NF,NCDX,NCDY,NCDZ);
FA(1,:,:,:)=dataC.BF1;
FA(2,:,:,:)=dataC.BF2;
FA(3,:,:,:)=dataC.BF3;
W0=zeros(NF,1);
%
XD=4.15;
YD=0.2*pi*1.01;
ZD=-5.0;
[XD,YD,ZD]
W0=SPL3DF(NF, FA, XD, YD, ZD)
