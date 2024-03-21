# SHEM

This is a repo for our paper **Analysis of a New Harmonically Enriched Multiscale Coarse Space for Domain Decomposition Methods**  [Arxiv] (https://arxiv.org/abs/1512.05285) that will soon be published.

## Installation
Clone or download this repo and run start_SHEM().

git clone https://github.com/atlelon/SHEM.git
cd SHEM

'''matlab
start_SHEM()
'''
## Run
To run the code and reproduce the numerical results given in the paper. Follow the instructions of each section in the runScript folder. You only need base MATLAB to run the examples, but for trying other irregular meshes and METIS subdomain decomposition you need MATLAB's PDE toolbox and METIS installed.

## Example 
```matlab
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
plotDist      = false;
plotEnr       = false;
plotMS        = false;
plotSol       = false;
plotPartUnity = false;

%% Example 6 SPE10
% Load precomputed mesh and partition
s = SHEMSettings; 

%  Specify coarse space to use: 'MS', 'sine', 'alternating','SHEM' or  
% 'adaptive'. 
s.CSType        = 'adaptive'; 

% Choose distribution file.
s.rhofile  = 'SPE10';     

% The jump value. Range: [1 - \infty) (~1e6).
s.rhVal    = 1e6;      
s.meshType     = 'irregular'; 
s.loadFromFile = 'D8numRefine5';
s.threshold    = 1/32;

% See the pre-settings section
s.plotDist      = true; 
s.plotEnr       = plotEnr;
s.plotMS        = plotEnr;
s.plotSol       = plotEnr;
s.plotPartUnity = true;

% Solve the problem
SHEM(s);
```

