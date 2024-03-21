function [fm] = rhsi ( p, t, f )
% RHSI Routine for computing right hand side contribution.

np = size(p,2); % No. of points.

% Triangle geometries : area and the corner point indices.
[ar] = pdetrg(p,t);
it1  = t(1,:);
it2  = t(2,:);
it3  = t(3,:);

% Generate the right hand side.
% Assemble integral contribution of right hand side.
f  = f.*ar/3;
fm =    sparse(it1,1,f,np,1);
fm = fm+sparse(it2,1,f,np,1);
fm = fm+sparse(it3,1,f,np,1);
end