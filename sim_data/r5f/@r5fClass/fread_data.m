% plot mode structure
function fread_data(obj,p2)% file name, mode m,n
%
%PHI
subplot(221);
plot(obj.R,real(datac),'r',obj.R,imag(datac),'b');
title('PHI');
xlabel('r');
axis tight
legend('Real','Imag','Location','Best')
pout=datac(1:fix(end/IROUT):end);
pout2=[obj.R(1:fix(end/IROUT):end).';real(pout);imag(pout)];
TMP=fread(fid,(obj.IRMAX+1)*((obj.KYM)*(obj.LZM)-1)*2,'double');
%
%PSI
data1=fread(fid,[2,obj.IRMAX+1],'double');
datac=data1(1,:)+i*data1(2,:);% complex
subplot(222);
plot(obj.R,real(datac),'r',obj.R,imag(datac),'b');
title('PSI');
xlabel('r');
axis tight
legend('Real','Imag','Location','Best')
pout=datac(1:fix(end/IROUT):end);
pout2=[obj.R(1:fix(end/IROUT):end).';real(pout);imag(pout)];
TMP=fread(fid,(obj.IRMAX+1)*((obj.KYM)*(obj.LZM)-1)*2,'double');
%
%VPL
data1=fread(fid,[2,obj.IRMAX+1],'double');
datac=data1(1,:)+i*data1(2,:);% complex
subplot(223);
plot(obj.R,real(datac),'r',obj.R,imag(datac),'b');
title('VPL');
xlabel('r');
axis tight
pout=datac(1:fix(end/IROUT):end);
pout2=[pout2;real(pout);imag(pout)];
TMP=fread(fid,(obj.IRMAX+1)*((obj.KYM)*(obj.LZM)-1)*2,'double');
%
%NE
data1=fread(fid,[2,obj.IRMAX+1],'double');
datac=data1(1,:)+i*data1(2,:);% complex
subplot(223);
plot(obj.R,real(datac),'r',obj.R,imag(datac),'b');
title('NE');
xlabel('r');
axis tight
pout=datac(1:fix(end/IROUT):end);
pout2=[pout2;real(pout);imag(pout)];
TMP=fread(fid,(obj.IRMAX+1)*((obj.KYM)*(obj.LZM)-1)*2,'double');
%
%TE
data1=fread(fid,[2,obj.IRMAX+1],'double');
datac=data1(1,:)+i*data1(2,:);% complex
subplot(224);
plot(obj.R,real(datac),'r',obj.R,imag(datac),'b');
title('TE');
xlabel('r');
axis tight
pout=datac(1:fix(end/IROUT):end);
pout2=[pout2;real(pout);imag(pout)];
%
pause
%NEQ
frewind(fid);
RET=fread(fid,1,'int');
TMP=fread(fid,(obj.IRMAX+1)*(obj.KYM)*(obj.LZM)*6,'double');
data1=fread(fid,[2,obj.IRMAX+1],'double');
datac=data1(1,:)+i*data1(2,:)+obj.DENSQ.';% complex
subplot(222);
plot(obj.R,real(datac));
title('NEQ');
xlabel('r');
axis tight
%
%nVr
datac2=zeros(1,size(pout2,2));
datac2(2:end)=-2.0*(pout2(8,2:end)+i*pout2(9,2:end))...
    *(i*m)./pout2(1,2:end).*(pout2(2,2:end)-i*pout2(3,2:end));
datac2(1)=0;
pout2=[pout2;real(datac2)];
%str=sprintf('%sflux.dat',outdir);
%dlmwrite(str,real(datac2), '-append');
subplot(224);
plot(pout2(1,:),real(datac2));
axis tight
title('flux');
xlabel('r');
%axis([0,1,0,5]);
%
str=sprintf('%sFVN.dat',obj.outdir);
dlmwrite(str,pout2.','\t');
%
fclose(fid);
%
end
