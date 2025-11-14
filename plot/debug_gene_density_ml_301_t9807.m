function debug_gene_density_ml_301_t9807()
% 调试：调用 GENEClass + fread_data_s，导出 3D 密度数组 p2
%
% 建议在 code/TDS_class/plot 目录下运行：
%   octave --no-gui --eval "debug_gene_density_ml_301_t9807()"

    oldpath = path;

    % ==== 路径设置（参考 LSview_com 和 debug_gene_param_eq）====
    % 1) 先把 ../com 加进去，否则找不到 pathClass
    path('../com', oldpath);
    % 2) 再加 GENE 和 task_eq 相关路径
    addpath('../sim_data/GENE', ...
            '../sim_data/task_eq', ...
            '../sim_data/GENE/plot');

    f_path = 'path_matlab.txt';
    data_n = 301;
    t = 98.07;

    fprintf('========== MATLAB: debug GENE density 3D ==========\n');
    fprintf('data_n = %d, t = %.2f\n', data_n, t);

    % 构造 GENEClass（构造函数里只调用 fread_path）
    dataC = GENEClass(f_path, data_n);

    % ===== 生成 00009807.dat（二进制） =====
    % 和 LSview_com 里完全一致：
    %   GENEdata = sprintf('%sTORUSIons_act_%.0f.dat', dataC.indir, t*100)
    GENEdata = sprintf('%sTORUSIons_act_%.0f.dat', dataC.indir, t*100);
    fprintf('GENEdata (text) = %s\n', GENEdata);

    % 这一步会读取 TORUSIons_act_9807.dat 文本，生成 00009807.dat 二进制
    generate_timedata(dataC, GENEdata, t);

    % 🔴 关键：在 generate_timedata 之后调用 fread_param2
    % 这样才能根据 KYMt / KZMt 正确设置 LYM2 等参数
    fread_param2(dataC);

    fprintf('KYMt = %d, KZMt = %d, LYM2 = %d, nx0 = %d\n', ...
        dataC.KYMt, dataC.KZMt, dataC.LYM2, dataC.nx0);

    % 二进制文件路径（形如 .../00009807.dat）
    bin_file = sprintf('%s%08.0f.dat', dataC.indir, t*100);
    fprintf('binary file = %s\n', bin_file);

    % ===== 用 fread_data_s 读出 3D 数据 =====
    % 函数签名: p2 = fread_data_s(f_n, obj, file)
    % fread_data_s.m 你之前贴过：
    %   rows = obj.KYMt;
    %   data = reshape(..., rows, cols);
    %   data2 = zeros(obj.LYM2 / (obj.KZMt + 1), obj.nx0, obj.KZMt + 1);
    %   for i = 1:(obj.KZMt+1)
    %       data2(:,:,i) = data(400*(i-1)+1:400*i,:);
    %   end
    p2 = fread_data_s(5, dataC, bin_file);     % p2: (ntheta, nx, nz)

    sz = size(p2);
    fprintf('p2 size = [%d, %d, %d]\n', sz(1), sz(2), sz(3));

    % 导出一些元数据（方便 Python 侧 sanity check）
    nx0  = dataC.nx0;
    KYMt = dataC.KYMt;
    KZMt = dataC.KZMt;
    LYM2 = dataC.LYM2;

    % 保存路径：当前 plot 目录
    out_path = './debug_gene_density_ml_301_t9807.mat';
    fprintf('保存到: %s\n', out_path);

    % ⚠️ 关键：强制用 Matlab binary 格式（v5/v7），Scipy 才能读
    save('-mat', out_path, 'p2', 'nx0', 'KYMt', 'KZMt', 'LYM2');

    path(oldpath);

    fprintf('========== MATLAB/Octave: 完成导出 debug_gene_density_ml_301_t9807.mat ==========\n');
end

