function a = assemai( p, t, rho )
% ASSEMAI Assembles stiffness a. 
%
%         a = assemai( p, t, rho ) assembles the stiffness matrix a.
%
%         The input parameters p (point matrix) and t (element matrix) 
%         have the same meaning as in matlab's assempde().

np = size( p, 2 );  % Number of points.

% Vertex point indices.
it1=t(1,:);
it2=t(2,:);
it3=t(3,:);

% Coefficient rho for the triangles.
itrho = rho;
% Triangle geometries:
[ar,g1x,g1y,g2x,g2y,g3x,g3y] = trgInfo( p, t );

% Stiffness matrix.
c3 = ((g1x.*g2x+g1y.*g2y).*ar.*itrho);
c1 = ((g2x.*g3x+g2y.*g3y).*ar.*itrho);
c2 = ((g3x.*g1x+g3y.*g1y).*ar.*itrho);

% Assemble integral contribution for the stiffness.
a =     sparse( it1, it2, c3,     np, np );
a = a + sparse( it2, it3, c1,     np, np);
a = a + sparse( it3, it1, c2,     np, np);
a = a + a.';
a = a + sparse( it1, it1, -c2-c3, np, np);
a = a + sparse( it2, it2, -c3-c1, np, np);
a = a + sparse( it3, it3, -c1-c2, np, np);
end