function yc=bisec(xx,data)
[m1,n1]=size(data);
m=max(m1,n1);
%
if (data(1)<data(m))
    ya=1;
    yb=m;
else
    ya=m;
    yb=1;
end
%{
if (data(ya)>xx || data(yb)<xx)
    yc=[0;0];
    return
end
%}
for k=1:40
    yt=round((ya+yb)/2.0);
    ymid=data(yt);
    if (ymid<=xx)
        ya=yt;
    else
        yb=yt;
    end
    if (abs(ya-yb)<=1)
        yc=[ya; yb];
        return 
    end
end
yc=[0;0];
return
end
