% read 'ptprflist.dat' file including a profile list
function fread_ptprflist(obj)
file='ptprflist.dat';
str=strcat(obj.indir,file);
fid=fopen(str,'r',obj.endian);
%RET,TIME,RET,RET,TIME,RET,...
[TIME_T,COUNT]=fread(fid,'int');
obj.COUNT=COUNT/3;
obj.TIME=TIME_T(2:3:end);
obj.TS=min(obj.TIME);
obj.TE=max(obj.TIME);
fclose(fid);
end