%     Coded by Tsuguhiro WATANABE (NIFS)
%     Ref. The Japan Society for Industrial and Applied Mathematics
%          vol.1, No.1, 1991, p.p101-114 (in Japanese)
%     for MATLAB by Kasuya (2023.5.7)
%     using structure by Kasuya (2023.9.6)
%
function obj=SPLIN3_2(XSD,XLD, YSD,YLD, ZSD,ZLD, NCDX,NCDY,NCDZ)
%obj field: C411 C412 C413 C414 C415 C416 C417 ...
%           C418 C41A C41C C41E C421 ...
%           C422 C423 C424 C425 C426 C427 ...
%           C431 C432 C433 C434 C435 C436 C437 ...
%           C441 C442 C443 C444 C445 C446 C447 ...
%           H3X  XS3 XL3 H3Y YS3 YL3 H3Z ZS3 ZL3 ...
%           NC3X NC3Y NC3Z
%
      JINI=0;
%
      obj.XS3=XSD;
      obj.XL3=XLD;
      obj.NC3X=NCDX;
      obj.H3X=(XLD-XSD)/(NCDX-7);
      obj.YS3=YSD;
      obj.YL3=YLD;
      obj.NC3Y=NCDY;
      obj.H3Y=(YLD-YSD)/(NCDY-7);
      obj.ZS3=ZSD;
      obj.ZL3=ZLD;
      obj.NC3Z=NCDZ;
      obj.H3Z=(ZLD-ZSD)/(NCDZ-7);
%
      if(JINI >= 1)
          return;
      end 
      JINI=1;
%
      obj.C411=-     5.0D0/ 2048.0D0;
      obj.C412=   9611.0D0/737280.0D0;
      obj.C413=    259.0D0/23040.0D0;
      obj.C414=-  6629.0D0/ 46080.0D0;
      obj.C415=-     7.0D0/ 1152.0D0;
      obj.C416=    819.0D0/  1024.0D0;
      obj.C417=      1.0D0/ 1440.0D0;
      obj.C418=-  1067.0D0/   360.0D0;
      obj.C41A=   3941.0D0/  576.0D0;
      obj.C41C=-  1603.0D0/   180.0D0;
      obj.C41E=    901.0D0/  180.0D0;
      obj.C421=     49.0D0/ 2048.0D0;
      obj.C422=- 70733.0D0/737280.0D0;
      obj.C423=-   499.0D0 /4608.0D0;
      obj.C424=  47363.0D0/ 46080.0D0;
      obj.C425=     59.0D0/ 1152.0D0;
      obj.C426=- 86123.0D0/ 15360.0D0;
      obj.C427=-     1.0D0/  288.0D0;
%*     obj.C428=   7469.0D0/   360.0D0;
%*     obj.C42A=- 27587.0D0/  576.0D0;
%*     obj.C42C=  11221.0D0/   180.0D0;
%*     obj.C42E=-  6307.0D0/  180.0D0;
      obj.C431=-   245.0D0/ 2048.0D0;
      obj.C432=  27759.0D0/ 81920.0D0;
      obj.C433=   1299.0D0/ 2560.0D0;
      obj.C434=- 50563.0D0/ 15360.0D0;
      obj.C435=-    15.0D0/  128.0D0;
      obj.C436=  51725.0D0/  3072.0D0;
      obj.C437=      1.0D0/  160.0D0;
%*     obj.C438=-  7469.0D0/   120.0D0;
%*     obj.C43A=  27587.0D0/  192.0D0;
%*     obj.C43C=- 11221.0D0/    60.0D0;
%*     obj.C43E=   6307.0D0/   60.0D0;
      obj.C441=   1225.0D0/ 2048.0D0;
      obj.C442=-240077.0D0/147456.0D0;
      obj.C443=-  1891.0D0/ 4608.0D0;
      obj.C444=  52931.0D0/  9216.0D0;
      obj.C445=     83.0D0/ 1152.0D0;
      obj.C446=- 86251.0D0/  3072.0D0;
      obj.C447=-     1.0D0/  288.0D0;
%*     obj.C448=   7469.0D0/    72.0D0;
%*     obj.C44A=-137935.0D0/  576.0D0;
%*     obj.C44C=  11221.0D0/    36.0D0;
%*     obj.C44E=-  6307.0D0/   36.0D0;
%
return
end
