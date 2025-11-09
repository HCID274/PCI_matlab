function frequency(sim,data_n,var)
    
    oldpath=path;
    path('../com',oldpath);
    f_path='path.txt';
    %
    switch sim
        case {'GENE', 'gene'}
            FVER=5;
            oldpath=addpath('../sim_data/GENE','../sim_data/task_eq','../sim_data/GENE/plot');
            dataC=GENEClass(f_path,data_n);
        otherwise
            error('Unexpected simulation type.')
    end

    % ファイル名を指定
    filename = sprintf('%sFREQUENCY_act.dat', dataC.indir)

    % データ読み込み用の変数を初期化
    data = [];

    % ファイルを開いて読み込む
    fid = fopen(filename, 'r');
    if fid == -1
        error('ファイルが開けませんでした。');
    end

    % 行を1行ずつ読み込んで処理
    while ~feof(fid)
        line = fgetl(fid);
        
        % 空行やヘッダ行をスキップ
        if isempty(line) || startsWith(line, '#')
            continue;
        end
        
        % 数値データの行を検出して解析
        numeric_data = sscanf(line, '%f %f %f %f %f');
        if numel(numeric_data) == 5
            data = [data; numeric_data']; % データ行を追加
        end
    end

    % ファイルを閉じる
    fclose(fid);

    % データが空でないかチェック
    if isempty(data)
        error('データが読み込まれませんでした。');
    end

    % 列を分割
    ky = data(:, 1);
    gamma = data(:, 2);
    omega = data(:, 3);
    g_err = data(:, 4);
    o_err = data(:, 5);

    % データをプロット
    figure(10000)
    errorbar(ky, gamma, g_err, 'o-', 'LineWidth', 1.5);
    xlabel('ky');
    ylabel('\gamma');
    title('ky vs \gamma');
    grid on;

    figure(10001)
    errorbar(ky, omega, o_err, 'o-', 'LineWidth', 1.5);
    xlabel('ky');
    ylabel('\omega');
    title('ky vs \omega');
    grid on;


    path(oldpath);

end