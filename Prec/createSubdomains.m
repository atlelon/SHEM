function createSubdomains(s)
% Function that creates the subdomain partitioning.
H = 1/s.d;
h  = 1/(s.d*2^s.numRefine);
p = s.MESH.fine.p;

switch s.meshType
    case 'regular'
    k = 1;
    if strcmp(s.DDSolver,'AS')
        ovASInd=zeros(s.d^2,(s.d+1)^2);    
        for i = 1:s.d
            for j=1:s.d
        
                x0 = (i-1)*H;
                y0 = (j-1)*H;
                x1 = x0;
                x2 = x0+H;
                y1 = y0;
                y2 = y0+H;
        
                xv = [x1 x2 x2 x1 x1];
                yv = [y1 y1 y2 y2 y1];
        
                [ti, tb]      = inpolygon( p(1,:), p(2,:), xv, yv );
                bndInd(k,:)      = find(tb);
                nonOvASInd(k,:)      = setdiff(find(ti),bndInd(k,:));
                tmpInd=setdiff(find(ti),s.MESH.fine.boundary);
                ovASInd(k,1:size(tmpInd,2))      = tmpInd;
                k=k+1;
            end
        end
    elseif strcmp(s.DDSolver,'RAS')
    %%%NB NOT FINISHED %%%
        ovASInd=zeros(s.d^2,(s.d)^2);
        k=1;
        for i = 1:s.d
            for j=1:s.d
        
                x0 = (i-1)*H;
                y0 = (j-1)*H;
                x1 = x0;
                x2 = x0+H+h;
                y1 = y0;
                y2 = y0+H+h;
        
                xv = [x1 x2 x2 x1 x1];
                yv = [y1 y1 y2 y2 y1];
                [ti, tb]      = inpolygon( p(1,:), p(2,:), xv, yv );
                dummy         = find(tb);
                tmpInd        = setdiff(find(ti),dummy);
                tmpInd=setdiff(tmpInd,pet.fine.boundary);
                ovASInd(k,1:size(tmpInd,2))=tmpInd;
                k=k+1;
            end
        end
    else 
        error(['Error. The solver method: ',s.DDSolver,' is not supported.'])
    end
        s.DDPart.ovASInd        = ovASInd;
        s.DDPart.nonOvASInd     = nonOvASInd;
        s.DDPart.nonOvbndInd    = bndInd;
    
    case 'irregular'
        numsb = s.d^2;
        np    = size(s.MESH.fine.p,2);
        t     = s.MESH.fine.t;
        [PrtE,~]=MetisPart(t',numsb,s);

        if (isempty(PrtE)) 
            error(['Problem using METIS. Most likely not on path or not ' ...
                'installed. Please set a valid path to METIS in the SHEM ' ...
                'settings file or use the option to load mesh and partition' ...
                ' from file.'])
        end
        
        %Subdomain partition in nodes.
        %Subdomain partition in elements.
        uv=zeros(np,1);
        for i=1:numsb
            I=find(PrtE==i-1);
            I=unique(t(:,I));
            tmpInd(1:length(I),i)=I;  
            uv(I)=uv(I)+1;
            I=setdiff(I,s.MESH.fine.boundary);
            ovASInd(1:length(I),i)=I;
        end
        
        uv = zeros(np,1);
        [vertex_nodes,edge_nodes,~]= find_VE_nodes(tmpInd,np,numsb); 
        skeleton = nonzeros(union(edge_nodes,vertex_nodes));
        for i=1:numsb
            dummy=nonzeros(setdiff(setdiff(ovASInd(:,i),skeleton),s.MESH.fine.boundary));
            nonOvASInd(1:size(dummy,1),i) = dummy;
            uv(dummy)                     = uv(dummy)+1;
        end

        [the_edges,edgeToSub] = find_edges(tmpInd,[edge_nodes vertex_nodes], ...
            numsb);

        size(the_edges,2);
        for k=1:size(the_edges,2)
            dummy = nonzeros(the_edges(:,k));
            vertex = intersect(dummy,vertex_nodes);
            edge=[];
            for j=1:size(dummy,1)
                if numel(vertex)==0
                    disp('no vertex')
                    continue;
                end
                elem=sum(t==vertex(1),1)==1;
                [node, I]=intersect(dummy,t(:,elem));
                nynode=setdiff(node,vertex(1));
                edge(end+1) = vertex(1);
                dummy=setdiff(dummy,edge);
                vertex=nynode;
            end
            bndInd{k}=edge;
        %         size(kant,2)
        %         size(nonzeros(the_edges(:,k)),1)
            % if size(edge,2)~=size(nonzeros(the_edges(:,k)),1)
            %     size(edge,2)
            %     size(nonzeros(the_edges(:,k)),1)
            % end
            
        end
        s.DDPart.ovASInd        = ovASInd';
        s.DDPart.nonOvASInd     = nonOvASInd;
        s.DDPart.nonOvbndInd    = bndInd;
        s.DDPart.edgeToSub    = edgeToSub;
        s.DDPart.vertex_nodes = vertex_nodes;
        s.DDPart.edge_nodes   = edge_nodes;
        s.DDPart.the_edges    = the_edges;
        
    otherwise
        error(['Unsupported meshing type. Must be either regular' ...
            'or irregular'])

end


       
end