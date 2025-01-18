function [u]=solveHierBnd(coord, h,bl,level,nodes,s)
    [mb, nb]=size(coord);
    centr=ones([mb nb]);
    centr(1,:)=centr(1,:).*bl(1);
    centr(2,:)=centr(2,:).*bl(2);
    [~, I]=sort(sqrt(sum((centr-coord).^2,1)));
    elements = zeros(nb-1,2);
    val      = zeros(nb-1,1);
    M=sparse(nb,nb);
    for i=1:nb-1
        elements(i,1) = I(i);
        elements(i,2) = I(i+1);
        elnum         = node2element(s.MESH.tri,nodes(elements(i,:)))';
        val(i)        = max(s.rho(elnum)); % Can use max and sum here.
        elnum2        = node2elementAll(s.MESH.tri,nodes(elements(i,2)))';
        valb          = sum(s.rho(elnum2));    
    
        % Mass matrix assembly
        M(I(i+1),I(i+1)) = M(I(i+1),I(i+1))+valb/h;
        
    end
    % u         = zeros(nb,1);
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

    % Constructing the 1D hierarchical basis function: 
    u        = zeros(nb,1);
    ee       = zeros(1,nb);
    expnt    = floor(log2(level)) + 1;
    mdPnt    = (nb-1)/2^expnt;
    numBsLev = 2^(expnt-1);
    ix       = 2*(level - numBsLev);

    ee(mdPnt*ix+1:mdPnt*(ix+1)+1) = linspace(0,1,mdPnt+1);
    ee(mdPnt*(ix+1)+2:mdPnt*(ix+2)+1) = 1-ee(mdPnt*ix+2:mdPnt*(ix+1)+1);
    
    % Setting the rhs and multiplying with mass matrix.
    ee(I)=ee;
    ee=M*ee';

    % Solving the system.
    u(freeNodes)=A(freeNodes,freeNodes)\ee(freeNodes);

end