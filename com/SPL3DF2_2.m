%------------------------------------------------------------------
%     SPL3DF2                                   #
%     with derivative
%     Coded by Tsuguhiro WATANABE (NIFS)
%        Ref. The Japan Society for Industrial and Applied Mathematics
%          vol.1, No.1, 1991, p.p101-114 (in Japanese)
%     for MATLAB by Kasuya (2023.5.7)
%     using structure by Kasuya (2023.9.6)
%------------------------------------------------------------------
function [W0,WX,WY,WZ]=SPL3DF2_2(obj, NF, FA, XD, YD, ZD)
%      REAL*8   CY(8), CZ(8), W0(NF), FA(NF, NC3X,NC3Y,NC3Z)
%      REAL*8   WX(NF), WY(NF), WZ(NF)
%obj fields: C411 C412 C413 C414 C415 C416 C417 ...
%           C418 C41A C41C C41E C421 ...
%           C422 C423 C424 C425 C426 C427 ...
%           C431 C432 C433 C434 C435 C436 C437 ...
%           C441 C442 C443 C444 C445 C446 C447 ...
%           H3X  XS3 XL3 H3Y YS3 YL3 H3Z ZS3 ZL3 ...
%           NC3X NC3Y NC3Z
%
      CY=zeros(8,1);
      CZ=zeros(8,1);
      M2=8;
      X=XD;
      if(X < obj.XS3)
          X=obj.XS3;
      end 
      if(X > obj.XL3)
          X=obj.XL3;
      end
      UX=(X-obj.XS3)/obj.H3X;
      Y=YD;
      if(Y < obj.YS3)
          Y=obj.YS3;
      end 
      if(Y > obj.YL3)
          Y=obj.YL3;
      end
      UY=(Y-obj.YS3)/obj.H3Y;
      Z=ZD;
      if(Z < obj.ZS3)
          Z=obj.ZS3;
      end 
      if(Z > obj.ZL3)
          Z=obj.ZL3;
      end
      UZ=(Z-obj.ZS3)/obj.H3Z;
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
      X400=((( obj.C41E*USX +obj.C41C)*USX+obj.C41A)*USX+obj.C418)*USX;
      Y400=((( obj.C41E*USY +obj.C41C)*USY+obj.C41A)*USY+obj.C418)*USY;
      Z400=((( obj.C41E*USZ +obj.C41C)*USZ+obj.C41A)*USZ+obj.C418)*USZ;
      DX400=((( obj.C41E*13D0*USX +obj.C41C*11D0)*USX+obj.C41A*9D0)*USX+obj.C418*7D0)*USX;
      DY400=((( obj.C41E*13D0*USY +obj.C41C*11D0)*USY+obj.C41A*9D0)*USY+obj.C418*7D0)*USY;
      DZ400=((( obj.C41E*13D0*USZ +obj.C41C*11D0)*USZ+obj.C41A*9D0)*USZ+obj.C418*7D0)*USZ;
%
      X41M=((( X400     +obj.C416)*USX+obj.C414)*USX+obj.C412)*UX;
      Y41M=((( Y400     +obj.C416)*USY+obj.C414)*USY+obj.C412)*UY;
      Z41M=((( Z400     +obj.C416)*USZ+obj.C414)*USZ+obj.C412)*UZ;
      DX41M=((DX400     +obj.C416*5D0)*USX+obj.C414*3D0)*USX+obj.C412;
      DY41M=((DY400     +obj.C416*5D0)*USY+obj.C414*3D0)*USY+obj.C412;
      DZ41M=((DZ400     +obj.C416*5D0)*USZ+obj.C414*3D0)*USZ+obj.C412;
%
      X41P= (( obj.C417*USX +obj.C415)*USX+obj.C413)*USX+obj.C411;
      Y41P= (( obj.C417*USY +obj.C415)*USY+obj.C413)*USY+obj.C411;
      Z41P= (( obj.C417*USZ +obj.C415)*USZ+obj.C413)*USZ+obj.C411;
      DX41P= (( obj.C417*6D0*USX +obj.C415*4D0)*USX+obj.C413*2D0)*UX;
      DY41P= (( obj.C417*6D0*USY +obj.C415*4D0)*USY+obj.C413*2D0)*UY;
      DZ41P= (( obj.C417*6D0*USZ +obj.C415*4D0)*USZ+obj.C413*2D0)*UZ;
%
      X42M=(((-X400* 7D0+obj.C426)*USX+obj.C424)*USX+obj.C422)*UX;
      Y42M=(((-Y400* 7D0+obj.C426)*USY+obj.C424)*USY+obj.C422)*UY;
      Z42M=(((-Z400* 7D0+obj.C426)*USZ+obj.C424)*USZ+obj.C422)*UZ;
      DX42M=((-DX400* 7D0+obj.C426*5D0)*USX+obj.C424*3D0)*USX+obj.C422;
      DY42M=((-DY400* 7D0+obj.C426*5D0)*USY+obj.C424*3D0)*USY+obj.C422;
      DZ42M=((-DZ400* 7D0+obj.C426*5D0)*USZ+obj.C424*3D0)*USZ+obj.C422;
%
      X42P= (( obj.C427*USX +obj.C425)*USX+obj.C423)*USX+obj.C421;
      Y42P= (( obj.C427*USY +obj.C425)*USY+obj.C423)*USY+obj.C421;
      Z42P= (( obj.C427*USZ +obj.C425)*USZ+obj.C423)*USZ+obj.C421;
%
      X43M=((( X400*21D0+obj.C436)*USX+obj.C434)*USX+obj.C432)*UX;
      Y43M=((( Y400*21D0+obj.C436)*USY+obj.C434)*USY+obj.C432)*UY;
      Z43M=((( Z400*21D0+obj.C436)*USZ+obj.C434)*USZ+obj.C432)*UZ;
      DX43M=(( DX400*21D0+obj.C436*5D0)*USX+obj.C434*3D0)*USX+obj.C432;
      DY43M=(( DY400*21D0+obj.C436*5D0)*USY+obj.C434*3D0)*USY+obj.C432;
      DZ43M=(( DZ400*21D0+obj.C436*5D0)*USZ+obj.C434*3D0)*USZ+obj.C432;
%
      X43P= (( obj.C437*USX +obj.C435)*USX+obj.C433)*USX+obj.C431;
      Y43P= (( obj.C437*USY +obj.C435)*USY+obj.C433)*USY+obj.C431;
      Z43P= (( obj.C437*USZ +obj.C435)*USZ+obj.C433)*USZ+obj.C431;
      DX43P= (( obj.C437*6D0*USX +obj.C435*4D0)*USX+obj.C433*2D0)*UX;
      DY43P= (( obj.C437*6D0*USY +obj.C435*4D0)*USY+obj.C433*2D0)*UY;
      DZ43P= (( obj.C437*6D0*USZ +obj.C435*4D0)*USZ+obj.C433*2D0)*UZ;
%
      X44M=(((-X400*35D0+obj.C446)*USX+obj.C444)*USX+obj.C442)*UX;
      Y44M=(((-Y400*35D0+obj.C446)*USY+obj.C444)*USY+obj.C442)*UY;
      Z44M=(((-Z400*35D0+obj.C446)*USZ+obj.C444)*USZ+obj.C442)*UZ;
      DX44M=((-DX400*35D0+obj.C446*5D0)*USX+obj.C444*3D0)*USX+obj.C442;
      DY44M=((-DY400*35D0+obj.C446*5D0)*USY+obj.C444*3D0)*USY+obj.C442;
      DZ44M=((-DZ400*35D0+obj.C446*5D0)*USZ+obj.C444*3D0)*USZ+obj.C442;
%
      X44P= (( obj.C447*USX +obj.C445)*USX+obj.C443)*USX+obj.C441;
      Y44P= (( obj.C447*USY +obj.C445)*USY+obj.C443)*USY+obj.C441;
      Z44P= (( obj.C447*USZ +obj.C445)*USZ+obj.C443)*USZ+obj.C441;
      DX44P= (( obj.C447*6D0*USX +obj.C445*4D0)*USX+obj.C443*2D0)*UX;
      DY44P= (( obj.C447*6D0*USY +obj.C445*4D0)*USY+obj.C443*2D0)*UY;
      DZ44P= (( obj.C447*6D0*USZ +obj.C445*4D0)*USZ+obj.C443*2D0)*UZ;
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
          WX(LL)=WX(LL)/obj.H3X;
          WY(LL)=WY(LL)/obj.H3Y;
          WZ(LL)=WZ(LL)/obj.H3Z;
      end
%
      return 
end
