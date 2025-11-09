% read data file
function p2=fread_data_1(f_n,obj,file,m,n)
% field#,obj,file name, mode m,n
p2=zeros(obj.IRMAX+1,f_n);
fid=fopen(file,'r',obj.endian);
RET=fread(fid,1,'int');
L=find(obj.LKY==m & obj.LKZ==n);
if (size(L,1)==0)
    return
end
%
for a=1:f_n
%skip data
if a==1
    TMP=fread(fid,(obj.IRMAX+1)*(L-1)*2,'double');
else
    TMP=fread(fid,(obj.IRMAX+1)*obj.LMAX*2,'double');
end
data1=fread(fid,[2,obj.IRMAX+1],'double');
p2(:,a)=squeeze(data1(1,:)+i*data1(2,:));% complex
end    
%
IROUT=128;
pout=p2(1:fix(end/IROUT):end,:);
pout2=[real(pout);imag(pout)];
str=sprintf('%sFVN.dat',obj.outdir);
dlmwrite(str,pout2.','\t');
%
fclose(fid);
end
