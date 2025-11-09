% local value of data1

function z = probeEQ_local_s(obj,R0,Z0,PHI0,data)
    poid_cyl = zeros(3, 1);
    da_cyl = zeros(3, 1);
    r = sqrt((R0 - obj.PA(1)).^2 + (Z0 - obj.PA(2)).^2);
    theta = mod(atan2(Z0 - obj.PA(2), R0 - obj.PA(1)), 2*pi);
    theta_p = bisec(theta, obj.GTC_c(end, :));
    philist = linspace(0, 1, obj.KZMt+1+1);

    if ((r < obj.GAC(end, theta_p(1))) && (r < obj.GAC(end, theta_p(2))))
        poid_cyl(2) = theta_p(1);
        r_p = bisec(r, obj.GAC(:, poid_cyl(2)).');
        PHI0;
        p_p = bisec(PHI0/(2*pi), philist);
        poid_cyl(1) = r_p(1);
        poid_cyl(3) = p_p(1);
    else
        z = 0.0;
        return
    end

    r_min = obj.GAC(poid_cyl(1), poid_cyl(2));
    r_max = obj.GAC(poid_cyl(1) + 1, poid_cyl(2));
    theta_min = obj.GTC_c(end, poid_cyl(2));
    theta_max = obj.GTC_c(end, poid_cyl(2) + 1);
    phi_min = philist(poid_cyl(3));
    phi_max = philist(poid_cyl(3) + 1);

    da_cyl(1) = (r_max - r) / (r_max - r_min);
    da_cyl(2) = (theta_max - theta) / (theta_max - theta_min);
    da_cyl(3) = (phi_max - PHI0/(2*pi)) / (phi_max - phi_min);

    m1 = poid_cyl(1);
    n1 = poid_cyl(2);
    p1 = poid_cyl(3);
    m2 = m1 + 1;
    n2 = n1 + 1;
    p2 = p1 + 1;

    z = da_cyl(3) * (da_cyl(2) * (da_cyl(1) * data(n1, m1, p1) + (1.0 - da_cyl(1)) * data(n1, m2, p1)) ...
        + (1.0 - da_cyl(2)) * (da_cyl(1) * data(n2, m1, p1) + (1 - da_cyl(1)) * data(n2, m2, p1))) ...
        + (1.0 - da_cyl(3)) * (da_cyl(2) * (da_cyl(1) * data(n1, m1, p2) + (1.0 - da_cyl(1)) * data(n1, m2, p2)) ...
        + (1.0 - da_cyl(2)) * (da_cyl(1) * data(n2, m1, p2) + (1 - da_cyl(1)) * data(n2, m2, p2)));
    return
end