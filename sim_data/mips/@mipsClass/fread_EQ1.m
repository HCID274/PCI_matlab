% read 'PARAM.dat', including simulation parameters
function fread_EQ1(obj)
f_EQcod='equdata_BZ';
f_EQmag='equdata_be';
%
fread_EQcod3(obj,f_EQcod);
fread_EQmag(obj,f_EQmag);
end