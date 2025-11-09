% plot spectrum
function plot_spectrum_d(obj,p2,fn)
% obj,data, field#
%
coef=1.0;
%
dr=zeros(obj.IRMAX+1,1);
dr(1:end-1)=obj.R(2:end)-obj.R(1:end-1);
p2_d=zeros(obj.IRMAX+1,obj.LYM2,obj.LZM2);
p2_d(2:end-1,:,:)=(-p2(1:end-2,:,:,fn)+p2(3:end,:,:,fn))./repmat(-obj.R(1:end-2)+obj.R(3:end),1,obj.LYM2,obj.LZM2);
p2_m=squeeze(p2(:,:,:,fn)).*repmat(reshape(obj.LKY,1,obj.LYM2,obj.LZM2),obj.IRMAX+1,1,1);
ss=p2_d(:,:,:).*conj(p2_d(:,:,:)).*repmat(obj.R.*dr,1,obj.LYM2,obj.LZM2) ...
    +p2_m(:,:,:).*conj(p2_m(:,:,:)).*repmat(dr,1,obj.LYM2,obj.LZM2);
ss=coef*squeeze(sum(ss,1));
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
