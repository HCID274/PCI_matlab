function LSview_com_loop(sim,data_n,var)
    oldpath=path;
    path('../com',oldpath);
    f_path='path.txt';
    %   
    switch sim
        case {'R5F', 'r5f'}
            FVER=3.5;
            oldpath=addpath('../sim_data/r5f','../sim_data/task_eq','../sim_data/r5f/plot');
            dataC=r5fClass(f_path,data_n);
        case {'MIPS', 'mips'}
            FVER=4;
            oldpath=addpath('../sim_data/mips','../sim_data/mips/plot');
            dataC=hibpClass_mips(f_path,data_n);
        case {'GENE', 'gene'}
            FVER=5;
            oldpath=addpath('../sim_data/GENE','../sim_data/task_eq','../sim_data/GENE/plot');
            dataC=GENEClass(f_path,data_n);
        otherwise
            error('Unexpected simulation type.')
    end

    f_condition='./LS_condition_JT60SA.txt';

    A=importdata(f_condition,',',5);
    pp1=A.data(1,:);
    wid1=A.data(2,1);
    wid2=A.data(2,2);
    div1=A.data(3,1);
    div2=A.data(3,2);
    divls=A.data(3,3);
    divls_2=divls+1;

    if FVER == 3.5
        f_list = dir(fullfile(dataC.indir, '*.dat'));
        % Filter out any files that do not match the pattern of numbers only (e.g., "○○.dat")
        f_list = f_list(~cellfun('isempty', regexp({f_list.name}, '^\d+\.dat$', 'match')));
        time_n = numel(f_list)
    elseif FVER == 5
        f_list = dir(fullfile(dataC.indir, 'TORUSIons_act_*.dat'));
        time_n = numel(f_list)
    end
    
    t_value = cell(numel(f_list), 1);
    
    for i = 1:numel(f_list)
        fileName = f_list(i).name;
        if FVER == 3.5
            t_string = fileName(1:end-length('.dat'));
        elseif FVER == 5
            t_string = fileName(length('TORUSIons_act_')+1:end-length('.dat'));
        end
        t_value{i} = t_string;
    end
    
    t_numbers = str2double(t_value);
    [~, sortOrder] = sort(t_numbers);
    sorted_t_value = t_value(sortOrder);
    pause

    pout1 = zeros(2*div1+1,2*div2+1,divls_2,time_n);
    pout2 = zeros(2*div1+1,2*div2+1,time_n);
    
    for i = 1:time_n
        t = str2double(sorted_t_value{i});
        t = t/100
        if t == 0
            % skip
        else
            [pout1(:,:,:,i), pout2(:,:,i)] = LSview_com(sim,data_n,t,var);

            [xx1,yy1]=meshgrid(wid1/2*[-div1:div1]/div1,-wid2/2*[-div2:div2]/div2);
            xx1 = fliplr(xx1);

            figure(43)
            contourf(yy1.',xx1.',pout2(:,:,i), 100,'LineStyle','none');
            shading flat;
            axis equal;
            colorbar
            xlabel('x (m)');
            ylabel('y (m)');
            title(sprintf('t = %.2f', t));

        end
    end

    dat1path = sprintf('%s%s%s%d%s',dataC.indir,'result_PCI/mat/','LocalCross-Section_',data_n,'_overall.mat')
    save(dat1path, 'pout1','-v7.3');
    dat2path = sprintf('%s%s%s%d%s',dataC.indir,'result_PCI/mat/','IntegratedSignal_',data_n,'_overall.mat')
    save(dat2path, 'pout2');
    
    path(oldpath);
end
