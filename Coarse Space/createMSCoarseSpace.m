function R_MS = createMSCoarseSpace(s,A)
np  = size(s.MESH.fine.p,2);
R_MS   = spalloc((s.d-1)^2,np,4*np);
bnd = s.DDPart.nonOvbndInd;
ind = s.DDPart.nonOvASInd;
d   = s.d;
p   = s.MESH.fine.p;
switch s.meshType
    case 'regular'
        h   = 1/(s.d*2^s.numRefine);
        ii=1;
        for k=1:d-1
            for j=1:d-1
                i=j+(k-1)*d;
                r1=zeros(np,1);
                d1=intersect(bnd(i,:),bnd(i+1,:));
                d2=intersect(bnd(i,:),bnd(i+d,:));
                d3=intersect(bnd(i+1,:),bnd(i+d+1,:));
                d4=intersect(bnd(d+i,:),bnd(i+d+1,:));
                crspnt=intersect(d1,d2);

                db1=solveBnd(p(:,d1),h,p(:,crspnt),d1,s);
                db2=solveBnd(p(:,d2),h,p(:,crspnt),d2,s);
                db3=solveBnd(p(:,d3),h,p(:,crspnt),d3,s);
                db4=solveBnd(p(:,d4),h,p(:,crspnt),d4,s);
                r1(d1)=db1;
                r1(d2)=db2;
                r1(d3)=db3;
                r1(d4)=db4;

                r2=zeros(np,1);
                r2(d1)=db1;
                r2(d2)=db2;
                b2=zeros(np,1);
                frNodes=ind(i,:);
                b2=b2-A*r2;
                r1(frNodes)=A(frNodes,frNodes)\b2(frNodes);

                r2=zeros(np,1);
                r2(d2)=db2;
                r2(d4)=db4;
                b2=zeros(np,1);
                frNodes=ind(d+i,:);
                b2=b2-A*r2;
                r1(frNodes)=A(frNodes,frNodes)\b2(frNodes);

                r2=zeros(np,1);
                r2(d3)=db3;
                r2(d4)=db4;
                b2=zeros(np,1);
                frNodes=ind(d+i+1,:);
                b2=b2-A*r2;
                r1(frNodes)=A(frNodes,frNodes)\b2(frNodes);

                r2=zeros(np,1);
                r2(d1)=db1;
                r2(d3)=db3;
                b2=zeros(np,1);
                frNodes=ind(i+1,:);
                b2=b2-A*r2;
                r1(frNodes)=A(frNodes,frNodes)\b2(frNodes);
                R_MS(ii,:)=r1;
                ii=ii+1;
            end

        end
    case 'irregular'

        R_MS=spalloc(size(s.DDPart.vertex_nodes,2),np,4*np);
        ii=1;
        for k=s.DDPart.vertex_nodes
            r1=zeros(np,1);
            [~,bnIN,~]=find(s.DDPart.the_edges==k);
            %         vertices = intersect(ind2(:,k),vertex_nodes);
            frNodes=[];
        
            for i=1:size(bnIN,1)
                edge = s.DDPart.nonOvbndInd{bnIN(i)};
                if k~=edge(1)
                    edge=edge(end:-1:1);
                end
                % db1=solvebnd(edge);
                db1      = solveBndIrr(edge,s);
                sub      = s.DDPart.edgeToSub(bnIN(i),:);
                frNodes  = union(frNodes,s.DDPart.ovASInd(sub(1),:));
                frNodes  = union(frNodes,s.DDPart.ovASInd(sub(2),:));
                r1(edge) = db1;
            end
            dummy=union(s.DDPart.edge_nodes,s.DDPart.vertex_nodes);
            frNodes=nonzeros(setdiff(setdiff(frNodes,dummy),s.MESH.fine.boundary));
        %     dummy2=union(dummy2,frNodes);
            b2=zeros(np,1);
            b2=b2-A*r1;
            r1(frNodes)=A(frNodes,frNodes)\b2(frNodes);
        %     r1(edge_nodes)=1;
            %            db1=solvebnd(di{i},k,other);
        %     trisurf(t', p(1,:), p(2,:), r1','facecolor','interp');
        %     pause()
        
            R_MS(ii,:)=r1;
        %             trisurf(t', p(1,:), p(2,:), r1','facecolor','interp');
        %             pause()
            ii=ii+1;
        end

    
    otherwise
        error(['Unsupported meshing type. Must be either regular' ...
            'or irregular'])




end
end