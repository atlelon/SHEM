function [area,g1x,g1y,g2x,g2y,g3x,g3y]=trgInfo(p,t)
%PDETRG Triangle geometry data.
%
% [AR,G1X,G1Y,G2X,G2Y,G3X,G3Y]=trgInfo(P,T) returns the area and the
% compoents of the gradient of the triangle P1 - shape functions.
%

% Indices of the corner point
a1=t(1,:);
a2=t(2,:);
a3=t(3,:);

% lines segments of the triangles
l23x=p(1,a3)-p(1,a2);
l23y=p(2,a3)-p(2,a2);
l31x=p(1,a1)-p(1,a3);
l31y=p(2,a1)-p(2,a3);
l12x=p(1,a2)-p(1,a1);
l12y=p(2,a2)-p(2,a1);

% Area of each triangle
area=abs(l31x.*l23y-l31y.*l23x)/2;

% Gradient of each triangle
g1x=-0.5*l23y./area;
g1y=0.5*l23x./area;
g2x=-0.5*l31y./area;
g2y=0.5*l31x./area;
g3x=-0.5*l12y./area;
g3y=0.5*l12x./area;
end