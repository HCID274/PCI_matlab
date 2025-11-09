function plot_trace_tt1(sim,data_n,in_ang1)
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
str=sprintf('%strace_%08.4f_ts.mat',dataC.outdir,in_ang1)
load(str);
%'timep_out','bp_out','n1_out','inten_out','xout','yout','zout','vout'
t=timep_out(1)
%
%PRM.IRMAX=128;
%
%t=128;
%mass=85;%Rb
%PRM.Te=200.0;%normalized by Te
%PLASMA.TEtmp=200.0;
PHInorm=1.0e-6;
%PHInorm=3.5e4;%epsilon * v_A * B_T * a for reduced MHD
%str=sprintf('%s%08d.dat',dir,t*100)
%fid=fopen(str,'r',endian);
%RET=fread(fid,1,'int');
%data1=fread(fid,[2,(PRM.IRMAX+1)*(PRM.LMAX+1)],'double');%PHI
%data1=reshape(data1,2,PRM.IRMAX+1,PRM.LMAX+1);
%for L=1:PRM.LMAX+1
%    if (PRM.LKY(L)==0 && PRM.LKZ(L)==0)
% %        data1(:,:,L)=0.0;
%        data1(:,:,L)=0.5*data1(:,:,L);
%    end
%end
%data2=squeeze(data1(1,:,:)+i*data1(2,:,:))*PHInorm;
fread_plasma1(dataC,t);
ax=0.0;
plot_plasma1(dataC,ax);
%
[num tmp]=size(bp_out);
rho=zeros(num,1);
poten=zeros(num,1);
inten=zeros(num,1);
poten_local=zeros(num,1);
ne_local=zeros(num,1);
%
s=1;
R0=sqrt(xout(n1_out(s),s)^2+yout(n1_out(s),s)^2);
PHI0=atan2(yout(n1_out(s),s),xout(n1_out(s),s));
Z0=zout(n1_out(s),s);
hold on
plot(sqrt(xout(n1_out(s),s).^2+yout(n1_out(s),s).^2),zout(n1_out(s),s),'ro');
plot(sqrt(xout(1:bp_out(s),s).^2+yout(1:bp_out(s),s).^2),zout(1:bp_out(s),s))
hold off
rho(s)=probeEQ_rho(dataC,R0,Z0,PHI0);
poten(s)=dataC.in_ene-(vout(bp_out(s),s)/13.8)^2*dataC.mass;
%poten(s)=0.5*(vout(bp_out(s),s)^2-vout(1,s)^2)*dataC.mass/9.58*1.0e5;
inten(s)=inten_out(s);
fread_plasma1(dataC,timep_out(s));
poten_local(s)=PHInorm*probeEQ_local_s(dataC,R0,Z0,PHI0,dataC.PLASMA_PHI_total);
ne_local(s)=probeEQ_local_s(dataC,R0,Z0,PHI0,dataC.PLASMA_NE_total);
pause
%
for s=2:num
R0=sqrt(xout(n1_out(s),s)^2+yout(n1_out(s),s)^2);
PHI0=atan2(yout(n1_out(s),s),xout(n1_out(s),s));
Z0=zout(n1_out(s),s);
rho(s)=probeEQ_rho(dataC,R0,Z0,PHI0);
poten(s)=-(dataC.in_ene-(vout(bp_out(s),s)/13.8)^2*dataC.mass)*1.0e6;
%poten(s)=0.5*(vout(bp_out(s),s)^2-vout(1,s)^2)*dataC.mass/9.58*1.0e5;
inten(s)=inten_out(s);
%fread_plasma1(dataC,timep_out(s));
poten_local(s)=PHInorm*probeEQ_local_s(dataC,R0,Z0,PHI0,dataC.PLASMA_PHI_total);
ne_local(s)=probeEQ_local_s(dataC,R0,Z0,PHI0,dataC.PLASMA_NE_total);
end
plot(timep_out,poten,'ko','Linewidth',2)
set(gca,'FontSize',14);
set(gca,'FontName','Times');
xlabel('time \it{t} / \it{t}_A','Fontsize',20);
ylabel('potential [eV]','Fontsize',20);
pause
hold on
plot(timep_out,poten_local,'ro','Linewidth',2)
hold off
pause
plot(timep_out,inten_out,'ko','Linewidth',2)
set(gca,'FontSize',14);
set(gca,'FontName','Times');
xlabel('time \it{t} / \it{t}_A','Fontsize',20);
ylabel('density [A.U.]','Fontsize',20);
pause
hold on
ne_local=ne_local*inten(1)/ne_local(1);
plot(timep_out,ne_local,'ro','Linewidth',2)
hold off
%
path(oldpath)
end

