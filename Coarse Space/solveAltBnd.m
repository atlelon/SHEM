function [u]=solveAltBnd(coord, h,bl,level,nodes,s)
    
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
    val(i)        = sum(s.rho(elnum)); % Can use max and sum here.
    elnum2        = node2elementAll(s.MESH.tri,nodes(elements(i,2)))';
    valb          = sum(s.rho(elnum2));    

    % Mass matrix assembly
    M(I(i+1),I(i+1)) = M(I(i+1),I(i+1))+valb/h;
    
end
% u         = zeros(nb,1);
nElements = size(elements,1);
A         = sparse(nb,nb);
dirinodes = [I(1) I(end)];

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

    u   = zeros(nb,1);
    dd  = ones(1,nb);
    
    tt=splitInterface(1:nb,level);
    for i=2:2:level
        dd(tt{:,i})=-dd(tt{:,i});
    end
    d = M*dd';
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