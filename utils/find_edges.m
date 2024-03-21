function [edge,edgeToSub]=find_edges(nodesIN,edge_nodes,nparts)
    counter=1;
    temp=spalloc(length(edge_nodes),nparts,length(edge_nodes)*4);
    edge=spalloc(length(edge_nodes),10*nparts,length(edge_nodes));
    for i=1:nparts
        a=intersect(nodesIN(:,i),edge_nodes);
        temp(1:length(a),i)=a;
    end
    for j=1:nparts
        a=nonzeros(temp(:,j));
        for k=j+1:nparts
            b=intersect(a,temp(:,k));
            if(length(b)>1)
                edge(1:length(b),counter)=b;
                edgeToSub(counter,:)=[j,k];
                counter=counter+1;
            end
        end
    end
    edge=edge(1:length(nonzeros(sum(edge,2))),1:counter-1);
end