% read plasma variables from Fourier decomposition
function fread_plasma1(obj,t)
%
%
str=sprintf('%s%08d.dat',obj.indir,t*100)
fid=fopen(str,'r',obj.endian);
RET=fread(fid,1,'int');
data1=fread(fid,[2,(obj.IRMAX+1)*(obj.LMAX+1)],'double');%PHI
data1=reshape(data1,2,obj.IRMAX+1,obj.LMAX+1);
for L=1:obj.LMAX+1
    if (obj.LKY(L)==0 && obj.LKZ(L)==0)
%        data1(:,:,L)=0.0;
        data1(:,:,L)=0.5*data1(:,:,L);
    end
end
%data2=squeeze(data1(1,:,:)+i*data1(2,:,:));
%obj.PHI=data2;
obj.PHI=squeeze(data1(1,:,:)+i*data1(2,:,:));
%obj.PHI=squeeze(data1(1,:,:)+i*data1(2,:,:)*0);
%
data1=fread(fid,[2*2,(obj.IRMAX+1)*(obj.LMAX+1)],'double');%A,V
data1=fread(fid,[2,(obj.IRMAX+1)*(obj.LMAX+1)],'double');%P -> n
data1=reshape(data1,2,obj.IRMAX+1,obj.LMAX+1);
for L=1:obj.LMAX+1
    if (obj.LKY(L)==0 && obj.LKZ(L)==0)
%        data1(:,:,L)=0.0;
        data1(:,:,L)=0.5*data1(:,:,L);
    end
end
%data2=squeeze(data1(1,:,:)+i*data1(2,:,:));
%obj.NE=data2;
obj.NE=squeeze(data1(1,:,:)+i*data1(2,:,:));
%obj.NE=squeeze(data1(1,:,:)+i*data1(2,:,:)*0);
%obj.NE(:,2:end)=0;
obj.NEt=obj.NE.';
%
obj.TE=obj.NE*0.0;
obj.TE(:,1)=obj.TEtmp*0.5;
obj.TEt=obj.TE.';
%obj.PHI(:,2:end)=0;
obj.PHI=obj.PHI*obj.PHInorm;% unit[eV]
obj.PHIt=obj.PHI.';
obj.PHIt_re=real(obj.PHIt);
obj.PHIt_im=imag(obj.PHIt);
%
end