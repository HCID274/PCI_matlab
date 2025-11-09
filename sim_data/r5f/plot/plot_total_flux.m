% plot mode structure
function plot_total_flux(obj,p0,p2)% file name, mode m,n
%obj.LKY(LMAX+1),obj.LKZ(LMAX+1),p2(IRMAX+1,LYM2,LZM2,f_n)
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

%CUR
subplot(338);
J=zeros(obj.IRMAX+1,1);
J(2:end-1)=p2(1:end-2,2)./repmat(dr2(1:end-2),1)-0.5*p2(1:end-2,2)./(obj.R(2:end-1).*dr(1:end-2))...
      -2*p2(2:end-1,2)./repmat(dr2(2:end-1),1)-p2(2:end-1,2)*m*m./R2(2:end-1)...
      +p2(3:end,2)./repmat(dr2(3:end),1)+0.5*p2(3:end,2)./(obj.R(2:end-1).*dr(3:end));

plot(obj.R,real(J),'r',obj.R,imag(J),'b');
title('CUR');
xlabel('r');
axis tight
legend('Real','Imag','Location','Best')


%nVr
datac2=zeros(1,obj.IRMAX+1);
datac2(2:end)=2.0*(p2(2:end,4))...
    *(i*m)./obj.R(2:end).*conj(p2(2:end,1));

%vB
datac3=zeros(1,obj.IRMAX+1);
datac3(2:end)=2.0*(p2(2:end,2))...
    *(i*m)./obj.R(2:end).*conj(p2(2:end,3));

%JB
datac4_d=zeros(1,obj.IRMAX+1);
datac4_d(2:end-1)=-2.0*J(2:end-1)*(i*m)./obj.R(2:end-1).*conj(p2(2:end-1,2));


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
datac2(1)=0;
subplot(221);
%subplot(333);
plot(obj.R,real(datac2));
axis tight
title('flux, [PHI,NE]');
xlabel('r');

%vBr
datac3(1)=0;
subplot(222);
%subplot(336);
plot(obj.R,real(datac3));
axis tight
title('flux, [PSI,VPL]');
xlabel('r');

%JBr
datac4_d(1)=0;
subplot(223);
%subplot(339);
plot(obj.R,real(datac4_d));
axis tight
title('flux, [PSI,CUR]');
xlabel('r');

%total
beta=obj.BETAI+obj.BETAE
delta=obj.DELTA
datac_t(1)=0;
subplot(224);
%subplot(339);
plot(obj.R,real((1+beta)*datac2+beta*datac3+beta*delta*datac4_d));
axis tight
title('flux, Total');
xlabel('r');

%
end
