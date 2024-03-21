%% Script for running all the examples in our paper
% "Analysis of a New Harmonically Enriched Multiscale Coarse Space for
% Domain Decomposition Methods" by Martin J. Gander, Atle Loneland,
% Talal Rahman. Link: https://arxiv.org/abs/1512.05285
%
% Copyright 2013-2024 Martin J. Gander, Atle Loneland, Talal Rahman.
%% Start SHEM



start_SHEM(); % Need to be in SHEM folder for this to work.
%% Some pre-settings;

metisFolder = 'C:\Users\lonel\Documents\MATLAB\metis-5.0.2\';
loadFromFile = 'D8numRefine5'; % Precalculated mesh and partition. Choose 
                               % Between 'D8numRefine3','D8numRefine4' or
                               % 'D8numRefine5' 
plotDist      = false;
plotEnr       = false;
plotMS        = false;
plotSol       = false;
plotPartUnity = false;

%% Setup Example 1 - Distribution given in Figure 5 and results in Table 2

s   = SHEMSettings; 

% Choose distribution file.
s.rhofile  = 'example2';     

% The jump value. Range: [1 - \infty) (~1e6).
s.rhVal    = 1e6;             

% Specify coarse space to use: 'MS', 'sine', 'alternating','SHEM' and 
% 'adaptive'.
s.CSType   = 'hierarchical';
                             
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

% Specify coarse space to use: 'MS', 'sine', 'alternating','SHEM' and 
% 'adaptive'.
s.CSType   = 'SHEM';
                             
% Type of meshing.
s.meshType = 'regular';   

% Number of basis functions to add on each  interface.
s.levels   = 4;           

% See the pre-settings section
s.plotDist      = plotDist; 
s.plotEnr       = false;
s.plotMS        = false;
s.plotSol       = false;
s.plotPartUnity = plotPartUnity;

% Solve the problem
SHEM(s);

%% Setup Example 3 - Distribution given in Figure 1 and results in Table 3

s   = SHEMSettings; 

% Choose distribution file.
s.rhofile  = 'example1';     

% The jump value. Range: [1 - \infty) (~1e6).
s.rhVal    = 1e6;             

% Specify coarse space to use: 'MS', 'sine', 'alternating','SHEM' and 
% 'adaptive'.
s.CSType   = 'SHEM';
                             
% Type of meshing.
s.meshType = 'regular';   

% Number of basis functions to add on each  interface.
s.levels   = 3;           

% See the pre-settings section
s.plotDist      = plotDist; 
s.plotEnr       = false;
s.plotMS        = false;
s.plotSol       = false;
s.plotPartUnity = plotPartUnity;

% Solve the problem
SHEM(s);
%% Setup Example 3 - Distribution given in Figure 1 and results in Table 5

s   = SHEMSettings; 

% Choose distribution file.
s.rhofile  = 'example1';     

% The jump value. Range: [1 - \infty) (~1e6).
s.rhVal    = 1e6;             

% Specify coarse space to use: 'MS', 'sine', 'alternating','SHEM' and 
% 'adaptive'.
s.CSType   = 'adaptive';
                             
% Type of meshing.
s.meshType = 'regular';   

% Number of basis functions to add on each  interface.
s.levels   = 3;           

% See the pre-settings section
s.plotDist      = plotDist; 
s.plotEnr       = false;
s.plotMS        = false;
s.plotSol       = false;
s.plotPartUnity = plotPartUnity;

% Solve the problem
SHEM(s);
%% Example 3
%% Example 4
%% Example 5
s = SHEMSettings; 
s.metisFolder = 'C:\Users\lonel\Documents\MATLAB\metis-5.0.2\';
s.rhVal = 1e4; 
s.CSType = 'adaptive'; 
s.rhofile = 'compEx'; 
s.meshType = 'irregular'; 
% s.loadFromFile = 'D8numRefine5';
s.numRefine = 5;

[u, FLAG,RELRES,ITER,RESVEC,eigest]=SHEM(s);