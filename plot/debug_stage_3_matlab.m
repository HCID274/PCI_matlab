function debug_stage_3_matlab()
% 调试 Stage 3：光束几何
% 只依赖 LS_condition_JT60SA.txt，不依赖 GENE 数据
%
% 输出:
%   debug_stage_3_matlab.mat，包含:
%     - beam_grid_3d : (div1_2, div2_2, divls_2, 3)
%     - B2           : 2x3  (B2(1,:)=注入点, B2(2,:)=探测器)
%     - p1           : 3x1  (B2(1,:)-B2(2,:))
%     - xl           : 2x3  垂直向量
%     - div1, div2, divls, wid1, wid2

    f_condition = './LS_condition_JT60SA.txt';

    % 和 LSview_com 完全一致的读法
    A = importdata(f_condition, ',', 5);
    if iscell(A)
        data1 = sscanf(A{1}, '%f,');
        data2 = sscanf(A{2}, '%f,');
        data3 = sscanf(A{3}, '%f,');
        pp1  = data1;
        wid1 = data2(1);
        wid2 = data2(2);
        div1 = data3(1);
        div2 = data3(2);
        divls= data3(3);
    else
        pp1  = A.data(1,:);
        wid1 = A.data(2,1);
        wid2 = A.data(2,2);
        div1 = A.data(3,1);
        div2 = A.data(3,2);
        divls= A.data(3,3);
    end

    B1 = zeros(2,3);
    xl = zeros(2,3);
    p1 = zeros(3,1);

    B1(1,:) = pp1(1:3);  % (R,Z,phi)
    B1(2,:) = pp1(4:6);

    % (R,Z,phi) -> (X,Y,Z), 再 /1000 变为 m
    B2 = zeros(2,3);
    B2(:,1) = B1(:,1) .* cos(2*pi*B1(:,3));
    B2(:,2) = B1(:,1) .* sin(2*pi*B1(:,3));
    B2(:,3) = B1(:,2);
    B2 = B2 / 1000.0;  % mm -> m

    % 光束矢量
    p1(1) = B2(1,1) - B2(2,1);
    p1(2) = B2(1,2) - B2(2,2);
    p1(3) = B2(1,3) - B2(2,3);

    % 垂直向量
    if (p1(1) == 0 && p1(2) == 0)
        xl(1,1) = wid1/2.0 * cos(2*pi*B1(1,3));
        xl(1,2) = wid1/2.0 * sin(2*pi*B1(1,3));
        xl(1,3) = 0.0;
        xl(2,1) = -wid2/2.0 * sin(2*pi*B1(1,3));
        xl(2,2) =  wid2/2.0 * cos(2*pi*B1(1,3));
        xl(2,3) = 0.0;
    else
        xl(1,1) = p1(3);
        xl(1,2) = p1(3) * tan(2*pi*B1(1,3));
        xl(1,3) = -(p1(1) + p1(2) * tan(2*pi*B1(1,3)));
        xl0 = 1.0/sqrt(xl(1,1)^2+xl(1,2)^2+xl(1,3)^2)*wid1/2.0;
        xl(1,:) = xl(1,:) * xl0;

        xl(2,1) = p1(1)*p1(2) + (p1(2)^2 + p1(3)^2) * tan(2*pi*B1(1,3));
        xl(2,2) = -p1(1)^2 - p1(3)^2 - p1(1)*p1(2) * tan(2*pi*B1(1,3));
        xl(2,3) = p1(2)*p1(3) - p1(1)*p1(3) * tan(2*pi*B1(1,3));
        xl0 = 1.0/sqrt(xl(2,1)^2+xl(2,2)^2+xl(2,3)^2)*wid2/2.0;
        xl(2,:) = xl(2,:) * xl0;
    end

    % 网格参数
    divls_2 = divls + 1;
    div1_2  = 2*div1 + 1;
    div2_2  = 2*div2 + 1;

    replix = zeros(div1_2, div2_2, divls_2);
    xls    = ones(div1_2, div2_2, divls_2) * B2(2,1);
    yls    = ones(div1_2, div2_2, divls_2) * B2(2,2);
    zls    = ones(div1_2, div2_2, divls_2) * B2(2,3);

    % div1 方向
    for j = 1:div1_2
        replix(j,:,:) = ones(div2_2, divls_2) * ( (j-1) - div1 ) / div1;
    end
    xls = xls + replix * xl(1,1);
    yls = yls + replix * xl(1,2);
    zls = zls + replix * xl(1,3);

    % div2 方向
    for j = 1:div2_2
        replix(:,j,:) = ones(div1_2, divls_2) * ( (j-1) - div2 ) / div2;
    end
    xls = xls + replix * xl(2,1);
    yls = yls + replix * xl(2,2);
    zls = zls + replix * xl(2,3);

    % 光束方向
    for j = 1:divls_2
        replix(:,:,j) = ones(div1_2, div2_2) * (j-1) / divls;
    end
    xls = xls + replix * p1(1);
    yls = yls + replix * p1(2);
    zls = zls + replix * p1(3);

    % 组合成 (div1_2, div2_2, divls_2, 3)
    beam_grid_3d = cat(4, xls, yls, zls);

    save('debug_stage_3_matlab.mat', ...
         'beam_grid_3d', 'B2', 'p1', 'xl', ...
         'div1', 'div2', 'divls', 'wid1', 'wid2', '-v7');

    fprintf('debug_stage_3_matlab.mat 已生成，形状: (%d, %d, %d, 3)\n', ...
            div1_2, div2_2, divls_2);
end
