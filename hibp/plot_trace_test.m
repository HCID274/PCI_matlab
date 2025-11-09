function plot_trace_test(sim,data_n)
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
in_ang1=2.9782;%vacuum+VMEC
in_ang2=0.06085;
ion_p=1642.2709;
tracemax=5000;
in_ang1=2.9688;%vacuum+VMEC
in_ang2=0.0728;
%ion_p=1642.2709;
tracemax=100000;
%
str=sprintf('%strace_%08.4f_%08.4f_%d_t%d.mat',dataC.outdir,in_ang1,in_ang2,tracemax,t)
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
% plasma
fread_plasma1(dataC,t);
data_convert1(dataC);
plot_plasma1(dataC,(dataC.in_pos(2)+dataC.out_pos(2))/2);
%
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
	plot3(xout(1:bp),yout(1:bp),zout(1:bp),'k-', 'linewidth',1);
	plot3(xout(bp),yout(bp),zout(bp),'k*');
	hold off
    drawnow
%
figure(3)
clf
subplot(5,1,1)
plot([1:bp],inten_trj(1:bp),'k','linewidth',1.5);
ylabel('beam');
subplot(5,1,2)
plot(tt,b_trj(1:bp,:),'linewidth',1.5);
ylabel('B_R,B_Z,B_T');
subplot(5,1,3)
plot(tt,poten_trj(1:bp),'k','linewidth',1.5);
ylabel('\phi');
subplot(5,1,4)
plot(tt,ef_trj(1:bp,:),'linewidth',1.5);
ylabel('E_R,E_Z,E_T');
%plot(tt,ne_trj(1:bp),'k','linewidth',1.5);
%ylabel('n_e');
subplot(5,1,5)
%plot(tt,te_trj(1:bp),'k','linewidth',1.5);
%ylabel('T_e');
plot(tt,vout(1:bp),'k','linewidth',1.5);
ylabel('v');
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
%
%check for probeEQ_ef4
R0=sqrt(xout(n1)^2+yout(n1)^2);
PHI0=atan2(yout(n1),xout(n1));
Z0=zout(n1);
[ER,EZ,ET,local_poten]=probeEQ_ef4(dataC,R0,Z0,PHI0);
local_poten=local_poten*1.e-6;
out_ene=(vout(bp-1)/13.8)^2*dataC.mass;
{'ene',[dataC.in_ene-out_ene, -local_poten, dataC.in_ene-out_ene+local_poten]}
%
path(oldpath)
end

