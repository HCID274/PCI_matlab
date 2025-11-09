function plot_3d(obj)
%
figure(2)
view(0,90)
num1=obj.num1;
num2=obj.num2;
num3=obj.num3;
figure(2)
alpha=0;
plot3(obj.R(:,1,end)*cos(alpha),obj.R(:,1,end)*sin(alpha),obj.z(:,1,end),'k','linewidth',0.1);
axis equal
ax = gca;
ax.YDir = 'reverse';
view(0,90)
hold on
for i=1:100
for m=1:1
alpha=i*2*pi/5/(num3)+(m-1)*(2*pi/5);
plot3(obj.R(:,i+1,num2)*cos(alpha),obj.R(:,i+1,num2)*sin(alpha),obj.z(:,i+1,num2),'k','linewidth',0.1);
end
end
axis equal
hold off
drawnow
hold on
plot3(obj.out_pos(1)*cos(obj.out_pos(2)),obj.out_pos(1)*sin(obj.out_pos(2)),obj.out_pos(3),'r+');
hold off
end

