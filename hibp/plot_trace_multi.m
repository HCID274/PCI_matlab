function plot_trace_multi(sim,data_n,t,num_p)
oldpath=path;
path('../com',oldpath);
f_path='path.txt';
%
switch sim
    case {'NLD', 'nld'}
        FVER=1;
        oldpath=addpath('../sim_data/nld','../sim_data/nld/hibp');
        dataC=nldClass(f_path,data_n);
    case {'DISA', 'disa'}
        FVER=2;
        dataC=disaClass(f_path,data_n);
    case {'R4F', 'r4f'}
        FVER=3;
        oldpath=addpath('../sim_data/r4f');
        dataC=r4fClass(f_path,data_n);
    case {'R5F', 'r5f'}
        FVER=3.5;
        oldpath=addpath('../sim_data/r5f','../sim_data/task_eq');
        dataC=hibpClass_r5f(f_path,data_n);
    case {'MIPS', 'mips'}
        FVER=4;
        oldpath=addpath('../sim_data/mips','../sim_data/mips/hibp');
        dataC=hibpClass_mips(f_path,data_n);
    case {'FORTEC', 'fortec'}
        FVER=5;
        oldpath=addpath('../sim_data/fortec');
        dataC=hibpClass_fortec(f_path,data_n);
        t=1;%[no time slice]
    otherwise
        error('Unexpected simulation type.')
end
%
% set beam probe condition
f_condition='condition.txt';
fread_condition(dataC,f_condition);
%
% parameters
fread_param2(dataC);
if(FVER ~= dataC.FVER)
    error('Simulation type mismatch.')
end
%
% equilibrium
fread_EQ1(dataC);
%
PHInorm=1.0e-6;
fread_plasma1(dataC,t);
ax=0.0;
plot_plasma1(dataC,ax);
%
for a=1:num_p
str=sprintf('in_ang(%d) = ',a);
in_ang1=input(str);
%
str=sprintf('%strace_%08.4f_ts.mat',dataC.outdir,in_ang1)
load(str);
%'timep_out','bp_out','n1_out','inten_out','xout','yout','zout','vout'
%
if a==1
  [num tmp]=size(bp_out);
  rho=zeros(num,num_p);
  poten=zeros(num,num_p);
  inten=zeros(num,num_p);
end
%
s=1;
R0=sqrt(xout(n1_out(s),s)^2+yout(n1_out(s),s)^2);
PHI0=atan2(yout(n1_out(s),s),xout(n1_out(s),s));
Z0=zout(n1_out(s),s);
hold on
plot(sqrt(xout(n1_out(s),s).^2+yout(n1_out(s),s).^2),zout(n1_out(s),s),'ro','Linewidth',2);
plot(sqrt(xout(1:bp_out(s),s).^2+yout(1:bp_out(s),s).^2),zout(1:bp_out(s),s),'k','Linewidth',1)
hold off
rho(s,a)=probeEQ_rho(dataC,R0,Z0,PHI0);
poten(s,a)=dataC.in_ene-(vout(bp_out(s),s)/13.8)^2*dataC.mass;
%poten(s,a)=0.5*(vout(bp_out(s),s)^2-vout(1,s)^2)*dataC.mass/9.58*1.0e5;
inten(s,a)=inten_out(s);
%
for s=2:num
R0=sqrt(xout(n1_out(s),s)^2+yout(n1_out(s),s)^2);
PHI0=atan2(yout(n1_out(s),s),xout(n1_out(s),s));
Z0=zout(n1_out(s),s);
rho(s,a)=probeEQ_rho(dataC,R0,Z0,PHI0);
poten(s,a)=-(dataC.in_ene-(vout(bp_out(s),s)/13.8)^2*dataC.mass)*1.0e6;
%poten(s,a)=0.5*(vout(bp_out(s),s)^2-vout(1,s)^2)*dataC.mass/9.58*1.0e5;
inten(s,a)=inten_out(s);
end
end
pause
lab=cell(num_p,1);
for a=1:num_p
    str=sprintf('r = %.2f',rho(1,a));
    lab{a}=str;
end
%
plot(timep_out,poten,'Linewidth',2)
set(gca,'FontSize',14);
set(gca,'FontName','Times');
xlabel('time \it{t} / \it{t}_A','Fontsize',20);
ylabel('potential [eV]','Fontsize',20);
legend(lab)
pause
plot(timep_out,inten,'Linewidth',2)
set(gca,'FontSize',14);
set(gca,'FontName','Times');
xlabel('time \it{t} / \it{t}_A','Fontsize',20);
ylabel('density [A.U.]','Fontsize',20);
legend(lab)
%
path(oldpath)
end
