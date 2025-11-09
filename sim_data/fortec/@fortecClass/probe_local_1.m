% local value of data1(step 2)
% one point
%
function pcs=probe_local_1(obj,poid,aw,bw,cw,data)
%poid2(2,2,2),aw(2,2),bw(2),cw,data(num2,num3,num1)
%
if (poid(1,1,1) == 0)
    pcs=0;
    return
end
data1=zeros(2,2);
data2=zeros(2,1);
for c=1:2
    for b=1:2
        data1(b,c)=data(poid(b,c,1))*(1.0-aw(b,c))+data(poid(b,c,2))*aw(b,c);
    end
    data2(c)=data1(1,c)*(1.0-bw(c))+data1(2,c)*bw(c);
end
pcs=data2(1)*(1.0-cw)+data2(2)*cw;
return
end
