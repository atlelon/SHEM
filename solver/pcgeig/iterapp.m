function y = iterapp(afun,atype,afcnstr,x,varargin)
%ITERAPP   Apply matrix operator to vector and error gracefully.
%   ITERAPP(AFUN,ATYPE,AFCNSTR,X) applies matrix operator AFUN to vector X.
%   ATYPE and AFCNSTR are used in case of error.
%   ITERAPP(AFUN,ATYPE,AFCNSTR,X,...) allows extra arguments to AFUN(X,...).
%   ITERAPP is designed for use by iterative methods like PCG which
%   require matrix operators AFUN representing matrices A to operate on
%   vectors X and return A*X and may also have operators MFUN representing
%   preconditioning matrices M operate on vectors X and return M\X.
%
%   See also BICG, BICGSTAB, CGS, GMRES, PCG, QMR.

%   Penny Anderson, 1998.
%   Copyright 1984-2001 The MathWorks, Inc. 
%   $Revision: 1.6 $ $Date: 2001/04/15 12:00:19 $

try
   y = feval(afun,x,varargin{:});      
catch
   es = sprintf(['user supplied %s ==> %s\n' ...
         'failed with the following error:\n\n%s'],atype,afcnstr,lasterr);
   error(es);
end

if (size(y,2) ~= 1)
   es = sprintf(['user supplied %s ==> %s\n' ...
         'must return a column vector.'],atype,afcnstr);
   error(es)
end

return
