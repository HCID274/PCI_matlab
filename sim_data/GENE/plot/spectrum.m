% plot time evolution of mode energy
function spectrum(sim, data_n, t)
    % simulation type: 5(GENE)
    oldpath = path;
    path('../com', oldpath);
    f_path = 'path.txt';

    switch sim
        case {'GENE', 'gene'}
            FVER = 5;
            oldpath = addpath('../sim_data/GENE', '../sim_data/task_eq', '../sim_data/GENE/plot');
            dataC = GENEClass(f_path, data_n);
        otherwise
            error('Unexpected simulation type.');
    end
    clf;

    % Get the number of files in the directory
    t_num_kx = numel(dir(fullfile(dataC.indir, 'SPECTRAIons_act_kx_*.dat')));
    t_num_ky = numel(dir(fullfile(dataC.indir, 'SPECTRAIons_act_ky_*.dat')));

    % Preallocate arrays (assuming nky = 64)
    kx = zeros(64, 1, t_num_kx);
    ky = zeros(1, 64, t_num_ky);

    % Preallocate tkx and tky
    tkx = zeros(1, t_num_kx);
    tky = zeros(1, t_num_ky);

    % read SPECTRAIons_act.dat

    nkx = zeros(64, 1, t_num_kx);
    nky = zeros(1, 64, t_num_ky);

    for k = 1:2 %(1:kx, 2:ky)
        if k == 1
            f_list = dir(fullfile(dataC.indir, 'SPECTRAIons_act_kx_*.dat'));
        elseif k == 2
            f_list = dir(fullfile(dataC.indir, 'SPECTRAIons_act_ky_*.dat'));
        end

        file_numbers = zeros(1, numel(f_list));
        for i = 1:numel(f_list)
            file_name = f_list(i).name;
            if k == 1
                file_numbers(i) = str2double(regexp(file_name, '(?<=SPECTRAIons_act_kx_)\d+', 'match', 'once'));
            elseif k == 2
                file_numbers(i) = str2double(regexp(file_name, '(?<=SPECTRAIons_act_ky_)\d+', 'match', 'once'));
            end
        end

        [~, sortOrder] = sort(file_numbers);
        f_list = f_list(sortOrder);

        % Sort file numbers and store in tkx or tky after sorting
        if k == 1
            tkx = file_numbers(sortOrder)/100;  % Store sorted numbers in tkx
        elseif k == 2
            tky = file_numbers(sortOrder)/100;  % Store sorted numbers in tky
        end

        for i = 1:numel(f_list)
            file_path = fullfile(dataC.indir, f_list(i).name);
            data = fileread(file_path);
            lines = strsplit(data, '\n');

            temp_k = [];
            temp_n = [];
            for j = 1:length(lines)
                line = strtrim(lines{j});
                if ~isempty(line)
                    values = sscanf(line, '%f %f');
                    if length(values) == 2
                        temp_k(end+1) = values(1);
                        temp_n(end+1) = values(2);
                    end
                end
            end

            num_lines = length(temp_k);
            if k == 1
                kx(1:num_lines, 1, i) = temp_k';
                nkx(1:num_lines, 1, i) = temp_n';
            elseif k == 2
                ky(1, 1:num_lines, i) = temp_k';
                nky(1, 1:num_lines, i) = temp_n';
            end

            disp(['File: ', f_list(i).name]);
        end
    end

    % Plotting the data
    % After tkx and tky are populated
    idx_tkx = find(tkx == t, 1); % Find the index where tkx equals t
    disp(['The index of t in tkx is: ', num2str(idx_tkx)]);
    idx_tky = find(tky == t, 1); % Find the index where tky equals t
    disp(['The index of t in tky is: ', num2str(idx_tky)]);

    figure(1)
    plot(kx(:,1,idx_tkx), nkx(:,1,idx_tkx))
    xlabel('k_xρ_i');
    ylabel('Amplitude');
    title(sprintf('t= %.2f',t))

    figure(2)
    plot(ky(1,:,idx_tky), nky(1,:,idx_tky))
    xlabel('k_yρ_i');
    ylabel('Amplitude');
    title(sprintf('t = %.2f',tkx(1,idx_tky)))

    figure(3)
    glid_x = 1
    for i = 1:15
        plot(squeeze(tkx), squeeze(nkx((i-1)*glid_x+1,1,:)))
        lx_list{i} = sprintf('k_xρ_i= %.3f ', round((i-1)*kx(glid_x+1,1,1),4));
        hold on
    end
    hold off
    xlabel('t');
    ylabel('n');
    legend(lx_list,'Location', 'Best')

    figure(4)
    glid_y = 1
    for i = 1:15
        plot(squeeze(tky), squeeze(nky(1,(i-1)*glid_y+1,:)))
        ly_list{i} = sprintf('k_yρ_i= %.3f ', round((i-1)*ky(1,glid_y+1,1),4));
        hold on
    end
    hold off
    xlabel('t');
    ylabel('Amplitude');
    legend(ly_list,'Location', 'Best')
    
    figure(5)
    m_nkx = mean(nkx,3);
    plot(kx(:,1,1), m_nkx)
    xlabel('k_xρ_i');
    ylabel('Amplitude');
    title('Time Average')


    figure(6)
    m_nky = mean(nky,3);
    plot(ky(1,:,1), m_nky)
    xlabel('k_yρ_i');
    ylabel('Amplitude');
    title('Time Average')

    path(oldpath);
end
