function [Vertex_nodes,Edge_nodes,IN]= find_VE_nodes(p,number_of_nodes,nparts)

IN=zeros(number_of_nodes,nparts);
for i =1:nparts
    ind=nonzeros(p(:,i));
    IN(ind,i)=1;
end

Edge_nodes=find(sum(IN')==2);
Vertex_nodes=find(sum(IN')>2);