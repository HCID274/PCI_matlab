%     Coded by Tsuguhiro WATANABE (NIFS)
%     Ref. The Japan Society for Industrial and Applied Mathematics
%          vol.1, No.1, 1991, p.p101-114 (in Japanese)
%     for MATLAB by Kasuya (2023.5.7)
%
function SPLIN3(XSD,XLD, YSD,YLD, ZSD,ZLD, NCDX,NCDY,NCDZ)
global C411 C412 C413 C414 C415 C416 C417 ...
           C418 C41A C41C C41E C421 ...
           C422 C423 C424 C425 C426 C427 ...
           C431 C432 C433 C434 C435 C436 C437 ...
           C441 C442 C443 C444 C445 C446 C447 ...
           H3X  XS3 XL3 H3Y YS3 YL3 H3Z ZS3 ZL3 ...
           NC3X NC3Y NC3Z
%
      JINI=0;
%
      XS3=XSD;
      XL3=XLD;
      NC3X=NCDX;
      H3X=(XLD-XSD)/(NCDX-7);
      YS3=YSD;
      YL3=YLD;
      NC3Y=NCDY;
      H3Y=(YLD-YSD)/(NCDY-7);
      ZS3=ZSD;
      ZL3=ZLD;
      NC3Z=NCDZ;
      H3Z=(ZLD-ZSD)/(NCDZ-7);
%
      if(JINI >= 1)
          return;
      end 
      JINI=1;
%
      C411=-     5.0D0/ 2048.0D0;
      C412=   9611.0D0/737280.0D0;
      C413=    259.0D0/23040.0D0;
      C414=-  6629.0D0/ 46080.0D0;
      C415=-     7.0D0/ 1152.0D0;
      C416=    819.0D0/  1024.0D0;
      C417=      1.0D0/ 1440.0D0;
      C418=-  1067.0D0/   360.0D0;
      C41A=   3941.0D0/  576.0D0;
      C41C=-  1603.0D0/   180.0D0;
      C41E=    901.0D0/  180.0D0;
      C421=     49.0D0/ 2048.0D0;
      C422=- 70733.0D0/737280.0D0;
      C423=-   499.0D0 /4608.0D0;
      C424=  47363.0D0/ 46080.0D0;
      C425=     59.0D0/ 1152.0D0;
      C426=- 86123.0D0/ 15360.0D0;
      C427=-     1.0D0/  288.0D0;
%*     C428=   7469.0D0/   360.0D0;
%*     C42A=- 27587.0D0/  576.0D0;
%*     C42C=  11221.0D0/   180.0D0;
%*     C42E=-  6307.0D0/  180.0D0;
      C431=-   245.0D0/ 2048.0D0;
      C432=  27759.0D0/ 81920.0D0;
      C433=   1299.0D0/ 2560.0D0;
      C434=- 50563.0D0/ 15360.0D0;
      C435=-    15.0D0/  128.0D0;
      C436=  51725.0D0/  3072.0D0;
      C437=      1.0D0/  160.0D0;
%*     C438=-  7469.0D0/   120.0D0;
%*     C43A=  27587.0D0/  192.0D0;
%*     C43C=- 11221.0D0/    60.0D0;
%*     C43E=   6307.0D0/   60.0D0;
      C441=   1225.0D0/ 2048.0D0;
      C442=-240077.0D0/147456.0D0;
      C443=-  1891.0D0/ 4608.0D0;
      C444=  52931.0D0/  9216.0D0;
      C445=     83.0D0/ 1152.0D0;
      C446=- 86251.0D0/  3072.0D0;
      C447=-     1.0D0/  288.0D0;
%*     C448=   7469.0D0/    72.0D0;
%*     C44A=-137935.0D0/  576.0D0;
%*     C44C=  11221.0D0/    36.0D0;
%*     C44E=-  6307.0D0/   36.0D0;
%
return
end
