function data_convert1(obj)
[num2, num3, num1]=size(obj.R);
%
X = 1:1:num2;
Y = 1:1:num3;
Z = 1:1:num1;
Xq = 1:1/5:num2;
Yq = 1:1/1:num3;
Zq = 1:1/5:num1;
theta_si=interp1(X,obj.theta_si,Xq,'spline');
phi_si=interp1(Y,obj.phi_si,Yq,'spline');
Rax=interp1(Y,obj.Rax,Yq,'spline');
zax=interp1(Y,obj.zax,Yq,'spline');
obj.theta_si=theta_si;
obj.phi_si=phi_si;
obj.Rax=Rax;
obj.zax=zax;
%
[X,Y,Z]=meshgrid(1:1:num3,1:1:num2,1:1:num1);
[Xq,Yq,Zq]=meshgrid(1:1/1:num3,1:1/5:num2,1:1/5:num1);
R=interp3(X,Y,Z,obj.R,Xq,Yq,Zq,'spline');
phi=interp3(X,Y,Z,obj.phi,Xq,Yq,Zq,'spline');
z=interp3(X,Y,Z,obj.z,Xq,Yq,Zq,'spline');
radius=interp3(X,Y,Z,obj.radius,Xq,Yq,Zq,'spline');
Bx3=interp3(X,Y,Z,obj.Bx3,Xq,Yq,Zq,'spline');
By3=interp3(X,Y,Z,obj.By3,Xq,Yq,Zq,'spline');
Bz3=interp3(X,Y,Z,obj.Bz3,Xq,Yq,Zq,'spline');
rho=interp3(X,Y,Z,obj.rho,Xq,Yq,Zq,'spline');
obj.R=R;
obj.phi=phi;
obj.z=z;
obj.radius=radius;
obj.Bx3=Bx3;
obj.By3=By3;
obj.Bz3=Bz3;
obj.rho=rho;
[num2, num3, num1]=size(obj.R);
num3_2=(num3+1)/2;
data1=zeros(num2,num3_2,num1);
data2=zeros(num2,num3_2,num1);
obj.BF=zeros(num2,num3,num1,3);
obj.BF(:,:,:,2)=obj.Bz3;
obj.BF(:,:,1,2)=0.0;
%
for i=1:num3_2
data1(:,i,:)=obj.Bx3(:,i,:)*cos(obj.phi_si(i))+obj.By3(:,i,:)*sin(obj.phi_si(i));
data2(:,i,:)=-obj.Bx3(:,i,:)*sin(obj.phi_si(i))+obj.By3(:,i,:)*cos(obj.phi_si(i));
end
obj.BF(:,1:num3_2,:,1)=data1;
obj.BF(:,num3_2:end,:,1)=data1;
obj.BF(:,1:num3_2,:,3)=data2;
obj.BF(:,num3_2:end,:,3)=data2;
obj.BF=-obj.BF; %B inversion when HIBP measurement
%
obj.num1=num1;
obj.num2=num2;
obj.num3=num3;
%
%obj.BF(:,:,:,3)=3;
%
r=obj.rho;
%obj.EQ_poten=108.7+6180.8*r.^2-3951.6*r.^4+2209.2*r.^6-4547.1;%[V]
%obj.EQ_NE= 1.238 - 0.18816*r.^2 -0.36092*r.^4 + 4.1859*r.^6 - 4.2331*r.^8;%[1x10^19m^-3]
%obj.EQ_TE= 3.633 - 2.6128*r.^2 + 0.10186*r.^4 - 0.56081*r.^6;%[keV]
obj.EQ_poten=-4e3*(1-r.^2);%[V]
obj.EQ_NE= 1*(1-r.^2);%[1x10^19m^-3]
obj.EQ_TE=0.2*ones(num2,num3,num1);%[keV]
%
PLASMA_PHI=interp3(X,Y,Z,obj.PLASMA_PHI,Xq,Yq,Zq,'spline');
obj.PLASMA_PHI=PLASMA_PHI;
obj.PLASMA_PHI_total=obj.EQ_poten+obj.PLASMA_PHI;
PLASMA_NE=interp3(X,Y,Z,obj.PLASMA_NE,Xq,Yq,Zq,'spline');
obj.PLASMA_NE=PLASMA_NE;
obj.PLASMA_NE_total=(obj.EQ_NE+obj.PLASMA_NE)*1e19;
PLASMA_TE=interp3(X,Y,Z,obj.PLASMA_TE,Xq,Yq,Zq,'spline');
obj.PLASMA_TE=PLASMA_TE;
obj.PLASMA_TE_total=obj.EQ_TE+obj.PLASMA_TE;
%
end

