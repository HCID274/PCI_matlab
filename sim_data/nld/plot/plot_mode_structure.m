% plot mode structure
function plot_mode_structure(obj,p2,m,n)% file name, mode m,n
%
%PHI
subplot(221);
a=1;
plot(obj.R,real(p2(:,a)),'r',obj.R,imag(p2(:,a)),'b');
title('PHI');
xlabel('r');
axis tight
legend('Real','Imag','Location','Best')
%
%VPL
subplot(222);
a=2;
plot(obj.R,real(p2(:,a)),'r',obj.R,imag(p2(:,a)),'b');
title('VPL');
xlabel('r');
axis tight
%
%NE
subplot(223);
a=3;
plot(obj.R,real(p2(:,a)),'r',obj.R,imag(p2(:,a)),'b');
title('NE');
xlabel('r');
axis tight
%
end
