%display the detection position
function LS_location(obj,x,y,z,div1,div2,div3)

    r = (x.^2 + y.^2).^(1/2);
    R = reshape(r,div1,div2,div3);
    Z = reshape(z,div1,div2,div3);
    
    zls_b=repmat(obj.GZC(end,:).',1,31);
    %
    figure(5)
    plot(obj.GRC(end,:),zls_b,'k-');
    axis equal;
    hold on
    
    for i = 1:div3
        plot(R((div1+1)/2,:,i),Z((div1+1)/2,:,i),'r.')
        title('beam path')
    end
    hold off
end