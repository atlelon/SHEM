function createMesh(s)
    % Function that generates the triangulation of the problem.
    % OLD CODE that requires PDE toolbox!
    % [p,e,t]  = poimesh(s.geom, s.d);
    % 
    % np       = size(p,2);
    % boundary = union(e(1,:),e(2,:));
    % internal = setdiff(1:np,boundary);
    % 
    % % MESH.coarse.p = p; MESH.coarse.e = e; MESH.coarse.t = t;
    % % MESH.coarse.boundary  = boundary; MESH.coarse.internal = internal;
    % 
    % % R0 = speye(np);
    % 
    % for i=1:s.numRefine
    %     [p,e,t]=refinemesh(s.geom,p,e,t); 
    % end
    % toc
    % t(4,:)=[];
    % np       = size(p,2);
    % boundary = union(e(1,:),e(2,:));
    % internal = setdiff(1:np,boundary);
    % 
    % MESH.fine.p = p; MESH.fine.e = e; MESH.fine.t = t;
    % MESH.fine.boundary = boundary; MESH.fine.internal = internal;
    % 
    % s.MESH = MESH;
    % OLD CODE that requires PDE toolbox!

    % New code:

    h = 1/(s.d*2^s.numRefine);
    switch s.geom
        case 'unitSquare'
            switch s.meshType
                case 'regular'
                    dx     = 0:h:1;
                    dy     = 0:h:1;
                    [X, Y] = meshgrid(dx,dy);
                    dt     = delaunayTriangulation(X(:),Y(:));
                    s.MESH.tri = dt;
                    s.MESH.fine.internal = setdiff(1:size(dt.Points,1),unique(dt.freeBoundary));
                    s.MESH.fine.boundary = unique(dt.freeBoundary);
                    s.MESH.fine.p        = dt.Points';
                    s.MESH.fine.t        = dt.ConnectivityList';
                case 'irregular'
                    [p,e,t] = initmesh(s.geom,'Hmax',h,'init','off','jiggle', ...
                        'off','Hgrad', 1.1,'MesherVersion','R2013a');
                    t(4,:)=[];
                    s.MESH.tri = triangulation(t',p');
                    % [tri, Xb] = freeBoundary(dt);
                    s.MESH.fine.internal = setdiff(1:size(s.MESH.tri.Points,1) ...
                        ,unique(s.MESH.tri.freeBoundary));
                    s.MESH.fine.boundary = unique(s.MESH.tri.freeBoundary);
                    s.MESH.fine.p        = s.MESH.tri.Points';
                    s.MESH.fine.t        = s.MESH.tri.ConnectivityList';
                otherwise
                    error(['Unsupported meshing type. Must be either regular' ...
                        'or irregular'])
            end
        otherwise
            error(['Unsupported geometry for when using delaunay' ...
                'Triangulation.'])
    end
end