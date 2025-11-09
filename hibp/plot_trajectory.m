function plot_trajectory(x,y,z,n1,bp)
    figure(1)
    hold on
    plot(sqrt(x(n1).^2+y(n1).^2),z(n1),'ro');
    plot(sqrt(x(1:bp).^2+y(1:bp).^2),z(1:bp));
    %axis equal
    hold off
%
    figure(2)
    hold on
    plot3(x(n1),y(n1),z(n1),'ro');
    plot3(x(1:bp),y(1:bp),z(1:bp));
    hold off
    drawnow
end