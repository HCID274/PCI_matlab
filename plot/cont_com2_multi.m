% plot contour
function cont_com2_multi(sim,ax,t,sum)
    % simulation type: 1(NLD),2(DISA),3(R4F),4(R5F)
    % data#, axial position, time, mode extract(0:OFF, 1:ON)
    oldpath=path;
    path('../com',oldpath);
    f_path='path.txt';
    %
    switch sim
        case {'NLD', 'nld'}
            FVER=1;
            oldpath=addpath('../sim_data/nld','../sim_data/nld/plot');
        case {'R5F', 'r5f'}
            FVER=3.5;
            oldpath=addpath('../sim_data/r5f','../sim_data/task_eq','../sim_data/r5f/plot');
        case {'GENE', 'gene'}
            FVER=5;
            oldpath=addpath('../sim_data/GENE','../sim_data/GENE/plot','../sim_data/task_eq');       
        otherwise
            error('Unexpected simulation type.')
    end

    n = 0;
    data_n = input('data_n = (Enter 0 to exit.)');
    while data_n ~= 0
        n = n + 1;
        data3(:,:,n) = cont2(sim,data_n,ax,t,sum);
        olddata_n = data_n;
        data_n = input('data_n = (Enter 0 to exit.)');
    end
    %
    switch sim
        case {'GENE', 'gene'}
            FVER=5;
            dataC=GENEClass(f_path,olddata_n);
        otherwise
            error('Unexpected simulation type.')
    end
    
    %Generate time data (00****.dat) from TORUSIons_act.dat
    GENEdata = sprintf('%sTORUSIons_act_%.0f.dat', dataC.indir, t*100)
    generate_timedata(dataC,GENEdata,t);

    % parameters
    fread_param2(dataC);

    if(FVER ~= dataC.FVER)
            error('Simulation type mismatch (PARAM).')
    end  
    fread_EQ1(dataC);

    figure(1)
    data4 = mean(data3,3)*n;
    contourf(dataC.GRC.', dataC.GZC.', data4, 30, 'LineStyle', 'none'); 
    xlabel('R');
    ylabel('Z');
    axis equal;
    colorbar;

    path(oldpath);
end