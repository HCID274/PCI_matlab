function data_convert(obj)
%data_PHI=obj.PLASMA_PHI_total;
%data_NE=obj.PLASMA_NE_total;
%data_TE=obj.PLASMA_TE_total;
%data_BF1=obj.BF(:,:,:,1);
%data_BF2=obj.BF(:,:,:,2);
%data_BF3=obj.BF(:,:,:,3);
%
d=10;
obj.num1_p=obj.num1+d;
num1_p=obj.num1_p;
%
[num2,num3,num1]=size(obj.PLASMA_PHI_total);
obj.PLASMA_PHI_total_p=zeros(num2,num3,num1_p);
obj.radius_p=zeros(num2,num3,num1_p);
obj.PLASMA_PHI_total_p(:,:,1:num1)=obj.PLASMA_PHI_total;
%obj.PLASMA_PHI_total_p(:,:,num1)=obj.PLASMA_PHI_total(:,:,num1-1);
obj.radius_p(:,:,1:num1)=obj.radius;
for a=1:d
   obj.radius_p(:,:,num1+a)=obj.radius(:,:,num1)+a*(obj.radius(:,:,num1)-obj.radius(:,:,num1-1));
end
%
end