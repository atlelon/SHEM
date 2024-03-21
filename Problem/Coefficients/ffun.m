function [f] = ffun (p,t)
% ffun    Returns function values of f at the mid points of the 
%         triangles given in t.

nt = size(t,2);
f = ones(1,nt);

return