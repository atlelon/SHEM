function [u]=solveSineBnd(coord, h,bl,level,nodes,s)
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

ee=zeros(nb,1);
H=norm(coord(:,I(1))-coord(:,I(end)));
f4=@(h,H,i,j)(sqrt(2*h/H)*(sin(i*j*pi*h/H)));
ee(I(2:end-1))= f4(h,H,level,1:H/h-1);

ee=M*ee;
freeNodes=setdiff(1:nb,dirinodes);
u(freeNodes)=A(freeNodes,freeNodes)\ee(freeNodes);


end