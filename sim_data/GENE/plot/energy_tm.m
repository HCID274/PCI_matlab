% plot time evolution of mode energy
function energy_tm(sim,data_n)
% simulation type: 1(NLD),2(DISA),3(R4F),3.5(R5F)
% data#
%
oldpath=path;
path('../com',oldpath);
f_path='path.txt';
%
dataC=pathClass;
fread_path(dataC,f_path,data_n);
%switch sim
%    case {'R5F', 'r5f'}
%        FVER=3.5;
%        dataC=r5fClass(f_path,data_n);
%    otherwise
%        error('Unexpected simulation type.')
%end
%
% parameters
%fread_param2(dataC);
%if(FVER ~= dataC.FVER)
%         error('Simulation type mismatch (PARAM).')
%end  
clf;
SK=1;%size of RET, 1 for JFRS, 2 for PS(SX-AURORA)
%
HIST='HISTORY.DAT';
str=sprintf('%s%s',dataC.indir,HIST)
fid=fopen(str,'r',dataC.endian);
RET=fread(fid,1*SK,'int');%return key
IRMAX=fread(fid,1,'int')
KYM=fread(fid,1,'int')
LZM=fread(fid,1,'int')
%
num_m=10;
%
IEDMG=10000;
TTENR=zeros(IEDMG,1);
EMDPHI=zeros(IEDMG,1);
EMDPSI=zeros(IEDMG,1);
EMCUR=zeros(IEDMG,1);
EMVPL=zeros(IEDMG,1);
EMDENS=zeros(IEDMG,1);
EMTEME=zeros(IEDMG,1);
EMTEMI=zeros(IEDMG,1);
EMPRE=zeros(IEDMG,1);
EDPHI=zeros(KYM,LZM,IEDMG);
EDPSI=zeros(KYM,LZM,IEDMG);
ECUR=zeros(KYM,LZM,IEDMG);
EVPL=zeros(KYM,LZM,IEDMG);
EDENS=zeros(KYM,LZM,IEDMG);
ETEME=zeros(KYM,LZM,IEDMG);
ETEMI=zeros(KYM,LZM,IEDMG);
EPRE=zeros(KYM,LZM,IEDMG);
TENR=zeros(KYM,LZM,IEDMG);
%
RET=fread(fid,2*SK,'int');%return key
a=1;
%for b=1:550
while ~feof(fid)
%RET=fread(fid,1,'int');%return key
TTENR(a)=fread(fid,1,'double');
[a,TTENR(a)]
EMDPHI(a)=fread(fid,1,'double');
EMDPSI(a)=fread(fid,1,'double');
EMCUR(a)=fread(fid,1,'double');
EMVPL(a)=fread(fid,1,'double');
EMDENS(a)=fread(fid,1,'double');
EMTEME(a)=fread(fid,1,'double');
EMTEMI(a)=fread(fid,1,'double');
EMPRE(a)=fread(fid,1,'double');
tmp=fread(fid,KYM*LZM*9,'double');
tmp2=reshape(tmp,9,KYM,LZM);
EDPHI(:,:,a)=squeeze(tmp2(1,:,:));
EDPSI(:,:,a)=squeeze(tmp2(2,:,:));
ECUR(:,:,a)=squeeze(tmp2(3,:,:));
EVPL(:,:,a)=squeeze(tmp2(4,:,:));
EDENS(:,:,a)=squeeze(tmp2(5,:,:));
ETEME(:,:,a)=squeeze(tmp2(6,:,:));
ETEMI(:,:,a)=squeeze(tmp2(7,:,:));
EPRE(:,:,a)=squeeze(tmp2(8,:,:));
TENR(:,:,a)=squeeze(tmp2(9,:,:));
RET=fread(fid,2*SK,'int');%return key
a=a+1;
end
fclose(fid);
num=a-1;
%
plot(TTENR(1:num),log10(EMDPHI(1:num)),'DisplayName','EMDPHI','Linewidth',2);
hold on
plot(TTENR(1:num),log10(EMDPSI(1:num)),'DisplayName','EMDPSI','Linewidth',2);
plot(TTENR(1:num),log10(EMCUR(1:num)),'DisplayName','EMCUR','Linewidth',2);
plot(TTENR(1:num),log10(EMVPL(1:num)),'DisplayName','EMVPL','Linewidth',2);
plot(TTENR(1:num),log10(EMDENS(1:num)),'DisplayName','EMDENS','Linewidth',2);
plot(TTENR(1:num),log10(EMTEME(1:num)),'DisplayName','EMTEME','Linewidth',2);
plot(TTENR(1:num),log10(EMTEMI(1:num)),'DisplayName','EMTEMI','Linewidth',2);
plot(TTENR(1:num),log10(EMPRE(1:num)),'DisplayName','EMPRE','Linewidth',2);
axis tight
hold off
set(gca,'FontSize',14);
xlabel('time','FontSize',20);
ylabel('energy','FontSize',20);
legend('show')
legend('Location','eastoutside')
pause
LKY=reshape(repmat([0:KYM/2,-KYM/2+1:-1].',1,LZM),KYM*LZM,1);
LKZ=reshape(repmat([0:LZM-1],KYM,1),KYM*LZM,1);
%AA=reshape(EDPHI(:,:,1:num),KYM*LZM,num);
AA=reshape(EDENS(:,:,1:num),KYM*LZM,num);
num_sort=num-1;
AA2=AA(:,num_sort);
[Amax,Aid]=sort(AA2,'descend');
str=sprintf('%d%s%d',LKY(Aid(1)),'\_',LKZ(Aid(1)));
plot(TTENR(1:num),log10(AA(Aid(1),1:num)),'DisplayName',str,'Linewidth',2);
%str=sprintf('%d%s%d',LKY(1),'\_',LKZ(1));
%plot(TTENR(1:num),log10(AA(1,1:num)),'DisplayName',str,'Linewidth',2);
hold on
for a=2:num_m
str=sprintf('%d%s%d',LKY(Aid(a)),'\_',LKZ(Aid(a)));
plot(TTENR(1:num),log10(AA(Aid(a),1:num)),'DisplayName',str,'Linewidth',2);
axis tight
end
set(gca,'FontSize',14);
xlabel('time','FontSize',20);
ylabel('energy','FontSize',20);
legend('show')
legend('Location','eastoutside')
pause
num_sort=fix(num/2);
[num_sort num]
AA2=AA(:,num_sort);
[Amax,Aid]=sort(AA2,'descend');
str=sprintf('%d%s%d',LKY(Aid(1)),'\_',LKZ(Aid(1)));
plot(TTENR(1:num),log10(AA(Aid(1),1:num)),'DisplayName',str,'Linewidth',2);
%str=sprintf('%d%s%d',LKY(1),'\_',LKZ(1));
%plot(TTENR(1:num),log10(AA(1,1:num)),'DisplayName',str,'Linewidth',2);
for a=2:num_m
str=sprintf('%d%s%d',LKY(Aid(a)),'\_',LKZ(Aid(a)));
plot(TTENR(1:num),log10(AA(Aid(a),1:num)),'DisplayName',str,'Linewidth',2);
axis tight
end
set(gca,'FontSize',14);
xlabel('time','FontSize',20);
ylabel('energy','FontSize',20);
legend('off')
legend('show')
legend('Location','eastoutside')
hold off
pause
%
AA=squeeze(sum(EDENS(:,:,1:num),1));
num1=14;
plot(TTENR(1:num),log10(AA(1:num1,:)).','Linewidth',2);
%hold on
%AA_total=sum(AA,1);
%plot(TTENR(1:num),log10(AA_total),'Linewidth',2);
%hold off
axis tight
set(gca,'FontSize',14);
xlabel('time','FontSize',20);
ylabel('energy','FontSize',20);
%legend('off')
%legend('show')
%legend('Location','eastoutside')
pause
%plot([0:num1-1],log10(AA(:,num)),'Linewidth',2);
plot([0:num1-1],log10(AA(1:num1,:)),'Linewidth',2);
%
%t_s=500;
%t_e=1000;
t_s=input('linear fit, from = ');
t_e=input('to = ');
GL=zeros(LZM,1);
for a=1:LZM
p=polyfit(TTENR(t_s:t_e),log(AA(a,t_s:t_e).'),1);
GL(a)=p(1)/2;
end
plot([0:LZM-1],GL,'o-','Linewidth',2)
axis tight
set(gca,'FontSize',14);
xlabel('toroidal modenumber','FontSize',20);
ylabel('Growthrate','FontSize',20);
%
end
