% run_probe_debug_ml.m
% 使用 Python 导出的 debug mat，在 Octave 端算一次 probeEQ_local_s

function run_probe_debug_ml()
    % 建议在 Python 的 output 目录里运行本脚本
    % 比如: cd /work/DTMP/lhqing/PCI/Data/python_output/test_single  (按你 paths.json 的配置)

    % 使用绝对路径或相对于当前目录的路径
    debug_mat_path = '/work/DTMP/lhqing/PCI/Data/python_output/test_single/probe_debug_py.mat';
    
    if ~exist(debug_mat_path, 'file')
        error('找不到 probe_debug_py.mat，请先运行 Python 端的 run_pci.py 生成该文件。\n路径: %s', debug_mat_path);
    end

    data = load(debug_mat_path);

    processed_density_field_py = data.processed_density_field_py;
    PA    = data.PA;
    GAC   = data.GAC;
    GTC_c = data.GTC_c;
    KZMt  = double(data.KZMt);   % 防止是 int32，先转 double

    R0    = data.R_debug;
    Z0    = data.Z_debug;
    PHI0  = data.PHI_debug;
    z_py  = data.z_py;

    fprintf('=== Octave 单点插值调试 ===\n');
    fprintf('  读取 Python 导出的探针点:\n');
    fprintf('    R0   = %.10f\n', R0);
    fprintf('    Z0   = %.10f\n', Z0);
    fprintf('    PHI0 = %.10f\n', PHI0);

    % 在 Octave 端用同一套 data / equilibrium 计算
    z_ml = probeEQ_local_s_debug(PA, GAC, GTC_c, KZMt, R0, Z0, PHI0, processed_density_field_py);

    fprintf('\n插值结果:\n');
    fprintf('  z_py(from mat) = %.16e\n', z_py);
    fprintf('  z_ml           = %.16e\n', z_ml);
    fprintf('  abs diff       = %.16e\n', abs(z_ml - z_py));

    % 保存成单独的 mat（注意：不用 v7.3）
    output_mat_path = '/work/DTMP/lhqing/PCI/Data/python_output/test_single/probe_debug_ml.mat';
    save(output_mat_path, 'z_ml', '-v7');
    fprintf('\n已保存 z_ml 到 %s (v7 格式)\n', output_mat_path);
end
