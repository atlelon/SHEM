function  R_Adap = createAdaptiveCoarseSpace(s,A)
np  = size(s.MESH.fine.p,2);
bnd = s.DDPart.nonOvbndInd;
ind = s.DDPart.nonOvASInd;
d   = s.d;
p   = s.MESH.fine.p;
h   = 1/(s.d*2^s.numRefine);

ii=1;
R_Adap=[];
    switch s.meshType
        case 'regular'
            for k=1:d-1
                for j=1:d-1
                    i=j+(k-1)*(d);
                    d1=intersect(bnd(i,:),bnd(i+1,:));
                    d2=intersect(bnd(i,:),bnd(i+d,:));
                    crspnt=intersect(d1,d2);
                    V=solveEigBndAdapt(p(:,d1),h,p(:,crspnt),d1,s);
                    levels=size(V,2);
                    for kk=1:levels
                        r1=zeros(np,1);
                        r1(d1)=V(:,kk);
                        r2=zeros(np,1);
                        r2(d1)=r1(d1);
                        b2=zeros(np,1);
                        frNodes=ind(i,:);
                        b2=b2-A*r2;
                        r1(frNodes)=A(frNodes,frNodes)\b2(frNodes);
                        r2=zeros(np,1);
                        r2(d1)=r1(d1);
                        b2=zeros(np,1);
                        frNodes=ind(i+1,:);
                        b2=b2-A*r2;
                        r1(frNodes)=A(frNodes,frNodes)\b2(frNodes);
                        R_Adap(ii,:)=r1;
            %             trisurf(t', p(1,:), p(2,:), r1','facecolor','interp');
            %             pause()
                        ii=ii+1;
                    end
                    V=solveEigBndAdapt(p(:,d2),h,p(:,crspnt),d2,s);
                    levels=size(V,2);
                    for kk=1:levels
                        r1=zeros(np,1);
                        r1(d2)=V(:,kk);
                        r2=zeros(np,1);
                        r2(d2)=r1(d2);
                        b2=zeros(np,1);
                        frNodes=ind(i,:);
                        b2=b2-A*r2;
                        r1(frNodes)=A(frNodes,frNodes)\b2(frNodes);
                        r2=zeros(np,1);
                        r2(d2)=r1(d2);
                        b2=zeros(np,1);
                        frNodes=ind(i+d,:);
                        b2=b2-A*r2;
                        r1(frNodes)=A(frNodes,frNodes)\b2(frNodes);
                        R_Adap(ii,:)=r1;
                        ii=ii+1;
                    end
                end
                
            end
            for i=d:d:(d)^2-d
                    d1=intersect(bnd(i,:),bnd(i-1,:));
                    d2=intersect(bnd(i,:),bnd(i+d,:));
                    crspnt=intersect(d1,d2);
                    V=solveEigBndAdapt(p(:,d2),h,p(:,crspnt),d2,s);
                    levels=size(V,2);
                    for kk=1:levels
                        r1=zeros(np,1);
                        r1(d2)=V(:,kk);
                        r2=zeros(np,1);
                        r2(d2)=r1(d2);
                        b2=zeros(np,1);
                        frNodes=ind(i,:);
                        b2=b2-A*r2;
                        r1(frNodes)=A(frNodes,frNodes)\b2(frNodes);
                        r2=zeros(np,1);
                        r2(d2)=r1(d2);
                        b2=zeros(np,1);
                        frNodes=ind(i+d,:);
                        b2=b2-A*r2;
                        r1(frNodes)=A(frNodes,frNodes)\b2(frNodes);
                        R_Adap(ii,:)=r1;
                        ii=ii+1;
                    end
            end
            for i=d^2-d+1:d^2-1
                    d1=intersect(bnd(i,:),bnd(i+1,:));
                    d2=intersect(bnd(i,:),bnd(i-d,:));
                    crspnt=intersect(d1,d2);
                    V=solveEigBndAdapt(p(:,d1),h,p(:,crspnt),d1,s);
                    levels=size(V,2);
                    for kk=1:levels
                        r1=zeros(np,1);
                        r1(d1)=V(:,kk);
                        r2=zeros(np,1);
                        r2(d1)=r1(d1);
                        b2=zeros(np,1);
                        frNodes=ind(i,:);
                        b2=b2-A*r2;
                        r1(frNodes)=A(frNodes,frNodes)\b2(frNodes);
                        r2=zeros(np,1);
                        r2(d1)=r1(d1);
                        b2=zeros(np,1);
                        frNodes=ind(i+1,:);
                        b2=b2-A*r2;
                        r1(frNodes)=A(frNodes,frNodes)\b2(frNodes);
                        R_Adap(ii,:)=r1;
                        ii=ii+1;
                    end
            end
            
                    case 'irregular'
            
                        R_Adap=[];
                        maxLevels=0;
                        ii=1;
                        tic()
                        for k=1:size(s.DDPart.the_edges,2)
                            
                            frNodes=[];
                            edge    = s.DDPart.nonOvbndInd{k};
                            V       = solveEigBndAdaptIrr(edge,s);
                            sub     = s.DDPart.edgeToSub(k,:);
                            frNodes = union(frNodes,s.DDPart.ovASInd(sub(1),:));
                            frNodes = union(frNodes,s.DDPart.ovASInd(sub(2),:));
                            dummy   = union(s.DDPart.edge_nodes,s.DDPart.vertex_nodes);
                            frNodes = nonzeros(setdiff(setdiff(frNodes,dummy),s.MESH.fine.boundary));
                            
                            levels=size(V,2);
                            if levels > maxLevels
                                maxLevels=levels;
                            end
                            
                            for kk=1:levels
                                r1=zeros(np,1);
                                r1(edge)=V(:,kk);
                                b2=zeros(np,1);
                                b2=b2-A*r1;
                                r1(frNodes)=A(frNodes,frNodes)\b2(frNodes);
                                R_Adap(ii,:)=r1;
                                % trisurf(s.MESH.fine.t', s.MESH.fine.p(1,:), s.MESH.fine.p(2,:), r1','facecolor','interp');
                                % pause()
                                ii=ii+1;
                            end
                        end
        otherwise
            error(['Unsupported meshing type. Must be either regular' ...
                'or irregular'])
    end

end