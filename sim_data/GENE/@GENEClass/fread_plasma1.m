% read plasma variables from Fourier decomposition
function fread_plasma1(obj,t)
%
str=sprintf('%s%08d.dat',obj.indir,t*100)
data1=fread_data_s(5,obj,str);
data1(:,1,1,:)=0.5*data1(:,1,1,:);%(0,0)
%data1(:,1,1,:)=0.0*data1(:,1,1,:);%(0,0)
fid=fopen(str,'r',obj.endian);
%for L=1:obj.LMAX+1
%    if ((obj.LKY(L)==0 && obj.LKZ(L)==0)||(abs(obj.LKY(L)/obj.LKZ(L))==2))
%        data1(:,:,L)=0.0;
%    end
%end
v_A=2.18*1.0e6*0.2*sqrt(10);
obj.PLASMA_PHI1=data1(:,:,:,1)*(obj.EPSILON*obj.PA(1)*v_A);
%obj.PLASMA_PHI1=data1(:,:,:,1);
obj.PLASMA_PHI_total=obj.PLASMA_PHI1;
obj.PLASMA_NE1=data1(:,:,:,4);
obj.PLASMA_NE_total=obj.PLASMA_NE1;
obj.PLASMA_NE_total(:,1,1)=obj.PLASMA_NE_total(:,1,1)+obj.DENSQ(:);
obj.PLASMA_TE1=data1(:,:,:,5);
obj.PLASMA_TE_total=obj.PLASMA_TE1;
obj.PLASMA_TE_total(:,1,1)=obj.PLASMA_TE_total(:,1,1)+obj.TEMEQ(:);
end