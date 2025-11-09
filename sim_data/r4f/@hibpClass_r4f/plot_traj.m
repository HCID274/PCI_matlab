function plot_traj(obj,x,y,z,bp,n1)
alpha=atan2(y(1),x(1));
plot3(obj.GRC(end,:)*cos(alpha),obj.GRC(end,:)*sin(alpha),obj.GZC(end,:))
hold on
alpha=atan2(y(bp),x(bp));
plot3(obj.GRC(end,:)*cos(alpha),obj.GRC(end,:)*sin(alpha),obj.GZC(end,:))
plot3(x(n1),y(n1),z(n1),'ro');
plot3(x(1:bp),y(1:bp),z(1:bp))
view(-22,32)
axis equal
hold off
end