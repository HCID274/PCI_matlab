% read 'parameters.dat', including simulation parameters
function fread_param2(obj)
    %
    str = 'parameters.dat';
    file = sprintf('%s%s', obj.indir, str)
    fid = fopen(file, 'r');
    RET = fread(fid, 1, 'int'); % return key

    % Create a Key-Value store
    param_map = containers.Map();

    % Initialize `current_section` explicitly
    current_section = '';

    % Check if the first line starts with `&`
    first_line = strtrim(fgetl(fid));
    if startsWith(first_line, '&')
        current_section = strtrim(first_line(2:end)); % Remove `&` and set section name
    else
        % If the first line does not start with `&`, reset the file pointer
        fseek(fid, 0, 'bof');
    end

    % Read the file line by line
    while ~feof(fid)
        line = strtrim(fgetl(fid)); % Remove leading/trailing spaces

        % Skip empty lines or comment lines (`/`)
        if isempty(line) || strcmp(line, '/')
            continue;
        end

        % Update the section
        if startsWith(line, '&')
            current_section = strtrim(line(2:end)); % Remove `&`
            continue;
        end

        % Extract key-value pairs
        tokens = strsplit(line, '=');
        if length(tokens) == 2
            key = strtrim(tokens{1});
            valueStr = strtrim(tokens{2});

            % Convert to number if possible
            value = str2double(valueStr);
            if isnan(value)
                value = valueStr; % Store as string if conversion fails
            end

            % Store in param_map
            full_key = sprintf('%s.%s', current_section, key);
            param_map(full_key) = value;
        end
    end

    fclose(fid);

    obj.FVER = 5;
    obj.LYM2 = obj.KYMt;
    obj.LZM2 = obj.KZMt/2+1;
    obj.KYM = obj.KYMt/2;
    obj.KZM = obj.LZM2-1;
    obj.LMAX = 2*obj.KYM*(obj.KZM+1)-1;
    LKYt = [(0:obj.KYMt/2)'; (-obj.KYMt/2+1:-1)'];
    LKZt = (0:obj.KZMt/2)';
    obj.LKY = reshape(repmat(LKYt,obj.LZM2, 1), obj.LMAX+1, 1);
    obj.LKZ = reshape(repmat(LKZt.',obj.LYM2, 1), obj.LMAX+1, 1);

    % parallelization
    obj.n_procs_s = param_map('parallelization.n_procs_s');
    obj.n_procs_v = param_map('parallelization.n_procs_v');
    obj.n_procs_w = param_map('parallelization.n_procs_w');
    obj.n_procs_x = param_map('parallelization.n_procs_x');
    obj.n_procs_y = param_map('parallelization.n_procs_y');
    obj.n_procs_z = param_map('parallelization.n_procs_z');
    obj.n_procs_sim = param_map('parallelization.n_procs_sim');

    % box
    obj.n_spec = param_map('box.n_spec');
    obj.nx0 = param_map('box.nx0');
    obj.nky0 = param_map('box.nky0');
    obj.nz0 = param_map('box.nz0');
    obj.nv0 = param_map('box.nv0');
    obj.nw0 = param_map('box.nw0');

    obj.kymin = param_map('box.kymin');
    obj.lv = param_map('box.lv');
    obj.lw = param_map('box.lw');
    obj.lx = param_map('box.lx');
    obj.nexc = param_map('box.nexc');

    % in_out
    obj.istep_field = param_map('in_out.istep_field');
    obj.istep_mom = param_map('in_out.istep_mom');
    obj.istep_nrg = param_map('in_out.istep_nrg');
    obj.istep_vsp = param_map('in_out.istep_vsp');
    obj.istep_schpt = param_map('in_out.istep_schpt');
    obj.istep_energy = param_map('in_out.istep_energy');
    obj.istep_energy3d = param_map('in_out.istep_energy3d');
    obj.istep_neoclass = param_map('in_out.istep_neoclass');

    % general
    obj.beta = param_map('general.beta');
    obj.debye2 = param_map('general.debye2');

    % geometry
    obj.q0 = param_map('geometry.q0');
    obj.shat = param_map('geometry.shat');
    obj.trpeps = param_map('geometry.trpeps');
    obj.major_R = param_map('geometry.major_R');

    % species
    obj.q_ref = 1.6022*10^-19; % [C]

    if obj.n_spec == 1
        obj.omn1 = param_map('species.omn');
        obj.omt1 = param_map('species.omt');
        obj.mass1 = param_map('species.mass');
        obj.temp1 = param_map('species.temp');
        obj.dens1 = param_map('species.dens');
        obj.charge1 = param_map('species.charge');

        obj.B_ref = param_map('units.Bref');
        obj.T_ref = param_map('units.Tref'); % [keV]
        obj.T_ref2 = obj.T_ref*10^3*obj.q_ref; % [J]
        obj.n_ref = param_map('units.nref') *10^19;
        obj.L_ref = param_map('units.Lref');
        obj.m_ref = param_map('units.mref') *1.6726232*10^-27;
    end

    if obj.n_spec == 2
        obj.omn1 = param_map('species.omn');
        obj.omt1 = param_map('species.omt');
        obj.mass1 = param_map('species.mass');
        obj.temp1 = param_map('species.temp');
        obj.dens1 = param_map('species.dens');
        obj.charge1 = param_map('species.charge');

        obj.omn2 = param_map('species.omn2');
        obj.omt2 = param_map('species.omt2');
        obj.mass2 = param_map('species.mass2');
        obj.temp2 = param_map('species.temp2');
        obj.dens2 = param_map('species.dens2');
        obj.charge2 = param_map('species.charge2');

        obj.B_ref = param_map('units.Bref');
        obj.T_ref = param_map('units.Tref'); % [keV]
        obj.T_ref2 = obj.T_ref*10^3*obj.q_ref; % [J]
        obj.n_ref = param_map('units.nref') *10^19;
        obj.L_ref = param_map('units.Lref');
        obj.m_ref = param_map('units.mref') *1.6726232*10^-27;
    end

    % other parameters
    obj.c_ref = sqrt(obj.T_ref2/obj.m_ref);
    obj.omega_ref = obj.q_ref*obj.B_ref/obj.m_ref;
    obj.rho_ref = obj.c_ref/obj.omega_ref;

    minor_r = 1.18
    IN = (obj.trpeps*obj.major_R*obj.L_ref/(obj.rho_ref*obj.lx)-(1/2))*obj.nx0;
    OUT = (((minor_r-obj.trpeps*obj.major_R*obj.L_ref)/(obj.rho_ref*obj.lx))-(1/2))*obj.nx0;
    obj.inside = round(IN);
    obj.outside = round(OUT);

    obj.IRMAX = obj.nx0;
end