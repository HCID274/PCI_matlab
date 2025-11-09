% plot mode structure
function plot_mode_structure(obj,p2,m,n)% file name, mode m,n
%
%PHI
subplot(321);
a=1;
plot(obj.R,real(p2(:,a)),'r',obj.R,imag(p2(:,a)),'b');
title('PHI');
xlabel('r');
axis tight
legend('Real','Imag','Location','Best')
%
%PSI
subplot(322);
a=2;
plot(obj.R,real(p2(:,a)),'r',obj.R,imag(p2(:,a)),'b');
title('PSI');
xlabel('r');
axis tight
legend('Real','Imag','Location','Best')
%
%VPL
subplot(324);
a=3;
plot(obj.R,real(p2(:,a)),'r',obj.R,imag(p2(:,a)),'b');
title('VPL');
xlabel('r');
axis tight
%
%NE
subplot(323);
a=4;
plot(obj.R,real(p2(:,a)),'r',obj.R,imag(p2(:,a)),'b');
title('NE');
xlabel('r');
axis tight
%
%TE
subplot(325);
a=5;
plot(obj.R,real(p2(:,a)),'r',obj.R,imag(p2(:,a)),'b');
title('TE');
xlabel('r');
axis tight
%
end
