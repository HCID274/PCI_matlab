% plot contour for GENE
function cont_data_s(obj,file,ax)

    figure(1)
    p2=fread_data_s(5,obj,file);
    p2=p2(:,:,1);
    p2=[p2; p2(1,:)];
    p2=[p2,zeros(length(p2),1)];
    
    data2=zeros(obj.LYM2/(obj.KZMt+1)+1, obj.nx0+1+obj.inside+obj.outside);
    data2(:,obj.inside+1:end-obj.outside) = p2;
    
    xmesh = zeros(obj.LYM2/(obj.KZMt+1)+1,obj.nx0+obj.inside+obj.outside);
    ymesh = zeros(obj.LYM2/(obj.KZMt+1)+1,obj.nx0+obj.inside+obj.outside);
    for theta2 = 1:obj.LYM2/(obj.KZMt+1)+1
        for R2 = 1:obj.nx0+obj.inside+obj.outside+1
            xmesh(theta2,R2) = -R2*(obj.trpeps*obj.major_R*obj.L_ref/(obj.nx0+obj.inside+obj.outside+1))*cos((2*pi/(obj.LYM2/(obj.KZMt+1)))*(theta2-1)) + obj.major_R*obj.L_ref;
            ymesh(theta2,R2) = -R2*(obj.trpeps*obj.major_R*obj.L_ref/(obj.nx0+obj.inside+obj.outside+1))*sin((2*pi/(obj.LYM2/(obj.KZMt+1)))*(theta2-1));
        end
    end
    
    contourf(xmesh,ymesh,data2,10,'LineStyle','none')
    xlabel('R');
    ylabel('Z');
    axis square
    colorbar;
    
end