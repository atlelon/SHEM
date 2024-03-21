function [atype,afun,afcnstr] = iterchk(A)
%ITERCHK  Checks arguments to iterative methods.
%   [ATYPE,AFUN,AFCNSTR] = ITERCHK(A) returns the following:
%   ATYPE is either 'matrix', 'function', 'expression' or 'inline object'.
%   AFUN is the function name or inline object.
%   AFUN is '' if ATYPE is 'matrix'.
%   AFCNSTR is the function name if ATYPE is 'function'.
%   AFCNSTR is the formula of the function if ATYPE is 'expression' or
%   'inline object'.  AFCNSTR is '' if ATYPE is 'matrix'.
%
%   See also BICG, BICGSTAB, CGS, GMRES, PCG, QMR.

%   Penny Anderson, 1998.
%   Copyright 1984-2001 The MathWorks, Inc. 
%   $Revision: 1.7 $ $Date: 2001/04/15 12:00:19 $


[afun,afunmsg] = fcnchk(A);
if isempty(afunmsg)
   if isa(afun,'inline')      
      if isa(A,'inline')
         atype = 'inline object';
      else
         atype = 'expression';
      end
      afcnstr = formula(afun);
   else % both function_handles @fun and function names 'fun'
      atype = 'function';
      if isa(A,'function_handle')
          afcnstr = func2str(A);
      else
          afcnstr = A;
      end
   end
elseif isa(A,'double')
   atype = 'matrix';
   afcnstr = '';
else
   error(['Argument must be a matrix, a function, or an inline object.']);
end

return
