% plot spectrum
function plot_spectrum_d_HT(obj,p2)
% obj,data, field#
%
coef=1.0;
%
%dr=zeros(obj.IRMAX+1,1);
%dr(1:end-1)=obj.R(2:end)-obj.R(1:end-1);
%p2_d=zeros(obj.IRMAX+1,obj.LYM2,obj.LZM2);
%p2_d(2:end-1,:,:)=(-p2(1:end-2,:,:,fn)+p2(3:end,:,:,fn))./repmat(-obj.R(1:end-2)+obj.R(3:end),1,obj.LYM2,obj.LZM2);
%p2_m=squeeze(p2(:,:,:,fn)).*repmat(reshape(obj.LKY,1,obj.LYM2,obj.LZM2),obj.IRMAX+1,1,1);
%ss=p2_d(:,:,:).*conj(p2_d(:,:,:)).*repmat(obj.R.*dr,1,obj.LYM2,obj.LZM2) ...
%    +p2_m(:,:,:).*conj(p2_m(:,:,:)).*repmat(dr,1,obj.LYM2,obj.LZM2);
%ss=coef*squeeze(sum(ss,1));
%ss2=zeros(obj.LYM2,obj.LZM2);
%ss2(obj.KYM:end,:)=ss(1:obj.KYM+1,:);
%ss2(1:obj.KYM-1,:)=ss(obj.KYM+2:end,:);
%ss2(1:obj.KYM-1,1)=ss([obj.KYM:-1:2],1);
%[x,y]=meshgrid([-obj.KYM+1:obj.KYM],[0:obj.KZM]);
%contourf(x,y,log10(ss2.'),30,'LineStyle','none');
%shading flat;
%title('spectrum');
%xlabel('m');
%ylabel('n');
%axis tight
%colorbar
%


%total-flux, nvr
M1=zeros(1,obj.LYM2);
M1(1:129)=0:128;
M1(130:256)=-127:-1;
M2=ones(obj.IRMAX+1,obj.LYM2,obj.LZM2);
M=M1.*M2;
dataf1=zeros(obj.IRMAX+1,obj.LYM2,obj.LZM2);
dataf1(2:end,:,:)=2.0*(p2(2:end,:,:,4))*i.*M(2:end,:,:)...
        ./repmat(obj.R(2:end),1,obj.LYM2,obj.LZM2).*conj(p2(2:end,:,:,1));
%FLX1=coef*squeeze(sum(dataf1,2));
%FLX2=coef*squeeze(sum(FLX1,2));
%subplot(221);
%plot(obj.R,FLX2);
%axis tight
%title('total, [PHI,NE]');
%xlabel('r');

   
%total-flux, vB
dataf2=zeros(obj.IRMAX+1,obj.LYM2,obj.LZM2);
dataf2(2:end,:,:)=2.0*(p2(2:end,:,:,2))*i.*M(2:end,:,:)...
        ./repmat(obj.R(2:end),1,obj.LYM2,obj.LZM2).*conj(p2(2:end,:,:,3));
%FLX3=coef*squeeze(sum(dataf2,2));
%FLX4=coef*squeeze(sum(FLX3,2));
%subplot(222);
%plot(obj.R,FLX4);
%axis tight
%title('total, [PSI,VPL]');
%xlabel('r');

%total-flux, JB
dr=zeros(obj.IRMAX+1,1);
dr(1:end-1)=obj.R(2:end)-obj.R(1:end-1);
dr2=power(dr,2);
R2=power(obj.R,2);
J=zeros(obj.IRMAX+1,obj.LYM2,obj.LZM2);
J(2:end-1,:,:)=(p2(1:end-2,:,:,2)-2*p2(2:end-1,:,:,2)+p2(3:end,:,:,2))./repmat(dr2(2:end-1),1,obj.LYM2,obj.LZM2)...
        +0.5*(-p2(1:end-2,:,:,2)+p2(3:end,:,:,2))./repmat(obj.R(2:end-1),1,obj.LYM2,obj.LZM2)./repmat(dr(2:end-1),1,obj.LYM2,obj.LZM2)...
        -M(2:end-1,:,:).*M(2:end-1,:,:).*p2(2:end-1,:,:,2)./repmat(R2(2:end-1),1,obj.LYM2,obj.LZM2);
dataf3=zeros(obj.IRMAX+1,obj.LYM2,obj.LZM2);
dataf3(2:end-1,:,:)=-2.0*J(2:end-1,:,:)...
        *i.*M(2:end-1,:,:)./repmat(obj.R(2:end-1),1,obj.LYM2,obj.LZM2).*conj(p2(2:end-1,:,:,2));
%FLX5=coef*squeeze(sum(dataf3,2));
%FLX6=coef*squeeze(sum(FLX5,2));
%subplot(223);
%plot(obj.R,FLX6);
%axis tight
%title('total, [PSI,CUR]');
%xlabel('r');

%NEQ
subplot(211);
a=4;
plot(obj.R,squeeze(real(p2(:,1,1,a)))+obj.DENSQ);
title('NEQ');
xlabel('r');
axis tight
%
%TOTAL-FLUX, nvr+vBr+JBr
subplot(212);
dataf1_co=(1+obj.BETAI+obj.BETAE+2/3*obj.BETAE)*dataf1;
dataf2_co=(obj.BETAI+obj.BETAE)*dataf2;
dataf3_co=(obj.BETAI+obj.BETAE)*obj.DELTA*(1-2/3*obj.VIS_TEME*obj.BETAE)*dataf3;
dataf=dataf1_co+dataf2_co+dataf3_co;
FLX7=coef*squeeze(sum(dataf,2));
FLX8=coef*squeeze(sum(FLX7,2));
plot(obj.R,real(FLX8));
axis tight
title('TOTAL-FLUX');
xlabel('r');




end
