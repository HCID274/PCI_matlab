function sampledata(sim, data_n, tmax)
    oldpath = path;
    path('../com', oldpath);
    f_path = 'path.txt';
    
    % Initialize simulation environment
    switch sim
        case {'GENE', 'gene'}
            FVER = 5;
            oldpath = addpath('../sim_data/GENE', '../sim_data/task_eq', '../sim_data/GENE/plot');
            dataC = GENEClass(f_path, data_n);
        otherwise
            error('Unexpected simulation type.');
    end

    % Mesh and device parameters
    Rmesh = 128;  % Number of radial mesh points
    Pmesh = 400;  % Number of poloidal mesh points
    Tmesh = 101;  % Number of toroidal mesh points
    theta = 2*pi; % Full poloidal angle [rad]
    phi = 2*pi;   % Full toroidal angle [rad]

    % Fluctuation model parameters
    r0 = 0.9; % Center of radial localization [m]
    Lr = 0.3; % Radial localization width [m]
    lamda_r = 0.15; % Radial wavelength [m]
    m = 60; % Poloidal mode number
    n = -30; % Toroidal mode number
    kr = 2*pi/lamda_r; % Radial wavenumber [1/m]
    omega = -0.5;

    for t = 1:tmax
        % Create mesh grids
        r = linspace(r0 - Lr / 2, r0 + Lr / 2, Rmesh); % Radial positions
        theta_vals = linspace(0, theta, Pmesh); % Poloidal angles
        phi_vals = linspace(0, phi, Tmesh); % Toroidal angles
        [R, Theta, Phi] = ndgrid(r, theta_vals, phi_vals); % 3D mesh grid

        % fluctuation
        r_term = exp(-((R - r0) / Lr).^2) .* sin(kr * R); % Radial
        mn_term = exp(1i * (m * Theta + n * Phi - omega * t)); % Poloidal and toroidal
        fluctuation = real(r_term .* mn_term);

        % Rearrange dimensions for output format
        reshaped_data = permute(fluctuation, [3, 2, 1]); 

        % Output to .dat file
        file = fullfile(dataC.indir, sprintf('TORUSIons_act_%d.dat', t * 100));
        fid = fopen(file, 'w'); 
        for i = 1:Tmesh
            slice_data = squeeze(reshaped_data(i, :, :)); % Extract 2D slice
            for j = 1:size(slice_data, 1) % Row-wise write
                fprintf(fid, '%.6f\t', slice_data(j, :)); % Write row
                fprintf(fid, '\n'); % Newline at the end of each row
            end 
        end
        fclose(fid); % Close the file

        fprintf('Progress: %d/%d\n', t, tmax);
        % Restore path
        path(oldpath);
    end
end
