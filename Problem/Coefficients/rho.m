function [rho] = rho(s)
% rho Routine for returning the coefficients for each triangle
%rho(p,tt,rhval,dist)
p = s.MESH.fine.p;
tt = s.MESH.fine.t;

    gx = (1/3) * ( p(1,tt(1,:)) + p(1,tt(2,:)) + p(1,tt(3,:)) );
    gy = (1/3) * ( p(2,tt(1,:)) + p(2,tt(2,:)) + p(2,tt(3,:)) );
    nt = size(tt, 2);                  % number of triangles.
    rho = 1.0*ones(1,nt);
    for i=1:nt
       % rho(i)=bfun([gx(i) gy(i)],rhval); 
       rho(i) = feval(s.rhofile, [gx(i) gy(i)],s);
    end

end


   