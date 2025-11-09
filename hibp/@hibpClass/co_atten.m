% coefficient for beam attenuation
% model in Nishiura, PFR 2007
function c=co_atten(obj,x0,Te)
% mass number, beam velocity [m/microsec], Te[eV]
% c:<sigma v> [m^3/microsec]
c=zeros(2,1);
mass=obj.mass;
if mass == 197 %Au
    IE12=20.5;%ionization energy 1->2 [eV]
    IE23=30.0;%2->3
    xi12=10;%number of electron in the subshell
    xi23=9;
    A1=4.64e6;%fited coef
    A2=3.49e6;
    A3=1.00e4;
    A4=1.06e-13;
    A5=2.07e-6;
    A6=-1.36;
    A7=5.26e4;
    A8=-2.50;
else
    return
end
%
if Te <= 0.0
    return
end
%
c1=zeros(2,1);
c2=zeros(2,1);
v1=sqrt(x0(4)^2+(x0(5)*x0(1))^2+x0(6)^2);
v1=v1*1e6;%[m/microsec]->[m/sec]
%
%Ionization by electron
%a=4.5e-18;
b=3.0e-12;
c1(1)=b*(xi12/(sqrt(Te)*IE12))*expint(IE12/Te);
c1(2)=b*(xi23/(sqrt(Te)*IE23))*expint(IE23/Te);
%
%Ionization by proton
Eb=0.5*mass*(v1^2)*1.04e-8;
c2(1)=1e-20*A1*((exp(-A2/Eb)*log(1+A3*Eb))/Eb+(A4*exp(-A5*Eb))/(Eb^A6+A7*Eb^A8));
c2(2)=0.467*c2(1);
c2=c2*v1;
%
c=c1+c2;
c=c*1e-6;
end
