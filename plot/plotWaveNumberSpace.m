%generate 2D wavenumber spectrum
function Amp = plotWaveNumberSpace(xx, yy, realSpaceData,obj)

    Mean = mean(mean(realSpaceData(:)));

    realSpaceData = realSpaceData - Mean;
    [Ny, Nx] = size(realSpaceData);
    P = fft2(realSpaceData);
    P_shifted = fftshift(P);
    Amp = abs(P_shifted);

    dx = (xx(1,2) - xx(1,1));
    dy = (yy(2,1) - yy(1,1));

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

    [KX, KY] = meshgrid(kx, ky);

    %normalized
    if obj.FVER == 5 %GENE
        kx = kx*obj.rho_ref;
        ky = ky*obj.rho_ref;
        KX = KX*obj.rho_ref;
        KY = KY*obj.rho_ref;
    else
        kx = kx*0.003;
        ky = ky*0.003;
        KX = KX*0.003;
        KY = KY*0.003;
    end
    %
    contourf(KX, KY, log(Amp), 100, 'LineStyle', 'none');
    xlabel('k_xρ_i')
    ylabel('k_yρ_i')
    colorbar;
    %
end