% magnetic field direction along LS
function pout=LSmag(obj,num1,xls1,xl)
    % xls1(num1,3):pos along LS (x,y,z), xl(2,3): projection vectors (x,y,z)
    %
    pout=zeros(num1,3);
    ang=zeros(num1,1);
    xx=zeros(num1,1);
    yy=zeros(num1,1);

    p1 = -xl;
    % Lx, Ly and Lz are beam vectors
    Lx = [-p1(2)/p1(1); 1; 0]/((-p1(2)/p1(1))^2+1)^(1/2)
    Ly = [p1(1)/p1(2); 1; -(p1(1)^2+p1(2)^2)/(p1(2)*p1(3))]/((p1(1)/p1(2))^2+1+(-(p1(1)^2+p1(2)^2)/(p1(2)*p1(3)))^2)^(1/2)
    Lz = p1/(p1(1)^2+p1(2)^2+p1(3)^2)^(1/2)

    %
    for a=1:num1
        R0=sqrt(xls1(a,1)*xls1(a,1)+xls1(a,2)*xls1(a,2));
        Z0=xls1(a,3);
        PHI0=atan2(xls1(a,2),xls1(a,1));
        [BR,BZ,BT,~]=probeEQ_mag(obj,R0,Z0,PHI0);
        BB(1)=BR*cos(PHI0)-BT*sin(PHI0);
        BB(2)=BR*sin(PHI0)+BT*cos(PHI0);
        BB(3)=BZ;

        xx(end-a+1) = dot(BB, Lx);  % Projection of the beam x-component
        yy(end-a+1) = dot(BB, Ly);  % Projection of the beam y-component
        ang(end-a+1) = atan2(yy(end-a+1),xx(end-a+1))/pi*180;
    end

    figure(201)
    plot(yy,'.')

    figure(202)
    plot(xx,'.')

    figure(203)
    plot(ang,'.')

end
    