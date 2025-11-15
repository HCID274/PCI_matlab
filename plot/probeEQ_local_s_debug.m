% probeEQ_local_s_debug.m
% 纯函数版：不依赖 GENEClass，直接吃 PA / GAC / GTC_c / KZMt / data
function z = probeEQ_local_s_debug(PA, GAC, GTC_c, KZMt, R0, Z0, PHI0, data)

    poid_cyl = zeros(3, 1);
    da_cyl   = zeros(3, 1);

    % (R,Z,phi) -> (r, theta)
    r = sqrt((R0 - PA(1)).^2 + (Z0 - PA(2)).^2);
    theta = mod(atan2(Z0 - PA(2), R0 - PA(1)), 2*pi);

    % theta 索引 (对应 MATLAB: theta_p = bisec(theta, obj.GTC_c(end, :));)
    theta_p = bisec(theta, GTC_c(end, :));

    % phi 网格 (对应 MATLAB: philist = linspace(0, 1, obj.KZMt+1+1);)
    philist = linspace(0, 1, KZMt+1+1);

    % 等离子体内/外判断
    if ((r < GAC(end, theta_p(1))) && (r < GAC(end, theta_p(2))))
        poid_cyl(2) = theta_p(1);
        r_p = bisec(r, GAC(:, poid_cyl(2)).');
        p_p = bisec(PHI0/(2*pi), philist);
        poid_cyl(1) = r_p(1);
        poid_cyl(3) = p_p(1);
    else
        z = 0.0;
        return
    end

    % 8 个角点的边界值
    r_min     = GAC(poid_cyl(1),     poid_cyl(2));
    r_max     = GAC(poid_cyl(1) + 1, poid_cyl(2));
    theta_min = GTC_c(end, poid_cyl(2));
    theta_max = GTC_c(end, poid_cyl(2) + 1);
    phi_min   = philist(poid_cyl(3));
    phi_max   = philist(poid_cyl(3) + 1);

    % 三个方向的权重
    da_cyl(1) = (r_max   - r)          / (r_max   - r_min);
    da_cyl(2) = (theta_max - theta)    / (theta_max - theta_min);
    da_cyl(3) = (phi_max - PHI0/(2*pi)) / (phi_max - phi_min);

    % 8 个网格索引
    m1 = poid_cyl(1);
    n1 = poid_cyl(2);
    p1 = poid_cyl(3);
    m2 = m1 + 1;
    n2 = n1 + 1;
    p2 = p1 + 1;

    % 三线性插值 (完全照抄你原来的 probeEQ_local_s.m)
    z = da_cyl(3) * (da_cyl(2) * (da_cyl(1) * data(n1, m1, p1) + (1.0 - da_cyl(1)) * data(n1, m2, p1)) ...
        + (1.0 - da_cyl(2)) * (da_cyl(1) * data(n2, m1, p1) + (1 - da_cyl(1)) * data(n2, m2, p1))) ...
        + (1.0 - da_cyl(3)) * (da_cyl(2) * (da_cyl(1) * data(n1, m1, p2) + (1.0 - da_cyl(1)) * data(n1, m2, p2)) ...
        + (1.0 - da_cyl(2)) * (da_cyl(1) * data(n2, m1, p2) + (1 - da_cyl(1)) * data(n2, m2, p2)));
end
