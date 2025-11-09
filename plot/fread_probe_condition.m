function pp=fread_condition(f_condition)
pp=zeros(3,3);
fid=fopen(f_condition);
p1=textscan(fid,'%s %s %s %s');
%
p3=find(strcmp(p1{1}, 'num1')==1);
if size(p3) ~= 1
    error('no description of num1!\n');
else
    for a=1:3
    pp(1,a)=str2num(p1{a+1}{p3});
    end
end
%
p3=find(strcmp(p1{1}, 'num2')==1);
if size(p3) ~= 1
    error('no description of num2!\n');
else
    for a=1:3
    pp(2,a)=str2num(p1{a+1}{p3});
    end
end
%
p3=find(strcmp(p1{1}, 'num3')==1);
if size(p3) ~= 1
    error('no description of num1!\n');
else
    for a=1:3
    pp(3,a)=str2num(p1{a+1}{p3});
    end
end
fclose(fid);
return
%
end
     