% plot flux profile
function [data_flux,datac_t]=plot_flux_profile(obj,p0,p2)
%
%NEQ
subplot(324);
a=4;
plot(obj.R,real(p0(:,a))+obj.DENSQ);
title('NEQ');
xlabel('r');
axis tight


%

dr=zeros(obj.IRMAX+1,1);
dr(1:end-1)=obj.R(2:end)-obj.R(1:end-1);
dr2=power(dr,2);
R2=power(obj.R,2);
IRMAX=obj.IRMAX;
KYM=obj.LYM2;
LZM=obj.LZM2;
m=obj.LKY;
%m=reshape(obj.LKY,1,KYM,LZM);
%size(obj.LKY)
%size(m)
%size(p2(2:end-1,:,:,2))
%size(repmat((m.*m).',IRMAX-1,1,1))
%CUR
J=zeros(IRMAX+1,KYM,LZM);
J(2:end-1,:,:)=p2(1:end-2,:,:,2)./repmat(dr2(1:end-2),1,KYM,LZM)...
      -0.5*p2(1:end-2,:,:,2)./repmat(obj.R(2:end-1).*dr(1:end-2),1,KYM,LZM)...
      -2*p2(2:end-1,:,:,2)./repmat(dr2(2:end-1),1,KYM,LZM)...
      -p2(2:end-1,:,:,2).*reshape(repmat((m.*m).',IRMAX-1,1),IRMAX-1,KYM,LZM)./repmat(R2(2:end-1),1,KYM,LZM)...
      +p2(3:end,:,:,2)./repmat(dr2(3:end),1,KYM,LZM)...
      +0.5*p2(3:end,:,:,2)./repmat(obj.R(2:end-1).*dr(3:end),1,KYM,LZM);

%nVr
datac2=zeros(IRMAX+1,KYM,LZM);
datac2(2:end,:,:)=(p2(2:end,:,:,4))...
    .*reshape(repmat(i*m.',IRMAX,1),IRMAX,KYM,LZM)./repmat(obj.R(2:end),1,KYM,LZM).*conj(p2(2:end,:,:,1));
datac2(:,:,2:end)=2.0*datac2(:,:,2:end);

%vB
datac3=zeros(IRMAX+1,KYM,LZM);
datac3(2:end,:,:)=(p2(2:end,:,:,2))...
    .*reshape(repmat(i*m.',IRMAX,1),IRMAX,KYM,LZM)./repmat(obj.R(2:end),1,KYM,LZM).*conj(p2(2:end,:,:,3));
datac3(:,:,2:end)=2.0*datac3(:,:,2:end);

%JB
datac4_d=zeros(IRMAX+1,KYM,LZM);
datac4_d(2:end-1,:,:)=-J(2:end-1,:,:)...
    .*reshape(repmat(i*m.',IRMAX-1,1),IRMAX-1,KYM,LZM)./repmat(obj.R(2:end-1),1,KYM,LZM).*conj(p2(2:end-1,:,:,2));
datac4_d(:,:,2:end)=2.0*datac4_d(:,:,2:end);

%datac2(1)=0;
%datac3(1)=0;
%datac4_d(1)=0;
%subplot(326);
%plot(obj.R,real(datac2));
%plot(obj.R,real(datac3));
%plot(obj.R,real(datac4_d));
%axis tight
%title('flux');
%xlabel('r');
%axis([0,1,0,5]);
%


%plot 3-flux
%nvr
datac2(1,:,:)=0;
subplot(221);
%subplot(333);
datac2p=real(sum(sum(datac2,3),2));
plot(obj.R,datac2p);
axis tight
title('flux, [PHI,NE]');
xlabel('r');

%vBr
datac3(1,:,:)=0;
subplot(222);
%subplot(336);
datac3p=real(sum(sum(datac3,3),2));
plot(obj.R,datac3p);
axis tight
title('flux, [PSI,VPL]');
xlabel('r');

%JBr
datac4_d(1,:,:)=0;
subplot(223);
%subplot(339);
datac4_dp=real(sum(sum(datac4_d,3),2));
plot(obj.R,datac4_dp);
axis tight
title('flux, [PSI,CUR]');
xlabel('r');

%total
beta=obj.BETAI+obj.BETAE
delta=obj.DELTA
datac_t=(1+beta)*datac2+beta*datac3+beta*delta*datac4_d;
datac_tp=real(sum(sum(datac_t,3),2));
subplot(224);
plot(obj.R,datac_tp);
axis tight
title('flux, Total');
xlabel('r');

data_flux=zeros(IRMAX+1,4);
data_flux(:,1)=datac2p;
data_flux(:,2)=datac3p;
data_flux(:,3)=datac4_dp;
data_flux(:,4)=datac_tp;
%
end
