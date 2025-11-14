function debug_gene_param_eq(data_n, t)
% debug_gene_param_eq(data_n, t)
% 只针对 GENE：
% 1. 用 GENEClass + fread_param2 + fread_EQ1 读 parameters.dat 和 equilibrium
% 2. 把关键标量和 GRC/GZC/GB* 等数组导出到 mat 文件（Octave 兼容）
%
% 例子：
%   debug_gene_param_eq(301, 98.07)

if nargin < 1
    data_n = 301;
end
if nargin < 2
    t = 0.0;
end

% 备份原 path
oldpath = path;

% ---------------- 路径设置（重要）----------------
% 当前文件放在 TDS_class/plot 目录下
% 所以：
%   ../com              : LSview_com, path_matlab.txt 等
%   ../sim_data/GENE    : GENEClass, generate_timedata 等
%   ../sim_data/task_eq : fread_EQ1, fread_EQcod3, fread_EQmag 等

addpath('../com');                 % 确保能找到 GENEClass 里用到的通用函数
addpath('../sim_data/GENE', ...
        '../sim_data/task_eq', ...
        '../sim_data/GENE/plot');

f_path = 'path_matlab.txt';

% ---------------- 构造 GENEClass + generate_timedata ----------------
dataC = GENEClass(f_path, data_n);

if t ~= 0
    GENEdata = sprintf('%sTORUSIons_act_%.0f.dat', dataC.indir, t*100);
    fprintf('GENE generate_timedata: %s, t = %.2f\n', GENEdata, t);
    generate_timedata(dataC, GENEdata, t);
end

% 读取 parameters.dat
fread_param2(dataC);

% 读取 equilibrium（equdata_BZ + equdata_be）
fread_EQ1(dataC);

% ---------------- 标量导出（和 Python 保持同名）----------------
n_spec  = dataC.n_spec;
nx0     = dataC.nx0;
nky0    = dataC.nky0;
nz0     = dataC.nz0;
nv0     = dataC.nv0;
nw0     = dataC.nw0;
kymin   = dataC.kymin;
lv      = dataC.lv;
lw      = dataC.lw;
lx      = dataC.lx;
nexc    = dataC.nexc;

beta    = dataC.beta;
debye2  = dataC.debye2;

q0      = dataC.q0;
shat    = dataC.shat;
trpeps  = dataC.trpeps;
major_R = dataC.major_R;

B_ref   = dataC.B_ref;
T_ref   = dataC.T_ref;
n_ref   = dataC.n_ref;
L_ref   = dataC.L_ref;
m_ref   = dataC.m_ref;

q_ref   = dataC.q_ref;
c_ref   = dataC.c_ref;
omega_ref = dataC.omega_ref;
rho_ref   = dataC.rho_ref;

inside  = dataC.inside;
outside = dataC.outside;
IRMAX   = dataC.IRMAX;
FVER    = dataC.FVER;

Rmax    = dataC.Rmax;
Rmin    = dataC.Rmin;
Zmax    = dataC.Zmax;
Zmin    = dataC.Zmin;

NSGMAX  = dataC.NSGMAX;
NTGMAX  = dataC.NTGMAX;

NRGM    = dataC.NRGM;
NZGM    = dataC.NZGM;
NPHIGM  = dataC.NPHIGM;

DR1     = dataC.DR1;
DR2     = dataC.DR2;
DR3     = dataC.DR3;

B0      = dataC.B0;

% ---------------- 数组导出 ----------------
GRC   = dataC.GRC;
GZC   = dataC.GZC;
GFC   = dataC.GFC;
GAC   = dataC.GAC;
GTC_f = dataC.GTC_f;
GTC_c = dataC.GTC_c;

GBPR_2d = dataC.GBPR_2d;
GBPZ_2d = dataC.GBPZ_2d;
GBTP_2d = dataC.GBTP_2d;
GBPP_2d = dataC.GBPP_2d;

RG1   = dataC.RG1;
RG2   = dataC.RG2;
RG3   = dataC.RG3;

time_int = round(t * 100);
out_name = sprintf('debug_gene_param_eq_ml_%03d_t%04d.mat', data_n, time_int);

% 关键修正：Octave 使用 -v7 格式以确保 scipy.io.loadmat 可以读取
save('-v7', out_name, ...
    'n_spec','nx0','nky0','nz0','nv0','nw0','kymin','lv','lw','lx','nexc', ...
    'beta','debye2','q0','shat','trpeps','major_R', ...
    'B_ref','T_ref','n_ref','L_ref','m_ref', ...
    'q_ref','c_ref','omega_ref','rho_ref', ...
    'inside','outside','IRMAX','FVER', ...
    'Rmax','Rmin','Zmax','Zmin', ...
    'NSGMAX','NTGMAX','NRGM','NZGM','NPHIGM', ...
    'DR1','DR2','DR3','B0', ...
    'GRC','GZC','GFC','GAC','GTC_f','GTC_c', ...
    'GBPR_2d','GBPZ_2d','GBTP_2d','GBPP_2d', ...
    'RG1','RG2','RG3');

fprintf('✅ MATLAB/Octave 侧参数 / EQ 数据已导出到: %s\n', out_name);

% 恢复原 path
path(oldpath);
end
