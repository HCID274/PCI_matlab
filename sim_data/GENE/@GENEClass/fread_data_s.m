% read data file
function p2 = fread_data_s(f_n, obj, file)
    % Open the file in binary read mode
    fid = fopen(file, 'r');
    data = fread(fid, 'double');
    fclose(fid);
    
    total_elements = length(data);
    rows = obj.KYMt;
    cols = total_elements / rows;

    data = reshape(data, rows, cols);
    
    data2 = zeros(obj.LYM2 / (obj.KZMt + 1), obj.nx0, obj.KZMt + 1);
    
    % Fill the output array with the appropriate slices of data
    for i = 1:(obj.KZMt+1)
        data2(:,:,i) = data(400*(i-1)+1:400*i,:);
    end
    
    p2 = data2;
end





