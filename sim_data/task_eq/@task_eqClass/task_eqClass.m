classdef task_eqClass < pathClass
   properties
   %EQ cod
      NSGMAX;
      NTGMAX;
      GRC;
      GZC;
      GFC;
      Rmax;
      Rmin;
      Zmax;
      Zmin;
      PA;%plasma axis
      GAC;%minor r
      GTC_f;%theta(0:2pi) flux coord
      GTC_c;%theta(0:2pi) cylindrical coord
   %EQ mag
      NRGM;
      NZGM;
      NPHIGM;
      RG1;
      RG2;
      RG3;
      DR1;
      DR2;
      DR3;
      GBPR_2d;
      GBPZ_2d;
      GBTP_2d;
      GBPP_2d;
      GBPR_3d;
      GBPZ_3d;
      GBTP_3d;
      GBPP_3d;
   end
%
   methods
      fread_EQ1(obj);
      fread_EQcod3(obj,f_EQcod);
      fread_EQmag(obj,f_EQmag);
      [BR BZ BT PP poid_mag da_mag]=probeEQ_mag(obj,R0,Z0,PHI0);
      pout=LSmag(obj,num1,xls1,xl);
   end
end