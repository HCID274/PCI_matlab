% plot contour
function cont(sim,data_n,ax,t,extr)
% simulation type: 1(NLD),2(DISA),3(R4F),4(R5F),5(GENE)
% data#, axial position, time, mode extract(0:OFF, 1:ON)
%
oldpath=path;
path('../com',oldpath);
f_path='path.txt';
%
switch sim
    case {'GENE', 'gene'}
        FVER=5;
        dataC=GENEClass(f_path,data_n);
    otherwise
        error('Unexpected simulation type.')
end
%
%Generate time data (00****.dat) from TORUSIons_act.dat
GENEdata = sprintf('%sTORUSIons_act_%d.dat', dataC.indir, t*100)
generate_timedata(dataC,GENEdata,t);

% parameters
fread_param2(dataC);

if(FVER ~= dataC.FVER)
         error('Simulation type mismatch (PARAM).')
end  
clf;

str=sprintf('%s%08d.dat',dataC.indir,t*100);

cont_data_s(dataC,str,ax);
%
end
