function [u]=solveBndIrr(nodes,s)

nb = size(nodes,1);
elements = zeros(nb-1,2);
val      = zeros(nb-1,1);
nb = size(nodes,2);
p = s.MESH.fine.p;
for i=1:nb-1
    elements(i,1)=i;
    elements(i,2)=i+1;
    elnum=node2element(s.MESH.tri,nodes(elements(i,:)))';
    val(i)=max(s.rho(elnum));
end
u=zeros(nb,1);
nElements=size(elements,1);
nNodes=nb;
A=sparse(nNodes,nNodes);
for i=1:nElements
    h=norm(p(:,nodes(elements(i,1)))-p(:,nodes(elements(i,2))));
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
u(1)=1;
u(end)=0;
freeNodes=2:nb-1;
b=zeros(nNodes,1);
b = b - A * u;
u(freeNodes)=A(freeNodes,freeNodes)\b(freeNodes);