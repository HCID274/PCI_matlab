function plot_trace_test2(sim,data_n)
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
data_n=3;
in_ang1=zeros(data_n,1);
in_ang2=in_ang1;
ion_p=in_ang1;
tracemax=in_ang1;
%
in_ang1(1)=2.9782;%vacuum
in_ang2(1)=0.06085;
ion_p(1)=1642.2709;
tracemax(1)=5000;
in_ang1(2)=2.9782;%vacuum+VMEC
in_ang2(2)=0.06139;
ion_p(2)=1639.1203;
tracemax(2)=5000;
in_ang1(3)=2.9782;%vacuum w/o E
in_ang2(3)=0.06175;
ion_p(3)=1638.6752;
tracemax(3)=5000;
%in_ang1(4)=2.9782;%vacuum+VMEC
%in_ang2(4)=0.06077;
%ion_p(4)=1651.5070;
%tracemax(4)=5000;
%in_ang1(5)=2.9782;%vacuum
%in_ang2(5)=0.06133;
%ion_p(5)=1648.1339;
%tracemax(5)=5000;
%
% plasma
fread_plasma1(dataC,t);
plot_plasma1(dataC,(dataC.in_pos(2)+dataC.out_pos(2))/2);
%
for a=1:data_n
str=sprintf('%strace_%08.4f_%08.4f_%d_t%d.mat',dataC.outdir,in_ang1(a),in_ang2(a),tracemax(a),t)
load(str);
%'bp_out','n1_out','inten_out','xout','yout','zout','vout','inten_trj' ...
%    ,'b_trj','ef_trj','poten_trj','ne_trj','te_trj'
%
bp=bp_out;
%
n1=fix(ion_p(a));
dn=ion_p(a)-n1;
tt=[1:n1-1 n1+dn n1+1:bp].';
%
figure(2)
    hold on
	plotline1=plot3(xout(n1),yout(n1),zout(n1),'o', 'linewidth',1.5);
	plotline2=plot3(xout(1:bp),yout(1:bp),zout(1:bp),'-', 'linewidth',1.5);
	plotline2.SeriesIndex=plotline1.SeriesIndex;
    plotline3=plot3(xout(bp),yout(bp),zout(bp),'*');
	plotline3.SeriesIndex=plotline1.SeriesIndex;
    hold off
    drawnow
%{
figure(3)
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
%}
end
path(oldpath)
end

