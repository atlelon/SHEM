# SHEM

This is a repo for our paper **Analysis of a New Harmonically Enriched Multiscale Coarse Space for Domain Decomposition Methods**  [Arxiv] (https://arxiv.org/abs/1512.05285) that will soon be published.

## Installation
Clone or download this repo and run start_SHEM().

## Run
To run the code and reproduce the numerical results given in the paper. Follow the instructions of each section in the runScript folder. You only need base MATLAB to run the examples, but for trying other irregular meshes and METIS subdomain decomposition you need MATLAB's PDE toolbox and METIS installed.

## Example 
```matlab
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

