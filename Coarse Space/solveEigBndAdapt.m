function [u]=solveEigBndAdapt(coord, h,bl,nodes,s)
    
    [mb, nb]=size(coord);
    centr=ones([mb nb]);
    centr(1,:)=centr(1,:).*bl(1);
    centr(2,:)=centr(2,:).*bl(2);
    [~, I]=sort(sqrt(sum((centr-coord).^2,1)));
    elements = zeros(nb-1,2);
    val      = zeros(nb-1,1);
    M=zeros(nb);
    for i=1:nb-1
        elements(i,1) = I(i);
        elements(i,2) = I(i+1);
        elnum         = node2element(s.MESH.tri,nodes(elements(i,:)))';
        val(i)        = sum(s.rho(elnum)); % sum better than max it seems.
        elnum2        = node2elementAll(s.MESH.tri,nodes(elements(i,2)))';
        valb          = sum(s.rho(elnum2));    

        % l2 Mass matrix assembly
        M(I(i+1),I(i+1)) = M(I(i+1),I(i+1))+valb/h;

    end
    u         = [];
    nElements = size(elements,1);
    A         = sparse(nb,nb);
    dirinodes = [I(1) I(end)];
    freeNodes = setdiff(1:nb,dirinodes);
    H=norm(coord(:,I(1))-coord(:,I(end)));
    
    for i=1:nElements

        % L2Mass matrix assembly
        % M(elements(i,:),elements(i,:))=M(elements(i,:),elements(i,:))+h*val(i)*1/6*[2 1; 1 2];

        % Stiffness matrix. Did not have time to vectorize this part should
        % be fairly simple. For regular mesh it is also possible to extract
        % from global stiffness matrix.
        for j=1:2
            for k=1:2
                if j==k
                A(elements(i,j),elements(i,k)) = A(elements(i,j),elements(i,k)) + val(i)/h;
                else
                    A(elements(i,j),elements(i,k)) = A(elements(i,j),elements(i,k)) - val(i)/h;
                end
            end
        end
        
    end

    % Not the most optimal way for doing this, but it's reasonable fast so
    % not the first place to start optimizing.
    [V,D]=eig(full(A(freeNodes,freeNodes)),M(freeNodes,freeNodes));
    sumeig=diag(D)*H^2/h^2; %*H^2;
    foundEig=sumeig(sumeig < s.threshold);
    numLevels=size(foundEig,1);
    
    if numLevels > 0
        u=zeros(nb,numLevels);
        u(freeNodes,1:numLevels)=V(:,1:numLevels);
    end
end