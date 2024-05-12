%% Script for running all the examples in our paper
% "Analysis of a New Harmonically Enriched Multiscale Coarse Space for
% Domain Decomposition Methods" by Martin J. Gander, Atle Loneland,
% Talal Rahman. Link: https://arxiv.org/abs/1512.05285
%
% Copyright 2013-2024 Martin J. Gander, Atle Loneland, Talal Rahman.
%% Start SHEM
 % Need to be in SHEM folder for this to work.
start_SHEM();

%List of properties to set for SHEM.
properties SHEMSettings

%% Some pre-settings;

% If METIS is not on path you can specify the location of the METIS folder
% and it should work. Note that this does not use MEX, but call METIS 
% directly via System - command and then read/writes the graph partitioning
% using .txt files.
metisFolder = '';

% Precalculated mesh and partition. Choose between 'D8numRefine3',
% 'D8numRefine4' or 'D8numRefine5'. If PDE toolbox and METIS is installed
% you don't need to worry about this unless you want to make sure to use
% the exact same mesh and subdomain decomposition.
loadFromFile = 'D8numRefine5';

% TRUE/FALSE for plotting the underlying distribution of the coefficients.
plotDist      = false;
% TRUE/FALSE for plotting the coarse enrichment basis functions.
plotEnr       = false;
% TRUE/FALSE for plotting the coarse multiscale basis functions.
plotMS        = false;
% TRUE/FALSE for plotting the solution.
plotSol       = true;
% TRUE/FALSE for plotting the partition of unity of the multiscale basis functions.
plotPartUnity = false;

%% Setup Example 1 - Distribution given in Figure 5 and results in Table 2

s   = SHEMSettings; 

% Choose distribution file.
s.rhofile  = 'example2';     

% The jump value. Range: [1 - \infty) (~1e6).
s.rhVal    = 1e6;             

% Specify coarse space to use: 'MS', 'sine', 'alternating','SHEM' and 
% 'adaptive'.
s.CSType    = 'hierarchical';
                             
% Type of meshing.
s.meshType = 'regular';   

% Number of basis functions to add on each  interface.
s.levels   = 3;           

% See the pre-settings section
s.plotDist      = plotDist; 
s.plotEnr       = plotEnr;
s.plotMS        = plotMS;
s.plotSol       = plotSol;
s.plotPartUnity = plotPartUnity;

% Solve the problem
SHEM(s);

%% Setup Example 2 - Distribution given in Figure 1 and results in Table 3

s   = SHEMSettings; 

% Choose distribution file.
s.rhofile  = 'example1';     

% The jump value. Range: [1 - \infty) (~1e6).
s.rhVal    = 1e6;             

% Specify coarse space to use: 'MS', 'sine', 'alternating','SHEM' 
% or'adaptive'. 
s.CSType    = 'SHEM';
                             
% Type of meshing.
s.meshType = 'regular';   

% Number of basis functions to add on each  interface.
s.levels   = 4;           

% See the pre-settings section
s.plotDist      = plotDist; 
s.plotEnr       = plotEnr;
s.plotMS        = plotMS;
s.plotSol       = plotSol;
s.plotPartUnity = plotPartUnity;

% Solve the problem
SHEM(s);

%% Setup Example 3 - Distribution given in Figure 1 and results in Table 3

s   = SHEMSettings; 

% Choose distribution file.
s.rhofile  = 'example1';     

% The jump value. Range: [1 - \infty) (~1e6).
s.rhVal    = 1e6;             

% Specify coarse space to use: 'MS', 'sine', 'alternating','SHEM' or 
% 'adaptive'.
s.CSType    = 'SHEM';
                             
% Type of meshing.
s.meshType = 'regular';   

% Number of basis functions to add on each  interface.
s.levels   = 3;           

% See the pre-settings section
s.plotDist      = plotDist; 
s.plotEnr       = plotEnr;
s.plotMS        = plotMS;
s.plotSol       = plotSol;
s.plotPartUnity = plotPartUnity;

% Solve the problem
SHEM(s);
%% Setup Example 4 - Distribution given in Figure 1 and results in Table 5

s   = SHEMSettings; 

% Choose distribution file.
s.rhofile  = 'example1';     

% The jump value. Range: [1 - \infty) (~1e6).
s.rhVal    = 1e4;             

% Specify coarse space to use: 'MS', 'sine', 'alternating','SHEM' or 
% 'adaptive'.
s.CSType    = 'alternating';
                             
% Type of meshing.
s.meshType = 'regular';   

% Number of basis functions to add on each  interface.
s.levels   = 3;           

% See the pre-settings section
s.plotDist      = plotDist; 
s.plotEnr       = plotEnr;
s.plotMS        = plotMS;
s.plotSol       = plotSol;
s.plotPartUnity = true;

% Solve the problem
SHEM(s);
%% Setup Example 4 - Distribution given in Figure 1 and results in Table 5

s   = SHEMSettings; 

% Specify coarse space to use: 'MS', 'sine', 'alternating','SHEM' and 
% 'adaptive'.
s.CSType   = 'adaptive'

% Choose distribution file.
s.rhofile  = 'compEx';     

% The jump value. Range: [1 - \infty) (~1e6).
s.rhVal    = 1e6;             
                         
% Type of meshing.
s.meshType = 'regular';   

% Threshold for when to include spectral coarse basis functions into the 
% coarse space.
s.threshold = 1/32;           

% See the pre-settings section
s.plotDist      = true; 
s.plotEnr       = plotEnr;
s.plotMS        = plotMS;
s.plotSol       = plotSol;
s.plotPartUnity = true;

% Solve the problem
SHEM(s);
%% Example 4
%% Example 5 Distribution given in Figure 1 and results in Table 5
% Load precomputed mesh and partition
s = SHEMSettings; 
s.rhVal = 1e4; 

% Specify coarse space to use: 'MS', 'sine', 'alternating','SHEM' 
% or 'adaptive'. 
s.CSType  = 'adaptive'; 
s.rhofile = 'compEx'; 
s.meshType = 'irregular'; 
s.loadFromFile = 'D8numRefine5';
% s.numRefine = 5;

% See the pre-settings section
s.plotDist      = true; 
s.plotEnr       = plotEnr;
s.plotMS        = plotMS;
s.plotSol       = plotSol;
s.plotPartUnity = true;

% Solve the problem
SHEM(s);
%% Example 5 Complicated Example with irregular mesh
% Load precomputed mesh and partition
s = SHEMSettings; 
s.rhVal = 1e4; 

% Specify coarse space to use: 'MS', 'sine', 'alternating','SHEM' or  
% 'adaptive'. 
s.CSType        = 'MS'; 
s.rhofile      = 'compEx'; 
s.meshType     = 'irregular'; 
s.loadFromFile = 'D8numRefine5';

s.threshold    = 1/32;

% See the pre-settings section
s.plotDist      = true; 
s.plotEnr       = plotEnr;
s.plotMS        = plotMS;
s.plotSol       = plotSol;
s.plotPartUnity = true;

% Solve the problem
SHEM(s);

%% Example 6 SPE10
% Load precomputed mesh and partition
s = SHEMSettings; 

%  Specify coarse space to use: 'MS', 'sine', 'alternating','SHEM' or  
% 'adaptive'. 
s.CSType        = 'adaptive'; 

% Choose distribution file.
s.rhofile  = 'compEx';     

% The jump value. Range: [1 - \infty) (~1e6).
s.rhVal    = 1e6;      
s.meshType     = 'irregular'; 
s.loadFromFile = 'D8numRefine5';
s.threshold    = 1/32;

% See the pre-settings section
s.plotDist      = true; 
s.plotEnr       = plotEnr;
s.plotMS        = plotMS;
s.plotSol       = plotSol;
s.plotPartUnity = true;

% Solve the problem
SHEM(s);