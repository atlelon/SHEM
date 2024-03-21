function [u]=solveHierBnd(coord, h,bl,level,nodes,s)
    t = s.MESH.fine.t;
    [mb, nb]=size(coord);
    centr=ones([mb nb]);
    centr(1,:)=centr(1,:).*bl(1);
    centr(2,:)=centr(2,:).*bl(2);
    [~, I]=sort(sqrt(sum((centr-coord).^2,1)));
    elements = zeros(nb-1,2);
    val      = zeros(nb-1,1);
    
    for i=1:nb-1
        elements(i,1) = I(i);
        elements(i,2) = I(i+1);
        elnum         = node2element(s.MESH.tri,nodes(elements(i,:)))';
        val(i)        = max(s.rho(elnum));
    end
    u         = zeros(nb,1);
    nElements = size(elements,1);
    A         = sparse(nb,nb);
    dirinodes = [I(1) I(end)];
    
    M=zeros(nb);
    for i=1:nElements
    
        M(elements(i,:),elements(i,:))=M(elements(i,:),elements(i,:))+h*val(i)*1/6*[2 1; 1 2];
        for j=1:2
            for k=1:2
                if j==k
                    A(elements(i,j),elements(i,k)) = A(elements(i,j),elements(i,k)) + 1/(h/val(i));
                else
                    A(elements(i,j),elements(i,k)) = A(elements(i,j),elements(i,k)) - 1/(h/val(i));
                end
            end
        end
    
    end
    
    mdPnt = (nb-1)/2^level;
    for i=0:2:2^level-1
        ee(mdPnt*i+1:mdPnt*(i+1)+1) = linspace(0,1,mdPnt+1);
        ee(mdPnt*(i+1)+2:mdPnt*(i+2)+1) = ee(mdPnt:-1:1);
    end
    ee(I)=ee;
    
    ee=M*ee';
    freeNodes=setdiff(1:nb,dirinodes);
    u(freeNodes)=A(freeNodes,freeNodes)\ee(freeNodes);

end