function plot_trace_rho_movie(sim,data_n,t,in_ang1)
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
        oldpath=addpath('../sim_data/fortec','../sim_data/magLHD');
        dataC=hibpClass_fortec(f_path,data_n);
        t=1;%[no time slice]
    otherwise
        error('Unexpected simulation type.')
end
%
% set beam probe condition
f_condition='condition.txt';
fread_condition(dataC,f_condition);
dataC.ion_p=dataC.tracemax*dataC.trace_n;
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
str=sprintf('%strace_%08.4f_rho_%d_t%d.mat',dataC.outdir,in_ang1,dataC.tracemax,t)
load(str);
%'bp_out','n1_out','inten_out','xout','yout','zout','vout'
PHInorm=1.0e-6;
%
fread_plasma1(dataC,t);
%
[num tmp]=size(bp_out);
rho=zeros(num,1);
poten=zeros(num,1);
inten=zeros(num,1);
poten_local=zeros(num,1);
ne_local=zeros(num,1);
%
plot_3d(dataC);
%view([-12,45])
view([-100,45])
%
figure(2)
%set(gcf, 'Color', 'none');
%set(gca, 'Color', 'none');
%set(gcf, 'InvertHardCopy', 'off');
a=1;
hold on
plot3(xout(1:bp_out(a),a),yout(1:bp_out(a),a),zout(1:bp_out(a),a),'w-', 'linewidth',1.5);
hold off
f=1;
for a=1:num
cc=1;
while cc < n1_out(a)
    cc1=cc;
    cc=cc+50;
    if cc > n1_out(a)
        cc=n1_out(a);
    end
    hold on
    plot3(xout(cc1:cc,a),yout(cc1:cc,a),zout(cc1:cc,a),'c-', 'linewidth',1.5);
    hold off
    myMovie(f)=getframe(gcf);
    f=f+1;
end
%
hold on
plot3(xout(n1_out(a),a),yout(n1_out(a),a),zout(n1_out(a),a),'ro', 'linewidth',2);
hold off
%
while cc < bp_out(a)
    cc1=cc;
    cc=cc+50;
    if cc > bp_out(a)
        cc=bp_out(a);
    end
    hold on
    plot3(xout(cc1:cc,a),yout(cc1:cc,a),zout(cc1:cc,a),'b-', 'linewidth',1.5);
    hold off
    myMovie(f)=getframe(gcf);
f=f+1;
end
%
hold on
plot3(xout(bp_out(a),a),yout(bp_out(a),a),zout(bp_out(a),a),'k*');
hold off
end
%
str=sprintf('%shibp3d_movie.mp4',dataC.outdir)
v = VideoWriter(str, 'MPEG-4');
%str=sprintf('%shibp3d_movie.avi',dataC.outdir)
%v = VideoWriter(str);
v.FrameRate = 20;
open(v);
writeVideo(v, myMovie)
close(v);
%
path(oldpath)
end

