% plot mode structure
function plot_mode_flux(obj,p0,p2,m,n)% file name, mode m,n
%
%Q
subplot(322);
%plot(obj.R,real(p0(:,a)),obj.R,obj.DENSQ,'--');
Q_g=zeros(1,obj.IRMAX+1);
Q_g(2:end-1)=(-obj.Q(1:end-2)+obj.Q(3:end))./(-obj.R(1:end-2)+obj.R(3:end));
Q_g(2:end-1)=(obj.R(2:end-1)./obj.Q(2:end-1)).'.*Q_g(2:end-1);
plot(obj.R,obj.Q,obj.R,Q_g,'--');
title('Q');
xlabel('r');
axis tight
%
%NEQ
subplot(324);
a=4;
plot(obj.R,real(p0(:,a)),obj.R,obj.DENSQ,'--');
NEQ_g=zeros(1,obj.IRMAX+1);
NEQ_g(2:end-1)=(-p0(1:end-2,a)+p0(3:end,a))./(-obj.R(1:end-2)+obj.R(3:end));
NEQ_g(2:end-1)=p0(2:end-1,a).'./NEQ_g(2:end-1);
rmin=fix(size(obj.R)/3);
hold on
yyaxis right;
plot(obj.R(rmin:end),NEQ_g(rmin:end));
ylim([-2,2])
yyaxis left;
hold off
title('NEQ');
xlabel('r');
axis tight
%
%nVr
datac2=zeros(1,obj.IRMAX+1);
datac2(2:end)=-2.0*(p2(2:end,4))...
    *(i*m)./obj.R(2:end).*conj(p2(2:end,1));
datac2(1)=0;
subplot(326);
plot(obj.R,real(datac2));
axis tight
title('flux');
xlabel('r');
%axis([0,1,0,5]);
%
end
