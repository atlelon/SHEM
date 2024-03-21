function [u]=solveAltBnd(coord, h,bl,level,nodes,s)
    
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
    d         = zeros(nb,1);
    nElements = size(elements,1);
    dd        = ones(nElements,1);
    A         = sparse(nb,nb);
    dirinodes = [I(1) I(end)];
    
    tt=splitInterface(1:nElements,level);
    for i=2:2:level
        dd(tt{:,i})=-dd(tt{:,i});
    end
    for i=1:nElements
        for j=1:2
            for k=1:2
                if j==k
                    A(elements(i,j),elements(i,k)) = A(elements(i,j),elements(i,k)) + 1/(h/val(i));
                else
                    A(elements(i,j),elements(i,k)) = A(elements(i,j),elements(i,k)) - 1/(h/val(i));
                end
            end
    
        end
        d(elements(i,:))=d(elements(i,:))+1/2*val(i)*dd(i)*h;
    end
    freeNodes=setdiff(1:nb,dirinodes);
    u(freeNodes)=A(freeNodes,freeNodes)\d(freeNodes);
    end
    
    function parts = splitInterface(v, n)
    
    parts = cell(1,n);
    
    nb = numel(v);
    segmentSize = 1/n*nb;
    for i = 1:n
        idxs = (floor(round((i-1)*segmentSize)):floor(round((i)*segmentSize))-1)+1;
        parts{i} = v(idxs);
    end

end