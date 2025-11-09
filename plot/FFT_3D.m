% Perform 3D Fourier Transform
function FFT_3D(sim,data_n)
    oldpath=path;
    path('../com',oldpath);
    f_path='path.txt';
    %   
    switch sim
        case {'R5F', 'r5f'}
            FVER=3.5;
            oldpath=addpath('../sim_data/r5f','../sim_data/task_eq','../sim_data/r5f/plot');
            dataC=r5fClass(f_path,data_n);
        case {'GENE', 'gene'}
            FVER=5;
            oldpath=addpath('../sim_data/GENE','../sim_data/task_eq','../sim_data/GENE/plot');
            dataC=GENEClass(f_path,data_n);
        otherwise
            error('Unexpected simulation type.')
    end

    f_condition=sprintf('%s%s%d%s',dataC.indir,'LS_condition_JT60SA.txt')

    A=importdata(f_condition,',',5);
    pp1=A.data(1,:);
    wid1=A.data(2,1);
    wid2=A.data(2,2);
    div1=A.data(3,1);
    div2=A.data(3,2);
    divls=A.data(3,3);

    [xx1,yy1]=meshgrid(wid1/2*[-div1:div1]/div1,-wid2/2*[-div2:div2]/div2);
    xx1 = fliplr(xx1);

    if FVER == 3.5   % R5F
        f_list = dir(fullfile(dataC.indir, '*.dat'));
        % Filter out any files that do not match the pattern of numbers only (e.g., "○○.dat")
        f_list = f_list(~cellfun('isempty', regexp({f_list.name}, '^\d+\.dat$', 'match')));
        time_n = numel(f_list)
    elseif FVER == 5   % GENE
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

    t = zeros(time_n,1);
    for i = 1:time_n
        t(i) = str2double(sorted_t_value{i});
        t(i) = t(i)/100;
    end

    t = repmat(t,1,size(t,1));

    if FVER == 5   % To calculate obj.KYMt and obj.KZMt
        GENEdata = sprintf('%sTORUSIons_act_%.0f.dat', dataC.indir, t(1)*100);
        generate_timedata(dataC,GENEdata,t(1));
    end

    fread_param2(dataC);
    fread_EQ1(dataC);

    t = t * (dataC.L_ref/sqrt(2*dataC.T_ref2/dataC.m_ref));   % Converted to real time for frequency spectrum calculations

    xx = yy1.';
    yy = xx1.';
    tt = t;

    %sw = input('1:single fluctuation,  2:multi fluctuation : ');
    sw = 1
    if sw == 1
        %Single fluctuation
        pout2path = sprintf('%s%s%d%s',dataC.indir,'result_PCI/mat/IntegratedSignal_',data_n,'_overall.mat')
        data2 = load(pout2path);
        realSpaceData = data2.pout2;  
        size(realSpaceData)

    elseif sw == 2
        % multi fluctuation
        dirname = '/storage/data5/work/kuwamiya/data/GENE/'
        n = 0;
        data_n2 = input('data_n = (Enter 0 to exit.)');
        while data_n2 ~= 0
            n = n + 1;
            data_nlist(n) = data_n2;

            pout2path = sprintf('%s%d%s%d%s',dirname,data_n2,'/result_PCI/mat/IntegratedSignal_',data_n2,'_overall.mat')
            data2 = load(pout2path);
            realSpaceData2 = data2.pout2;  
            size(realSpaceData2)

            FFT2path = sprintf('%s%d%s%d%s',dirname,data_n2,'/result_PCI/mat/IntegratedSignal_FFT_',data_n2,'_overall.mat')
            FFT2 = load(FFT2path);
            % Get the size of the 3D data1
            integratedData(:,:,:,n) = realSpaceData2(:,:,1:150);
            spectrumdata(:,:,n) = FFT2.B;  

            data_n2 = input('data_n = (Enter 0 to exit.)');
        end
        realSpaceData = sum(integratedData,4);

    else
        error('Input error')
    end

    % Get the size of the 3D data1
    [Ny, Nx, Nt] = size(realSpaceData);
    
    % Perform the 3D FFT
    P = fftn(realSpaceData);
    P_shifted = fftshift(P);
    Amp = abs(P_shifted);
    
    % Get the spatial and temporal resolutions
    dx = (xx(1,2) - xx(1,1));
    dy = (yy(2,1) - yy(1,1));
    dt = (tt(2) - tt(1));
    
    % Generate wavenumber (kx, ky) and frequency (ω) vectors
    if mod(Nx, 2) == 0
        kx = 2*pi*(-Nx/2:Nx/2-1)/((Nx-1)*dx);
    else
        kx = 2*pi*(-(Nx-1)/2:(Nx-1)/2)/((Nx-1)*dx);
    end

    if mod(Ny, 2) == 0
        ky = 2*pi*(-Ny/2:Ny/2-1)/((Ny-1)*dy);
    else
        ky = 2*pi*(-(Ny-1)/2:(Ny-1)/2)/((Ny-1)*dy);
    end
    
    if mod(Nt, 2) == 0
        f = 2*pi*(-Nt/2:Nt/2-1)/(Nt*dt);  % Temporal frequency
    else
        f = 2*pi*(-(Nt-1)/2:(Nt-1)/2)/(Nt*dt);
    end
    
    [KX, KY, F] = meshgrid(kx, ky, f);
    
    % Normalization (if needed for your specific data1)
    if dataC.FVER == 5 % GENE normalization
        kx = kx * dataC.rho_ref;
        ky = ky * dataC.rho_ref;
        KX = KX * dataC.rho_ref;
        KY = KY * dataC.rho_ref;
        f  = f  * (dataC.L_ref/sqrt(2*dataC.T_ref2/dataC.m_ref));
        F  = F  * (dataC.L_ref/sqrt(2*dataC.T_ref2/dataC.m_ref));
    else
        kx = kx * 0.003;
        ky = ky * 0.003;
        KX = KX * 0.003;
        KY = KY * 0.003;
        % Not implemented with regard to frequency normalisation (sorry)
    end


    while true
        disp('1:kx,ky spectrum, 2:ω,ky spectrum, 3:ω,kx spectrum, 4:snap shot (not FFT), 5:2D FFT(kx,ky), else:end');
        mode = input('want to display = ');
        if mode == 1
            % Slices for a specific frequency
            disp(f)
            f_idx = input('want to slice f index = ');

            % Horizontal axis kx, vertical axis ky 
            figure(1);
            contourf(KX(:,:,f_idx), KY(:,:,f_idx), log(Amp(:,:,f_idx)), 30, 'LineStyle', 'none');
            xlabel('k_x\rho_i');
            ylabel('k_y\rho_i');
            title(sprintf('Slice at f = %.4f', f(f_idx)));
            colorbar;


        elseif mode == 2
            % Slice for a specific kx
            disp(kx)
            kx_idx = input('want to slice kx index = ');

            % Horizontal axis f, vertical axis ky
            figure(2);
            contourf(squeeze(F(:, kx_idx, :)), squeeze(KY(:, kx_idx, :)), log(squeeze(Amp(:, kx_idx, :))), 30, 'LineStyle', 'none');
            xlabel('f');
            ylabel('k_y \rho_i');
            title(sprintf('Slice at k_x = %.4f', kx(kx_idx)));
            colorbar;

        
        elseif mode == 3
            % Slice for a specific ky
            disp(ky)
            ky_idx = input('want to slice ky index = ');

            % Horizontal axis f, vertical axis kx
            figure(3);
            contourf(squeeze(F(ky_idx, :, :)), squeeze(KX(ky_idx, :, :)), log(squeeze(Amp(ky_idx, :, :))), 30, 'LineStyle', 'none');
            xlabel('f');
            ylabel('k_x \rho_i');
            title(sprintf('Slice at k_y = %.4f', ky(ky_idx)));
            colorbar;


        elseif mode == 4
            % Slice for a specific angle θ and output the f-k spectrum
            KX2 = KX(1:(Ny+1)/2,:,1);
            KY2 = KY(1:(Ny+1)/2,:,1);
            KX3 = KX2(1,(Nx+1)/2-1);
            KY3 = KY2((Ny+1)/2-1,1);

            theta = input('theta = ');
            theta = 180-theta;
            theta = deg2rad(theta);
            
            for j = 1:Nt
                for i  = 1:(Ny+1)/2
                    x2(i) = (KY3/tan(theta))*(i-1);
                    y2(i) = KY3*(i-1);
                    p2 = x2(i)/KX3;
                    pa2 = floor(p2);
                    pb2 = p2 - pa2;

                    col_idx1 = (Nx+1)/2 + pa2;
                    col_idx2 = col_idx1 + 1;
                    
                    if  col_idx1 < 1 || col_idx1 > size(Amp,2) || col_idx2 < 1 || col_idx2 > size(Amp,2)
                        continue; % If the index is out of range, skip.
                    end

                    fkAmp(i, j) = (1 - pb2) * Amp(end-i+1, col_idx1, j) + pb2 * Amp(end-i+1, col_idx2, j);
                    FK(i, j)  = sqrt((KY3*(i-1))^2 + x2(i)^2);
                    FF (i, j) = squeeze(F(1, 1, j))*(dataC.L_ref/sqrt(2*dataC.T_ref2/dataC.m_ref));
                end
            end

            figure(4)
            contourf(FF,FK,log(fkAmp(end:-1:1,end:-1:1)),100,'LineStyle','none')
            xlabel('f (kHz)');
            ylabel('kρ_i');
            colorbar


        elseif mode == 5
            % Display density fluctuation snapshots for a specific time
            disp(t(:,1).'/ (dataC.L_ref/sqrt(2*dataC.T_ref2/dataC.m_ref)))
            t_idx = input('want to slice t index = ');

            figure(5)
            contourf(xx,yy,realSpaceData(:,:,t_idx),100,'LineStyle','none');
            shading flat;
            axis equal;
            xlabel('x (m)');
            ylabel('y (m)');
            title(sprintf('t = %.2f', t(t_idx)/(dataC.L_ref/sqrt(2*dataC.T_ref2/dataC.m_ref))));
            colorbar

            %figure5_path = sprintf('%s%s%s%d%s%.0f%s',dataC.indir,'result_PCI/figure/','IntegratedSignal_',data_n,'_overall_',t(t_idx)/(dataC.L_ref/sqrt(2*dataC.T_ref2/dataC.m_ref))*100,'.fig');
            %saveas(figure(5),figure5_path);


        elseif mode == 6
            % Display time-averaged 2D wavenumber spectrum, save mat file
            kxkyAmp = zeros(Ny,Nx,Nt);
            Mean = mean(realSpaceData,3);
            for i = 1:time_n
                %B(:,:,i) = plotWaveNumberSpace(xx,yy,realSpaceData(:,:,i),dataC);
                [kxkyAmp(:,:,i),KX(:,:,i),KY(:,:,i)] = plotWaveNumberSpace_2(xx,yy,realSpaceData(:,:,i),Mean,dataC);
            end

            kxkyAmp_ave = mean(kxkyAmp,3);
            figure(6)
            contourf(KX(:,:,1),KY(:,:,1),log(kxkyAmp_ave),100,'LineStyle','none');
            xlabel('k_xρ_i')
            ylabel('k_yρ_i')
            colorbar;

            %figure6_path = sprintf('%s%s%s%d%s',dataC.indir,'result_PCI/figure/','IntegratedSignal_FFT2_',data_n,'_overall.fig')
            %saveas(figure(6),figure6_path);
            datpath = sprintf('%s%s%s%d%s',dataC.indir,'result_PCI/mat/','IntegratedSignal_FFT_',data_n,'_overall.mat')
            save(datpath, 'kxkyAmp_ave');

            % Slice for a specific angle θ and output a 1D wavenumber spectrum
            figure(7)
            kxkyAmp_ave2 = kxkyAmp_ave(1:(Ny+1)/2,:);
            KX2 = KX(1:(Ny+1)/2,:,1);
            KY2 = KY(1:(Ny+1)/2,:,1);
            contourf(KX2,KY2,log(kxkyAmp_ave2),100,'LineStyle','none');
            xlabel('k_xρ_i')
            ylabel('k_yρ_i')
            colorbar;
            hold on

            KX3 = KX2(1,(Nx+1)/2-1);
            KY3 = KY2((Ny+1)/2-1,1);
            kxkyAmp_ave3 = NaN;
            K = NaN;
            x = NaN;
            y = NaN;
            theta = input('theta = ');
            theta2 = theta; % for output file name
            theta = 180-theta;
            if theta == 90
                for i = 1:(Ny+1)/2
                    kxkyAmp_ave3(i) = kxkyAmp_ave2(end-i+1, (Nx+1)/2);
                    K(i)  = KY3*(i-1);
                end
    
            else
                theta = deg2rad(theta);
                for i = 1:(Ny+1)/2
                    x(i) = (KY3/tan(theta))*(i-1);
                    y(i) = KY3*(i-1);
                    p = x(i)/KX3;
                    pa = floor(p);
                    pb = p - pa;
                
                    col_idx1 = (Nx+1)/2 + pa;
                    col_idx2 = col_idx1 + 1;
                
                    if  col_idx1 < 1 || col_idx1 > size(kxkyAmp_ave2,2) || col_idx2 < 1 || col_idx2 > size(kxkyAmp_ave2,2)
                        continue; % If the index is out of range, skip.
                    end
                
                    kxkyAmp_ave3(i) = (1 - pb) * kxkyAmp_ave2(end-i+1, col_idx1) + pb * kxkyAmp_ave2(end-i+1, col_idx2);
                    K(i)  = sqrt((KY3*(i-1))^2 + x(i)^2);
                    plot(-(1)*x,y,'-k')
                end
                
            end

            hold off
            %figure7_path = sprintf('%s%s%s%d%s%d%s',dataC.indir,'result_PCI/figure/','IntegratedSignal_FFT2_withline_',theta2,'_',data_n,'_overall.fig')
            %saveas(figure(7),figure7_path);

            figure(8)
            plot(K,log(kxkyAmp_ave3),'-ok')
            xlabel('kρ_i')
            ylabel('Amplitude')
            %figure8_path = sprintf('%s%s%s%d%s%d%s',dataC.indir,'result_PCI/figure/','IntegratedSignal_FFT2_cutout_',theta2,'_',data_n,'_overall.fig')
            %saveas(figure(8),figure8_path);
            

        elseif mode == 9
            %Display wavenumber spectra assuming multiple flux tubes
            dirname = '/storage/data5/work/kuwamiya/data/GENE/'

            n = 0;
            data_n2 = input('data_n = (Enter 0 to exit.)');
            while data_n2 ~= 0
                n = n + 1;
                data_nlist(n) = data_n2;
    
                FFTpath = sprintf('%s%d%s%d%s',dirname,data_n2,'/result_PCI/mat/IntegratedSignal_FFT_',data_n2,'_overall.mat')
                FFT = load(FFTpath);
                FFTAmp(:,:,n) = FFT.kxkyAmp_ave;  

                data_n2 = input('data_n = (Enter 0 to exit.)');
            end

            sumAmp = sum(FFTAmp, 3);

            figure(9)
            contourf(KX(:,:,1),KY(:,:,1),log(sumAmp),100,'LineStyle','none');
            xlabel('k_xρ_i')
            ylabel('k_yρ_i')
            colorbar;


        elseif mode == 10
            %Display frequency spectra assuming multiple flux tubes
            dirname = '/storage/data5/work/kuwamiya/data/GENE/'

            n = 0;
            data_n2 = input('data_n = (Enter 0 to exit.)');
            while data_n2 ~= 0
                n = n + 1;
                data_nlist(n) = data_n2;
                FFTfkypath = sprintf('%s%d%s%d%s',dirname,data_n2,'/result_PCI/mat/IntegratedSignal_FFT_frequency_fky_',data_n2,'_overall.mat')
                FFTfky = load(FFTfkypath);
                fkydata(:,:,n) = FFTfky.fky(1:Nt,:).';  

                data_n2 = input('data_n = (Enter 0 to exit.)');
            end

            sumfkydata = sum(fkydata, 3);

            figure(10)
            F = F*(dataC.L_ref/sqrt(2*dataC.T_ref2/dataC.m_ref))*1000;
            contourf(squeeze(F(:,1,:)),squeeze(KY(:,1,:)),sumfkydata,100,'LineStyle','none');
            xlabel('f [kHz]')
            ylabel('k_yρ_i')
            colorbar;


        elseif mode == 11
            %Display local integration information, wavenumber spectra and frequency spectra from the data (LocalCross-Section_246_overall.mat) for each beam section.
            pout1path = sprintf('%s%s%d%s',dataC.indir,'result_PCI/mat/LocalCross-Section_',data_n,'_overall.mat')
            data1 = load(pout1path);
            localSpaceData = data1.pout1; 

            kxkyAmp = zeros(Ny,Nx,Nt);

            disp('0:exit')
            %b_idx = 1500
            b_idx = input('want to slice beam index = ');
            t_idx = Nt
            %t_idx = input('want to slice time index = ');
            width = 200
            %width = input('How many cross-sections to integrate? ');

            while b_idx ~= 0
                figure(11) % Beam cross section in b_idx
                contourf(xx,yy,localSpaceData(:,:,b_idx,t_idx),100,'LineStyle','none');
                shading flat;
                axis equal;
                colorbar
                xlabel('x (m)');
                ylabel('y (m)');
                title(sprintf('Slice at beam = %d', b_idx))

                figure(12) % Local integration information integrated over the width width centred on b_idx
                %t_idx = input('want to slice t index = ');
                contourf(xx,yy,sum(localSpaceData(:,:,b_idx-width/2:b_idx+width/2,t_idx),3),100,'LineStyle','none');
                shading flat;
                axis equal;
                colorbar
                xlabel('x (m)');
                ylabel('y (m)');
                title(sprintf('Slice at beam = %d local integrated', b_idx))

                %figure12_path = sprintf('%s%s%s%d%s%.0f%s%d%s',dataC.indir,'result_PCI/figure/','LocalCross-Section_integrated_',data_n,'_',t(t_idx)/(dataC.L_ref/sqrt(2*dataC.T_ref2/dataC.m_ref))*100,'_beam=',b_idx,'.fig');
                %saveas(figure(12),figure12_path);

                for i = 1:time_n
                    sumlocalSpaceData = sum(localSpaceData(:,:,b_idx-width/2:b_idx+width/2,i),3);
                    Mean = mean(localSpaceData(:,:,:,:),4);
                    Mean = mean(Mean(:,:,:),3);
                    [kxkyAmp(:,:,i),KX(:,:,i),KY(:,:,i)] = plotWaveNumberSpace_2(xx,yy,sumlocalSpaceData,Mean,dataC);
                end
                kxkyAmp_sum = mean(kxkyAmp,3);
                figure(13)
                contourf(KX(:,:,1),KY(:,:,1),log(kxkyAmp_sum),1000,'LineStyle','none');
                xlabel('k_xρ_i')
                ylabel('k_yρ_i')
                colorbar;

                figure13_path = sprintf('%s%s%s%d%s%d%s',dataC.indir,'result_PCI/figure/','LocalCross-Section_FFT_',data_n,'_beam=',b_idx,'.fig');
                saveas(figure(13),figure13_path);

                [T, YY] = meshgrid(t(:,1), yy(:,1)); 
                figure(14)
                x_idx = div2+1
                E = sum(localSpaceData(:,:,b_idx-width/2:b_idx+width/2,:),3);
                plotWaveNumberSpace(T,YY,squeeze(E(:,x_idx,:)).',dataC);
                xlabel('f[Hz]');
                ylabel('k_yρ_i');
                colorbar

                EE = sum(localSpaceData(:,:,b_idx-width/2:b_idx+width/2,:),3);
                fky = plotWaveNumberSpace(T,YY,squeeze(EE(:,x_idx,:)).',dataC);
                datpath_14 = sprintf('%s%s%s%d%s',dataC.indir,'result_PCI/mat/','IntegratedSignal_FFT_frequency_fky_',data_n,'_overall.mat') % for multi fluctuation
                save(datpath_14, 'fky');


                disp('0:exit')
                b_idx = input('want to slice beam index = ');
            end


        elseif mode == 15
            % Animation of the change of the beam cross section with respect to the beam progression
            pout1path = sprintf('%s%s%d%s',dataC.indir,'result_PCI/mat/LocalCross-Section_',data_n,'_overall.mat')
            data1 = load(pout1path);
            localSpaceData = data1.pout1;
            %t_idx = 154
            t_idx = Nt;

            video_path = sprintf('%s%s%s%d%s%.0f%s',dataC.indir,'result_PCI/movie/','LocalCross-Section_',data_n, '_' ,t(t_idx)/(dataC.L_ref/sqrt(2*dataC.T_ref2/dataC.m_ref))*100,'.avi')
            v = VideoWriter(video_path);
            v.FrameRate = 50;
            open(v);
            for b = 1:size(localSpaceData,3)
                figure(15)
                contourf(xx,yy,localSpaceData(:,:,b,t_idx),100,'LineStyle','none');
                shading flat;
                axis equal;
                colorbar
                xlabel('x (m)');
                ylabel('y (m)');
                title(b);

                frame = getframe(gcf);
                writeVideo(v, frame);
            end
            close(v);


        elseif mode == 16
            % Animation of the time variation of the integral signal.
            video_path = sprintf('%s%s%s%d%s',dataC.indir,'result_PCI/movie/','IntegratedSignal_',data_n,'_overall.avi')
            v = VideoWriter(video_path);
            v.FrameRate = 10;
            open(v);
            for i = 1:time_n
                colormap(bwr)
                figure(16)
                contourf(yy1.',xx1.',realSpaceData(:,:,i), 100,'LineStyle','none');
                shading flat;
                axis equal;
                colorbar
                xlabel('x (m)');
                ylabel('y (m)');
                clim([-3000,3000])
                title(sprintf('t = %.2f', t(i)/(dataC.L_ref/sqrt(2*dataC.T_ref2/dataC.m_ref))));
    
                frame = getframe(gcf);
                writeVideo(v, frame);
            end
            close(v);


        elseif mode == 17
            % Create animation of the time variation of the local integral signal
            pout1path = sprintf('%s%s%d%s',dataC.indir,'result_PCI/mat/LocalCross-Section_',data_n,'_overall.mat')
            data1 = load(pout1path);
            localSpaceData = data1.pout1;  

            disp('0:exit')
            b_idx = input('want to slice beam index = ');

            while b_idx ~= 0
                %t_idx = 154
                width = 200

                video_path = sprintf('%s%s%s%d%s%d%s',dataC.indir,'result_PCI/movie/','IntegratedSignal_',data_n,'_beam=',b_idx,'_overall.avi')
                v = VideoWriter(video_path);
                v.FrameRate = 10;
                open(v);

                for i = 1:time_n
                    colormap(bwr)
                    figure(53)
                    contourf(yy1.',xx1.',sum(localSpaceData(:,:,b_idx-width/2:b_idx+width/2,i),3), 100,'LineStyle','none');
                    shading flat;
                    axis equal;
                    colorbar
                    xlabel('x (m)');
                    ylabel('y (m)');
                    clim([-500,500])
                    title(sprintf('t = %.2f', t(i)/(dataC.L_ref/sqrt(2*dataC.T_ref2/dataC.m_ref))));
        
                    frame = getframe(gcf);
                    writeVideo(v, frame);
                end
                disp('0:exit')
                b_idx = input('want to slice beam index = ');
            end

        else 
            break;
        end
    end

    path(oldpath);
end