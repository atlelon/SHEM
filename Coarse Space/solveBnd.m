function [u]=solveBnd(coord,h,bl,nodes,s)

[mb, nb]=size(coord);
centr=ones([mb nb]);
centr(1,:)=centr(1,:).*bl(1);
centr(2,:)=centr(2,:).*bl(2);
[~, I]=sort(sqrt(sum((centr-coord).^2,1)));
elements = zeros(nb-1,2);
val      = zeros(nb-1,1);
for i=1:nb-1
    elements(i,1)=I(i);
    elements(i,2)=I(i+1);
    elnum=node2element(s.MESH.tri,nodes(elements(i,:)))';
    val(i)=max(s.rho(elnum));
end
u=zeros(nb,1);
nElements=size(elements,1);
nNodes=nb;
A=sparse(nNodes,nNodes);
b=zeros(nNodes,1);
dirinodes=[I(1) I(end)];
for i=1:nElements
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
u(I(1))=1;
u(I(end))=0;
freeNodes=setdiff(1:nNodes,dirinodes);
b=zeros(nNodes,1);
b = b - A * u;
u(freeNodes)=A(freeNodes,freeNodes)\b(freeNodes);