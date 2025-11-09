function [ion_p, in_ang2] = conv(dataC, in_ang1, in_ang2, tracemax, vini, ion_p) 
%Computation convergence
%
x0=zeros(6,1);
%x0(1)=(EQ.RG1(1)+EQ.RG1(2))/2;
x0(1)=dataC.in_pos(1);
x0(4)=-vini*sin(in_ang1)*cos(in_ang2);
x0(2)=dataC.in_pos(2);
x0(5)=vini*sin(in_ang2)/x0(1);
x0(3)=dataC.in_pos(3);
x0(6)=-vini*cos(in_ang1)*cos(in_ang2);
%
for aa = 1:20
    x0(4)=-vini*sin(in_ang1)*cos(in_ang2);
    x0(5)=vini*sin(in_ang2)/x0(1);
    x0(6)=-vini*cos(in_ang1)*cos(in_ang2);
    [x,y,z,v,bp,inten]=hibp_inj(dataC,x0,tracemax,ion_p);
    n1=fix(ion_p);
    %plot_trajectory(x,y,z,n1,bp);%plot progressing calculations
    %{
    if 1 ==1
        figure(1)
        hold on
        plot(sqrt(x(n1).^2+y(n1).^2),z(n1),'ro');
        plot(sqrt(x(1:bp).^2+y(1:bp).^2),z(1:bp));
        %axis equal
        hold off
        figure(2)
        hold on
        plot3(x(n1),y(n1),z(n1),'ro');
        plot3(x(1:bp),y(1:bp),z(1:bp));
        hold off
        drawnow
    end
    %}
    [aa,sqrt(x(n1)^2+y(n1)^2),atan2(y(n1),x(n1)),z(n1), ...
    sqrt(x(bp)^2+y(bp)^2),atan2(y(bp),x(bp)),z(bp)]
    [in_ang1/pi,in_ang2/pi]
    [ion_p,tracemax]
    %
    %sqrt(x(bp)^2+y(bp)^2)
    Zcal=z(bp)-dataC.out_pos(3);
    Fcal=atan2(y(bp),x(bp))-dataC.out_pos(2);
    %0.5*(v(bp)^2-v(1)^2)*dataC.mass/9.58*1.0e5
    %
    [x,y,z,v,bp,inten]=hibp_inj(dataC,x0,tracemax,ion_p+dataC.dti);
    n1=fix(ion_p+dataC.dti);
    %plot_trajectory(x,y,z,n1,bp);%plot progressing calculations
    %sqrt(x(bp)^2+y(bp)^2)
    Zcal_t=(z(bp)-dataC.out_pos(3)-Zcal)/dataC.dti;
    Fcal_t=(atan2(y(bp),x(bp))-dataC.out_pos(2)-Fcal)/dataC.dti;
    %
    x0(4)=-vini*sin(in_ang1)*cos(in_ang2+dataC.dang);
    x0(5)=vini*sin(in_ang2+dataC.dang)/x0(1);
    x0(6)=-vini*cos(in_ang1)*cos(in_ang2+dataC.dang);
    [x,y,z,v,bp,inten]=hibp_inj(dataC,x0,tracemax,ion_p);
    n1=fix(ion_p);
    %plot_trajectory(x,y,z,n1,bp);%plot progressing calculations
    %sqrt(x(bp)^2+y(bp)^2)
    Zcal_a=(z(bp)-dataC.out_pos(3)-Zcal)/dataC.dang;
    Fcal_a=(atan2(y(bp),x(bp))-dataC.out_pos(2)-Fcal)/dataC.dang;
    %
    %[Fcal_t -Zcal_t; -Fcal_a Zcal_a]
    ZF=[Fcal_t -Zcal_t; -Fcal_a Zcal_a]/(Zcal_a*Fcal_t-Zcal_t*Fcal_a);
    da=ZF*[Zcal; Fcal];
    %
    in_ang2=in_ang2-da(1);
    ion_p=ion_p-da(2);
    if ion_p < 1.0
        ion_p=1;
    elseif ion_p > tracemax-1
        ion_p=tracemax-1;
    end
    %[in_ang1 in_ang2 ion_p aa]
    %[x(n1),y(n1),z(n1)];
    if ((abs(da(1)) < dataC.da1_min) && (abs(da(2)) < dataC.da2_min))
        break
    end
    %0.5*(v(bp)^2-v(1)^2)*dataC.mass/9.58*1.0e5;
end
%
%0.5*(v(bp)^2-v(1)^2)*dataC.mass/9.58*1.0e5;
end
