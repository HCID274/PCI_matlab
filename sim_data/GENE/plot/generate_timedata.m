% generate 00******.dat data from GENE data
function generate_timedata(obj, file, t)
    % Open the file for reading
    fid = fopen(file, 'r');
    
    % Read the entire file content ignoring lines that start with '#'
    fileContent = textscan(fid, '%s', 'Delimiter', '\n');
    fclose(fid);
    
    % Filter out lines that start with '#'
    validLines = fileContent{1}(~startsWith(fileContent{1}, '#'));
    
    % Parse the valid lines into a numeric array
    data = cellfun(@(line) sscanf(line, '%f')', validLines, 'UniformOutput', false);
    data = cell2mat(data);
    
    % Ensure the data is of type double
    data = double(data);
    
    [rows, cols] = size(data);
    
    % Update object properties
    obj.KYMt = rows;
    obj.KZMt = rows / 400-1; % 400 is poloidal mesh number
    
    % Generate filename
    new_filename = sprintf('%08d.dat', round(t*100))
    path = fullfile(obj.indir, new_filename);
    
    % Open the file for writing in binary mode
    fid = fopen(path, 'w');
    
    % Write data to file in binary format
    fwrite(fid, data, 'double'); % Do not transpose data here
    
    % Close the file
    fclose(fid);
end