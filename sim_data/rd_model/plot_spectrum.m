% plot spectrum
function plot_spectrum(obj,p2,fn)
% obj,data, field#
%
switch fn
    case 4 % DENS
        coef=1/(obj.BETAI+obj.BETAE);
    case 5 % TEME
        coef=1.5/obj.BETAI;
    otherwise
        coef=1.0;
end
%
dr=zeros(obj.IRMAX+1,1);
dr(1:end-1)=obj.R(2:end)-obj.R(1:end-1);
ss=squeeze(sum(p2(:,:,:,fn).*conj(p2(:,:,:,fn)).*repmat(obj.R.*dr,1,obj.LYM2,obj.LZM2),1));
ss2=zeros(obj.LYM2,obj.LZM2);
ss2(obj.KYM:end,:)=ss(1:obj.KYM+1,:);
ss2(1:obj.KYM-1,:)=ss(obj.KYM+2:end,:);
ss2(1:obj.KYM-1,1)=ss([obj.KYM:-1:2],1);
[x,y]=meshgrid([-obj.KYM+1:obj.KYM],[0:obj.KZM]);
contourf(x,y,log10(ss2.'),30,'LineStyle','none');
shading flat;
title('spectrum');
xlabel('m');
ylabel('n');
axis tight
colorbar
%
end
