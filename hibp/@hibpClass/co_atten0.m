% coefficient for beam attenuation
% typical values
function c=co_atten(obj,x0,Te)
if obj.mass == 23 %Na
    sigma1=4.3;
    sigma2=2.0;
elseif obj.mass == 197 %Au
    sigma1=17.0;
    sigma2=9.0;
elseif obj.mass == 133 %Cs
    sigma1=12.0;
    sigma2=5.7;
elseif obj.mass == 85 %Rb
    sigma1=9.4;
    sigma2=4.8;
else
    sigma1=10.0;
    sigma2=5.0;
end
c=zeros(2,1);

[B(1), B(3), B(2)]=probeEQ_mag(obj,x0(1),x0(3),x0(2));
if Te == 0.0
    ct=0.0;
else
    ct=50.0*B(2)^2/Te;
end
c(1)=ct*sigma1;
c(2)=ct*sigma2;
end
