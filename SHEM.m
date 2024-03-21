function [u, FLAG,RELRES,ITER,RESVEC,eigest]=SHEM(s)
    % An implementation of SHEM corresponding to our paper 
    % "Analysis of a New Harmonically Enriched Multiscale Coarse Space for
    % Domain Decomposition Methods" by Martin J. Gander, Atle Loneland,
    % Talal Rahman. Link: https://arxiv.org/abs/1512.05285
    %
    % Copyright 2013-2024 Martin J. Gander, Atle Loneland, Talal Rahman.
    %
    switch s.loadFromFile

        case 'D8numRefine5'
            fprintf('Loading MESH and partition from file: ');
            file = [s.folder,'\Geom\PreCalc\','D8numRefine5'];
            load(file,'MESH','DDPart');
            s.MESH   = MESH;
            s.DDPart = DDPart;
            s.d         = 8;
            s.numRefine = 5;

        case 'D8numRefine4'
            fprintf('Loading MESH and partition from file: ');
            file = [s.folder,'\Geom\PreCalc\','D8numRefine4'];
            load(file,'MESH','DDPart');
            s.MESH      = MESH;
            s.DDPart    = DDPart;
            s.d         = 8;
            s.numRefine = 4;

        case 'D8numRefine3'
            fprintf('Loading MESH and partition from file: ');
            file = [s.folder,'\Geom\PreCalc\','D8numRefine3'];
            load(file,'MESH','DDPart');
            s.MESH   = MESH;
            s.DDPart = DDPart;
            s.d         = 8;
            s.numRefine = 3;
        
        case ''
            d=s.d; 
            H=1/d;
            h  = 1/(s.d*2^s.numRefine);
            fprintf('Mesh Parameters: H=%d, h=%d, H/h=%d', H, h, H/h );
            fprintf('\nGenerating the mesh: ');
            tic()
            createMesh(s);
            toc()
            fprintf('Generating subdomains: ');
            tic
            createSubdomains(s);
            toc
        otherwise
            error(['No precalculated mesh or partition with the name: ' ...
                ,s.loadFromFile])

    end  
    tic
    fprintf('\nGenerating the coefficient rho:  ' )
    s.checkDist();
    s.rho = rho(s);
    toc
    fprintf('Assembling FEM matrix:  ' )
    tic
    s.A=assemai(s.MESH.fine.p,s.MESH.fine.t, s.rho);
    toc
    tic
    fprintf('Assembling the right-hand side:  ' )
    ff=feval(s.ffun,s.MESH.fine.p,s.MESH.fine.t);
    s.rhs=rhsi(s.MESH.fine.p,s.MESH.fine.t,ff);
    toc
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    fprintf('Constructing MS coarse basis functions: ')
    tic 
    R_MS = createMSCoarseSpace(s,s.A);
    toc
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    fprintf(['Constructing the ' s.CSType ' coarse basis functions: '])
    tic
    R_Enr = coarseEnrichment(s,s.A);
    toc
    
    % Store the coarse space components in s.
    s.coarseSpace.R_MS   = R_MS;
    s.coarseSpace.R_SHEM = R_Enr;

    % Merge MS and enrichment basis functions to one coarse space operator.
    R_SHEM = [R_MS;R_Enr];
    
    fprintf('Dimension of the coarse space: %d \n', size(R_SHEM,1));
    fprintf('Dimension of the largest sumdomain: %d', size(s.DDPart.ovASInd,2));
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    np = size(s.MESH.fine.p,2);
    u  = zeros(np,1); 
    fprintf('\nSolving the linear system: ');
    warning('off','MATLAB:eigs:IgnoredOptionIssym');
    tic
    [u(s.MESH.fine.internal), FLAG,RELRES,ITER,RESVEC,eigest] = pcgeig(...
        s.A(s.MESH.fine.internal,s.MESH.fine.internal),...
        s.rhs(s.MESH.fine.internal),s.PCGTol,s.maxIt,...
        @(r) ASM2D(r,s.A,R_SHEM,s));
    toc();
    warning('on','MATLAB:eigs:IgnoredOptionIssym');
    %@(r) ASM2D(r,A,R_SHEM,s.d^2,np,s.MESH.fine.internal,s.DDPart.ovASInd));
    fprintf('Iteration Number: %d ', ITER );
    fprintf(' Condition Number : %d \n', eigest(3));
    
    %Plot to check if MS coarse basis functions form partition of unity.
    if (s.plotDist) 
        figure();
        plotDistribution(s);
    end

    % Plot the solution
    if (s.plotSol)
        figure();
        trisurf(s.MESH.fine.t', s.MESH.fine.p(1,:), s.MESH.fine.p(2,:),u','facecolor','interp');
    end

    %Plot the coase MS basis functions
    if (s.plotMS) 
        figure();
        for i=1:size(R_MS,1)
            trisurf(s.MESH.fine.t', s.MESH.fine.p(1,:), s.MESH.fine.p(2,:), full(R_MS(i,:))','facecolor','interp');
            pause()
        end
    end
    
    %Plot the coarse enrichment basis functions
    if (s.plotEnr) 
        figure();
        for i=1:size(R_Enr,1)
            trisurf(s.MESH.fine.t', s.MESH.fine.p(1,:), s.MESH.fine.p(2,:), full(R_Enr(i,:))','facecolor','interp');
            pause()
        end
    end

    %Plot to check if MS coarse basis functions form partition of unity.
    if (s.plotPartUnity) 
        figure();
        trisurf(s.MESH.fine.t', s.MESH.fine.p(1,:), s.MESH.fine.p(2,:), full(sum(R_MS,1))','facecolor','interp');
    end

end