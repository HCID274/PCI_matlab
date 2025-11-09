% magnetic field direction along LS
function [xx,yy,ang, ang2]=LSmag2(obj,R0,Z0,PHI0,Lx,Ly,Lz)
    % xls1(num1,3):pos along LS (x,y,z), xl(2,3): projection vectors (x,y,z)

    [BR,BZ,BT,~]=probeEQ_mag(obj,R0,Z0,PHI0);
    BB(1)=BR*cos(PHI0)-BT*sin(PHI0);
    BB(2)=BR*sin(PHI0)+BT*cos(PHI0);
    BB(3)=BZ;
    BB;

    xx = dot(BB, Lx);  % Projection of the beam x-component
    yy = dot(BB, Ly);  % Projection of the beam y-component
    ang =atan2(yy,xx)/pi*180;

    if ang < 0
        ang2 = ang + 180;
    else
        ang2 = ang;
    end 
    if ang2 < 90 
        ang2 = ang2 + 90;
    else
        ang2 = ang2 - 90;
    end
end
    