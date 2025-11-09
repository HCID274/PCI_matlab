function plot_trajectory_multi(sim,data_n)
oldpath=path;
path('../com',oldpath);
f_path='path.txt';
%
switch sim
    case {'FORTEC', 'fortec'}
        FVER=5;
        addpath('../sim_data/fortec','../sim_data/magLHD');
        dataC=hibpClass_fortec(f_path,data_n);
        t=1;%[no time slice]
    otherwise
        error('Unexpected simulation type.')
end
%
% color order
color=['b','r','g','m','k','y','c'];
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
% plasma
fread_plasma1(dataC,t);
plot_plasma1(dataC,(dataC.in_pos(2)+dataC.out_pos(2))/2);
figure(3)
clf
%
num0=4;
in_con=zeros(4,num0);%in_ang1,in_ang2,tracemax
%in_con(:,1)=[0.945*pi 0.02316*pi 5000];
%in_con(:,2)=[0.945*pi 0.02316*pi 10000];
%in_con(:,3)=[0.945*pi 0.02316*pi 100000];
in_con(:,1)=[0.945*pi 0.02316*pi 100000 0];
in_con(:,2)=[0.945*pi 0.02316*pi 100000 2];
in_con(:,3)=[0.945*pi 0.02316*pi 100000 3];
in_con(:,4)=[0.945*pi 0.02316*pi 100000 4];
%
for a=1:num0
str=sprintf('%strace_%08.4f_%08.4f_%d_t%d.mat',dataC.outdir,in_con(1,a),in_con(2,a),in_con(3,a),in_con(4,a))
%str='E:/syncSSD/naohiro/計測シミュレータ/HIBP/LHD/PFR2023/trace02/phi1_0/trace_scan_ene4.00_ang0.9550_t1.mat';
load(str);
%'param_out','bp_out','n1_out','inten_out','xout','yout','zout','vout','inten_trj' ...
%    ,'b_trj','ef_trj','poten_trj','ne_trj','te_trj'
%
ion_p=param_out(1);
tracemax=param_out(5);
ion_p=ion_p*tracemax;
n1=n1_out;
bp=bp_out;
if n1~=fix(ion_p)
    [n1 fix(ion_p)]
    return
end
dn=ion_p-n1;
tt=[1:n1-1 n1+dn n1+1:bp].';
%
figure(2)
    hold on
	plot3(xout(n1),yout(n1),zout(n1),'ro');
	plot3(xout(1:bp),yout(1:bp),zout(1:bp), color(a), 'linewidth',1);
	plot3(xout(bp),yout(bp),zout(bp),'k*');
	hold off
    drawnow
%
figure(3)
subplot(3,1,1)
hold on
plot([1:bp]/tracemax,inten_trj(1:bp), color(a),'linewidth',1.5);
ylabel('beam');
hold off
subplot(3,1,2)
hold on
%plot(tt,te_trj(1:bp),'k','linewidth',1.5);
%ylabel('T_e');
plot(tt/tracemax,vout(1:bp), color(a),'linewidth',1.5);
ylabel('v');
hold off
subplot(3,1,3)
hold on
plot(tt/tracemax,poten_trj(1:bp), color(a),'linewidth',1.5);
ylabel('\phi');
hold off
%{
pause
d_tt=tt(2:end)-tt(1:end-1);
subplot(5,1,1)
plot(tt(1:end-1),(inten_trj(2:bp)-inten_trj(1:bp-1))./d_tt,'k','linewidth',1.5);
ylabel('\delta beam');
subplot(5,1,2)
plot(tt(1:end-1),(b_trj(2:bp,:)-b_trj(1:bp-1,:))./d_tt,'linewidth',1.5);
ylabel('\delta B_R,B_Z,B_T');
subplot(5,1,3)
%plot(tt(1:end-1),(poten_trj(2:bp)-poten_trj(1:bp-1))./d_tt,'k','linewidth',1.5);
%ylabel('\delta \phi');
plot(tt(1:end-1),(ef_trj(2:bp,:)-ef_trj(1:bp-1,:))./d_tt,'linewidth',1.5);
ylabel('\delta E_R,E_Z,E_T');
subplot(5,1,4)
plot(tt(1:end-1),(ne_trj(2:bp)-ne_trj(1:bp-1))./d_tt,'k','linewidth',1.5);
ylabel('\delta n_e');
subplot(5,1,5)
%plot(tt(1:end-1),(te_trj(2:bp)-te_trj(1:bp-1))./d_tt,'k','linewidth',1.5);
%ylabel('\delta T_e');
plot(tt(1:end-1),(vout(2:bp)-vout(1:bp-1))./d_tt,'k','linewidth',1.5);
ylabel('\delta v');
%}
%
end
path(oldpath)
end

