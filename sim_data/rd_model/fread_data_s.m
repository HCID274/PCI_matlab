% read data file
function p2=fread_data_s(f_n,obj,file)
% field#,obj,file name, mode m,n
fid=fopen(file,'r',obj.endian);
RET=fread(fid,1,'int');
%
data1=fread(fid,2*(obj.IRMAX+1)*obj.LYM2*obj.LZM2*f_n,'double');
data1=reshape(data1,2,obj.IRMAX+1,obj.LYM2,obj.LZM2,f_n);
data1(:,:,obj.KYM+2:end,1,:)=0.0;
p2=squeeze(data1(1,:,:,:,:)+i*data1(2,:,:,:,:));% complex
%
fclose(fid);
end
