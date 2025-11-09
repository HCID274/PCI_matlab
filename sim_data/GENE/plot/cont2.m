% plot contour
function data3 = cont2(sim,data_n,ax,t,extr)
% simulation type: 1(NLD),2(DISA),3(R4F),4(R5F)
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

% snap shot
%Generate time data (00****.dat) from TORUSIons_act.dat
GENEdata = sprintf('%sTORUSIons_act_%.0f.dat', dataC.indir, t*100)
generate_timedata(dataC,GENEdata,t);

% parameters
fread_param2(dataC);

if(FVER ~= dataC.FVER)
         error('Simulation type mismatch (PARAM).')
end  
fread_EQ1(dataC);
clf;
%
str=sprintf('%s%08d.dat',dataC.indir,round(t*100));

data3 = cont_data2_s(dataC,str,ax,t);
%{
figure_path1 = sprintf('%s%s%s%d%s%.0f%s',dataC.indir,'result_crossSection/figure/','CircularCross-Section_',data_n,'_',t*100,'.fig')
saveas(figure(1),figure_path1);
figure_path2 = sprintf('%s%s%s%d%s%.0f%s',dataC.indir,'result_crossSection/figure/','PoloidalCross-Section_',data_n,'_',t*100,'.fig')
saveas(figure(2),figure_path2);
%
figure_path7 = sprintf('%s%s%s%d%s%.0f%s',dataC.indir,'result_crossSection/figure/','3D-CircularStructure_',data_n,'_',t*100,'.fig')
saveas(figure(7),figure_path7);
figure_path8 = sprintf('%s%s%s%d%s%.0f%s',dataC.indir,'result_crossSection/figure/','3D-PoloidalStructure_',data_n,'_',t*100,'.fig')
saveas(figure(8),figure_path8);
%}


% time series
%{
f_list = dir(fullfile(dataC.indir, 'TORUSIons_act_*.dat'));
time_n = numel(f_list)

t_value = cell(numel(f_list), 1);
    
for i = 1:numel(f_list)
    fileName = f_list(i).name;
    t_string = fileName(length('TORUSIons_act_')+1:end-length('.dat'));
    t_value{i} = t_string;
end

t_numbers = str2double(t_value);
[~, sortOrder] = sort(t_numbers);
sorted_t_value = t_value(sortOrder);
pause

data = zeros(dataC.LYM2/(dataC.KZMt+1)+1, dataC.nx0+1+dataC.inside+dataC.outside, time_n);

%video_path = sprintf('%s%s%.0f%s',dataC.indir,'figure/crossSection/crossSection_',data_n,'_TimeSeries.avi')
video_path = sprintf('%s%s%s%d%s',dataC.indir,'result_crossSection/movie/','PoloidalCross-Section_',data_n,'.avi')
v = VideoWriter(video_path);
v.FrameRate = 10;
open(v);

for i = 1:time_n
    t = str2double(sorted_t_value{i});
    t = t/100

    GENEdata = sprintf('%sTORUSIons_act_%.0f.dat', dataC.indir, t*100)
    generate_timedata(dataC,GENEdata,t);
    
    str=sprintf('%s%08d.dat',dataC.indir,round(t*100));
    data(:,:,i) = cont_data2_s(dataC,str,ax,t);

    figure(42)
    contourf(dataC.GRC.',dataC.GZC.',data(:,:,i),30,'LineStyle','none');
    xlabel('R');
    ylabel('Z');
    title(sprintf('t = %.2f', t));
    %clim([-30,30])
    axis equal
    colorbar;

    frame = getframe(gcf);
    writeVideo(v, frame);
    figure_path = sprintf('%s%s%s%d%s%.0f%s',dataC.indir,'result_crossSection/figure/','PoloidalCross-Section_',data_n,'_',t*100,'.fig')
    %saveas(figure(42),figure_path);
end
close(v);

%datpath = sprintf('%s%s%.0f%s',dataC.indir,'figure/crossSection/crossSection_',data_n,'_TimeSeries.mat')
datpath = sprintf('%s%s%s%d%s',dataC.indir,'result_crossSection/mat/','PoloidalCross-Section_',data_n,'.mat')
save(datpath, 'data');
%}
end
