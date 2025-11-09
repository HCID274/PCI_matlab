%------------------------------------------------------------------
%     SPL3DF2                                   #
%     with derivative
%     Coded by Tsuguhiro WATANABE (NIFS)
%        Ref. The Japan Society for Industrial and Applied Mathematics
%          vol.1, No.1, 1991, p.p101-114 (in Japanese)
%     for MATLAB by Kasuya (2023.5.7)
%------------------------------------------------------------------
function [W0,WX,WY,WZ]=SPL3DF2(NF, FA, XD, YD, ZD)
%      REAL*8   CY(8), CZ(8), W0(NF), FA(NF, NC3X,NC3Y,NC3Z)
%      REAL*8   WX(NF), WY(NF), WZ(NF)
global C411 C412 C413 C414 C415 C416 C417 ...
           C418 C41A C41C C41E C421 ...
           C422 C423 C424 C425 C426 C427 ...
           C431 C432 C433 C434 C435 C436 C437 ...
           C441 C442 C443 C444 C445 C446 C447 ...
           H3X  XS3 XL3 H3Y YS3 YL3 H3Z ZS3 ZL3 ...
           NC3X NC3Y NC3Z
%
      CY=zeros(8,1);
      CZ=zeros(8,1);
      M2=8;
      X=XD;
      if(X < XS3)
          X=XS3;
      end 
      if(X > XL3)
          X=XL3;
      end
      UX=(X-XS3)/H3X;
      Y=YD;
      if(Y < YS3)
          Y=YS3;
      end 
      if(Y > YL3)
          Y=YL3;
      end
      UY=(Y-YS3)/H3Y;
      Z=ZD;
      if(Z < ZS3)
          Z=ZS3;
      end 
      if(Z > ZL3)
          Z=ZL3;
      end
      UZ=(Z-ZS3)/H3Z;
%
      IX =fix(UX);               
      IY =fix(UY);               
      IZ =fix(UZ);
%$$$      UX =UX-REAL(IX)-0.5D0
%$$$      UY =UY-REAL(IY)-0.5D0
%$$$      UZ =UZ-REAL(IZ)-0.5D0
      UX =UX-(IX)-0.5D0;
      UY =UY-(IY)-0.5D0;
      UZ =UZ-(IZ)-0.5D0;
      IX =IX+3;             
      IY =IY+3;            
      IZ =IZ+3;
      USX=UX*UX;            
      USY=UY*UY;            
      USZ=UZ*UZ;
      for LL=1:NF        
         W0(LL)=0.0D0;
         WX(LL)=0.0D0;
         WY(LL)=0.0D0;
         WZ(LL)=0.0D0;
      end
%   ############       CASE FOR M == 4       #######################
      X400=((( C41E*USX +C41C)*USX+C41A)*USX+C418)*USX;
      Y400=((( C41E*USY +C41C)*USY+C41A)*USY+C418)*USY;
      Z400=((( C41E*USZ +C41C)*USZ+C41A)*USZ+C418)*USZ;
      DX400=((( C41E*13D0*USX +C41C*11D0)*USX+C41A*9D0)*USX+C418*7D0)*USX;
      DY400=((( C41E*13D0*USY +C41C*11D0)*USY+C41A*9D0)*USY+C418*7D0)*USY;
      DZ400=((( C41E*13D0*USZ +C41C*11D0)*USZ+C41A*9D0)*USZ+C418*7D0)*USZ;
%
      X41M=((( X400     +C416)*USX+C414)*USX+C412)*UX;
      Y41M=((( Y400     +C416)*USY+C414)*USY+C412)*UY;
      Z41M=((( Z400     +C416)*USZ+C414)*USZ+C412)*UZ;
      DX41M=((DX400     +C416*5D0)*USX+C414*3D0)*USX+C412;
      DY41M=((DY400     +C416*5D0)*USY+C414*3D0)*USY+C412;
      DZ41M=((DZ400     +C416*5D0)*USZ+C414*3D0)*USZ+C412;
%
      X41P= (( C417*USX +C415)*USX+C413)*USX+C411;
      Y41P= (( C417*USY +C415)*USY+C413)*USY+C411;
      Z41P= (( C417*USZ +C415)*USZ+C413)*USZ+C411;
      DX41P= (( C417*6D0*USX +C415*4D0)*USX+C413*2D0)*UX;
      DY41P= (( C417*6D0*USY +C415*4D0)*USY+C413*2D0)*UY;
      DZ41P= (( C417*6D0*USZ +C415*4D0)*USZ+C413*2D0)*UZ;
%
      X42M=(((-X400* 7D0+C426)*USX+C424)*USX+C422)*UX;
      Y42M=(((-Y400* 7D0+C426)*USY+C424)*USY+C422)*UY;
      Z42M=(((-Z400* 7D0+C426)*USZ+C424)*USZ+C422)*UZ;
      DX42M=((-DX400* 7D0+C426*5D0)*USX+C424*3D0)*USX+C422;
      DY42M=((-DY400* 7D0+C426*5D0)*USY+C424*3D0)*USY+C422;
      DZ42M=((-DZ400* 7D0+C426*5D0)*USZ+C424*3D0)*USZ+C422;
%
      X42P= (( C427*USX +C425)*USX+C423)*USX+C421;
      Y42P= (( C427*USY +C425)*USY+C423)*USY+C421;
      Z42P= (( C427*USZ +C425)*USZ+C423)*USZ+C421;
%
      X43M=((( X400*21D0+C436)*USX+C434)*USX+C432)*UX;
      Y43M=((( Y400*21D0+C436)*USY+C434)*USY+C432)*UY;
      Z43M=((( Z400*21D0+C436)*USZ+C434)*USZ+C432)*UZ;
      DX43M=(( DX400*21D0+C436*5D0)*USX+C434*3D0)*USX+C432;
      DY43M=(( DY400*21D0+C436*5D0)*USY+C434*3D0)*USY+C432;
      DZ43M=(( DZ400*21D0+C436*5D0)*USZ+C434*3D0)*USZ+C432;
%
      X43P= (( C437*USX +C435)*USX+C433)*USX+C431;
      Y43P= (( C437*USY +C435)*USY+C433)*USY+C431;
      Z43P= (( C437*USZ +C435)*USZ+C433)*USZ+C431;
      DX43P= (( C437*6D0*USX +C435*4D0)*USX+C433*2D0)*UX;
      DY43P= (( C437*6D0*USY +C435*4D0)*USY+C433*2D0)*UY;
      DZ43P= (( C437*6D0*USZ +C435*4D0)*USZ+C433*2D0)*UZ;
%
      X44M=(((-X400*35D0+C446)*USX+C444)*USX+C442)*UX;
      Y44M=(((-Y400*35D0+C446)*USY+C444)*USY+C442)*UY;
      Z44M=(((-Z400*35D0+C446)*USZ+C444)*USZ+C442)*UZ;
      DX44M=((-DX400*35D0+C446*5D0)*USX+C444*3D0)*USX+C442;
      DY44M=((-DY400*35D0+C446*5D0)*USY+C444*3D0)*USY+C442;
      DZ44M=((-DZ400*35D0+C446*5D0)*USZ+C444*3D0)*USZ+C442;
%
      X44P= (( C447*USX +C445)*USX+C443)*USX+C441;
      Y44P= (( C447*USY +C445)*USY+C443)*USY+C441;
      Z44P= (( C447*USZ +C445)*USZ+C443)*USZ+C441;
      DX44P= (( C447*6D0*USX +C445*4D0)*USX+C443*2D0)*UX;
      DY44P= (( C447*6D0*USY +C445*4D0)*USY+C443*2D0)*UY;
      DZ44P= (( C447*6D0*USZ +C445*4D0)*USZ+C443*2D0)*UZ;
%
      CY(1)=Y41P+Y41M;
      CY(2)=Y42P+Y42M;
      CY(3)=Y43P+Y43M;
      CY(4)=Y44P+Y44M;
      CY(5)=Y44P-Y44M;
      CY(6)=Y43P-Y43M;
      CY(7)=Y42P-Y42M;
      CY(8)=Y41P-Y41M;
      CZ(1)=Z41P+Z41M;
      CZ(2)=Z42P+Z42M;
      CZ(3)=Z43P+Z43M;
      CZ(4)=Z44P+Z44M;
      CZ(5)=Z44P-Z44M;
      CZ(6)=Z43P-Z43M;
      CZ(7)=Z42P-Z42M;
      CZ(8)=Z41P-Z41M;

      DY(1)=DY41P+DY41M;
      DY(2)=DY42P+DY42M;
      DY(3)=DY43P+DY43M;
      DY(4)=DY44P+DY44M;
      DY(5)=DY44P-DY44M;
      DY(6)=DY43P-DY43M;
      DY(7)=DY42P-DY42M;
      DY(8)=DY41P-DY41M;
      DZ(1)=DZ41P+DZ41M;
      DZ(2)=DZ42P+DZ42M;
      DZ(3)=DZ43P+DZ43M;
      DZ(4)=DZ44P+DZ44M;
      DZ(5)=DZ44P-DZ44M;
      DZ(6)=DZ43P-DZ43M;
      DZ(7)=DZ42P-DZ42M;
      DZ(8)=DZ41P-DZ41M;
%
      for MZ=1:M2                             
         LZ=IZ+MZ-3;
         for MY=1:M2                         
            LY=IY+MY-3;
            CYZ=CY(MY)*CZ(MZ);
            DYZDY=DY(MY)*CZ(MZ);
            DYZDZ=CY(MY)*DZ(MZ);
            for LL=1:NF
               W0(LL)=((X41P+X41M)*FA(LL,IX-2,LY,LZ) ... 
                +(X42P+X42M)*FA(LL,IX-1,LY,LZ) ... 
                +(X43P+X43M)*FA(LL,IX  ,LY,LZ) ... 
                +(X44P+X44M)*FA(LL,IX+1,LY,LZ) ... 
                +(X44P-X44M)*FA(LL,IX+2,LY,LZ) ...
                +(X43P-X43M)*FA(LL,IX+3,LY,LZ) ...
                +(X42P-X42M)*FA(LL,IX+4,LY,LZ) ...
                +(X41P-X41M)*FA(LL,IX+5,LY,LZ))*CYZ+W0(LL);
               %
               WY(LL)=WW*CYZDY+WY(LL);
               WZ(LL)=WW*CYZDZ+WZ(LL);
               WX(LL)=((DX41P+DX41M)*FA(LL,IX-2,LY,LZ) ... 
                +(DX42P+DX42M)*FA(LL,IX-1,LY,LZ) ... 
                +(DX43P+DX43M)*FA(LL,IX  ,LY,LZ) ... 
                +(DX44P+DX44M)*FA(LL,IX+1,LY,LZ) ... 
                +(DX44P-DX44M)*FA(LL,IX+2,LY,LZ) ...
                +(DX43P-DX43M)*FA(LL,IX+3,LY,LZ) ...
                +(DX42P-DX42M)*FA(LL,IX+4,LY,LZ) ...
                +(DX41P-DX41M)*FA(LL,IX+5,LY,LZ))*CYZ+WX(LL);
            end
         end
      end
      %W0
      for LL=1:NF
          WX(LL)=WX(LL)/H3X;
          WY(LL)=WY(LL)/H3Y;
          WZ(LL)=WZ(LL)/H3Z;
      end
%
      return 
end
