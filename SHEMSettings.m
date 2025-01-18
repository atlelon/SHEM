classdef SHEMSettings < handle
  properties
        % Settings file for running SHEM (and its variant) with different 
        % configurations.
        
        % Coarse subdomain division parameter. If a graph partitioning 
        % software like metis is used the number of subdomains will be d^d.
        d         = 8;

        % Number of times the initial coarse triangulation is gonna be 
        % refined.
        numRefine = 4;

        % The size of the overlap as a positive whole number, i.e., number 
        % of layers the subdomains are extended in each direction.
        % delta = 1 corresponds to the small overlap case 2h.
        delta = 1;

        % Vector storing the coeffcients for each triangel.
        rho       = [];

        % The coefficient alpha for the high contrast part of the physical
        % problem.
        rhVal     = 1;

        % Name of the function that gives the disitribution of alpha
        rhofile   = 'example1';

        % Name of the right-hand side function.
        ffun       = 'ffun';
        
        % The geometry file used for MATLAB's meshing methods.
        geom      = 'unitSquare';

        % The mesh type: 'regular' or 'irregular'. NB1! Need to use a graph
        % partitioner for partitioning the domain into subodomains. 
        % NB2! Matlab needs the PDE toolbox in order to mesh in this case.
        % If metis is not found on the system we load pre-calculated mesh
        % and subdomain partitions from file.
        meshType  = 'regular';
        
        % The set this option for using precalculated mesh and partition.
        % 'D8numRefine5','D8numRefine4', 'D8numRefine3'.
        loadFromFile = '';

        % Value of alpha for the low contrast part. Currently not used.
        alpha     = 1;
        
        % True/false for plotting the distribution.
        plotDist  = false;

        % True/false for plotting MS coarse basis functions.
        plotMS    = false;

        % True/false for plotting coarse enrichment basis functions.
        plotEnr   = false;
        
        % True/false for plotting the solution.
        plotSol   = false;

        % True/false for plotting the solution.
        plotPartUnity = false;

        % Mesh struct holding the triangulation returned by MATLAB's
        % mesh functions.
        MESH      = struct();
        
        % Number of coarse enrichment basis functions to include on each 
        % boundary. Will be ignored if adaptive is set to true.
        levels    = 0;

        % If adaptive coarse spectral enrichment should be used. NB! Only 
        % for CSType = 'SHEM'.
        adaptive  = false;

        % Type of Domain decomposition solver. 'AS' or 'RAS'
        % NB! Note that RAS is currently not implemented yet.
        DDSolver  = 'AS';

        % Type of Coarse Space used. Either 'MS','SHEM', 'adaptive', 
        % 'alternating', 'sine' or 'hierarchical'. If no enrichment is 
        % specified the coarse space will be the standard Multiscale Coarse
        % space ('MS'). Note 'adaptive' is the adaptive variant of SHEM.
        CSType    = 'MS';

        % Treshhold for including spectral functions in the coarse space.
        % Only used for the adaptive variant.
        threshold = 1/32;

        %pcg tolerance.
        PCGTol    = 1e-6;
        
        % Maximum iteration for pcg.
        maxIt     = 10000;

        % Struct containing the subdomain partition
        DDPart    = struct('ovASInd',[],'nonOvASInd',[],'nonOvbndInd',[], ...
            'edgeToSub',[],'vertex_nodes',[],'edge_nodes',[],'the_edges',[]);

        % Struct containing the coarse basis functions.
        coarseSpace = struct('R_MS',[],'R_Enr',[]);
        
        % The stiffness matrix
        A = [];

        % The right-hand side
        rhs = [];

        % Path to metis folder incase metis is not on path. You can leave
        % it empty if METIS is on path.
        metisFolder = '';

  end
   properties  (Hidden)
      rhoData = [];
      idx     = [];
      folder  = [];
   end
  methods
    function obj = SHEMSettings()
        obj.folder = fileparts(mfilename('fullpath'));
    end
    function set.rhofile(obj,value) 
        if (~isa(value,'char'))
            error(['Unsupported distribution function.'])
        end
        switch value
            case 'compEx'
                obj.rhoData = getfield(load([obj.folder,'\Problem\' ...
                    'Coefficients\Mat\compEx.mat']), 'compEx');
                obj.rhofile = value;
            case 'SPE10'
                obj.rhoData = getfield(load([obj.folder,'\Problem\' ...
                    'Coefficients\Mat\SPE10.mat']), 'SPE10');
                obj.rhofile = value;
            otherwise
                obj.rhofile = value;
        end
    end

    function set.d(obj,value)
        validateattributes(value,{'double'},{'positive','integer'})
        obj.d = value;
    end

    function set.numRefine(obj,value)
        validateattributes(value,{'double'},{'positive','integer'})
        obj.numRefine = value;
    end

    function set.delta(obj,value)
        validateattributes(value,{'double'},{'positive','integer'})
        obj.delta = value;
    end

    function set.maxIt(obj,value)
        validateattributes(value,{'double'},{'positive','integer'})
        obj.maxIt = value;
    end

    function set.levels(obj,value)
        validateattributes(value,{'double'},{'nonnegative','integer'})
        obj.levels = value;
    end

    function set.threshold(obj,value)
        validateattributes(value,{'double'},{'positive','scalar'})
        obj.threshold = value;
    end

    function set.PCGTol(obj,value)
        validateattributes(value,{'double'},{'positive','scalar'})
        obj.PCGTol = value;
    end

    function set.alpha(obj,value)
        validateattributes(value,{'double'},{'positive','scalar'})
        obj.alpha = value;
    end

    function set.rhVal(obj,value)
        validateattributes(value,{'double'},{'positive','scalar'})
        obj.rhVal = value;
    end

    function set.plotDist(obj,value)
        validateattributes(value,{'logical'},{})
        obj.plotDist = value;
    end

    function set.plotMS(obj,value)
        validateattributes(value,{'logical'},{})
        obj.plotMS = value;
    end

    function set.plotEnr(obj,value)
        validateattributes(value,{'logical'},{})
        obj.plotEnr = value;
    end

    function set.plotSol(obj,value)
        validateattributes(value,{'logical'},{})
        obj.plotSol = value;
    end

    function set.plotPartUnity(obj,value)
        validateattributes(value,{'logical'},{})
        obj.plotPartUnity = value;
    end

    function set.adaptive(obj,value)
        validateattributes(value,{'logical'},{})
        obj.adaptive = value;
    end

    function checkDist(obj)
        if strcmp(obj.rhofile,'compEx')
            tmp = find(obj.rhoData==1e6);
            if ~isempty(tmp)
                obj.idx = tmp;
            end
            obj.rhoData(obj.idx)=obj.rhVal;
        end
    end
  end
end