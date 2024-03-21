function [u]=solveEigBndAdaptIrr(nodes,s)
    

    nb = size(nodes,1);
    elements = zeros(nb-1,2);
    val      = zeros(nb-1,1);
    nb = size(nodes,2);
    p = s.MESH.fine.p;
    M=sparse(nb,nb);
    for i=1:nb-1
        elements(i,1) = i;
        elements(i,2) = i+1;
        elnum         = node2element(s.MESH.tri,nodes(elements(i,:)))';
        val(i)        = max(s.rho(elnum));
        elnum2        = node2elementAll(s.MESH.tri,nodes(elements(i,2)))';
        valb          = sum(s.rho(elnum2));    
        h=norm(p(:,nodes(elements(i,1)))-p(:,nodes(elements(i,2))));

        % Mass matrix assembly
        M(elements(i,2),elements(i,2)) = M(elements(i,2),elements(i,2)) + valb/h;
    end
    
    nElements=size(elements,1);
    nNodes=nb;
    A=sparse(nNodes,nNodes);
    hmin = 1;
    for i=1:nElements

        h=norm(p(:,nodes(elements(i,1)))-p(:,nodes(elements(i,2))));
        hmin=min(hmin,h);
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
    
    % Trick for extrating the mass matrix from the global stiffness matrix.
    % Seems to give better adaptive performance.
    M(1:nb+1:end) = diag(s.A(nodes,nodes));
    freeNodes          = 2:nb-1;

    % Not the most optimal way for doing this, but it's reasonable fast so
    % not the first place to start optimizing.
    [V,D]     = eig(full(A(freeNodes,freeNodes)),full(M(freeNodes,freeNodes)));
    sumeig    = sum(D,2)*hmin;
    foundEig  = sumeig(sumeig < s.threshold);
    numLevels = size(foundEig,1);
    u         = [];
    if numLevels > 0
        u=zeros(nb,numLevels);
        u(freeNodes,1:numLevels)=V(:,1:numLevels);
    end
    
end