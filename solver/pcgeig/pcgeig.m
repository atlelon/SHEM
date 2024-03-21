function [x,flag,relres,iter,resvec,eigest] = ...
                                    pcgeig(A,b,tol,maxit,M1,M2,x0,varargin)
%PCGEIG Preconditioned Conjugate Gradients Method
%
%%---------------------------------------------------------------------------%
%   The routine PCGEIG is an extension of Matlab's PCG routine including
%   an extra feature to calculate estimates for the extremal eigenvalues
%   and the condition number of the coefficient matrix A (inv(M)*A or 
%   inv(M1)*A*inv(M2) if preconditioned, where M = M1*M2). See the book
%   'Matrix Computations' of Golub & Van Loan for the algorithm.
%%---------------------------------------------------------------------------%
%
%   X = PCGEIG(A,B) attempts to solve the system of linear equations A*X=B
%   for X.  The N-by-N coefficient matrix A must be symmetric and positive
%   definite and the right hand side column vector B must have length N.
%   A may be a function returning A*X.
%
%   PCGEIG(A,B,TOL) specifies the tolerance of the method.  If TOL is []
%   then PCGEIG uses the default, 1e-6.
%
%   PCGEIG(A,B,TOL,MAXIT) specifies the maximum number of iterations.  If
%   MAXIT is [] then PCGEIG uses the default, min(N,20).
%
%   PCGEIG(A,B,TOL,MAXIT,M) and PCGEIG(A,B,TOL,MAXIT,M1,M2) use symmetric
%   positive definite preconditioner M or M=M1*M2 and effectively
%   solve the system inv(M)*A*X = inv(M)*B for X.  If M is [] then
%   a preconditioner is not applied.  M may be a function returning M\X.
%
%   PCGEIG(A,B,TOL,MAXIT,M1,M2,X0) specifies the initial guess.  If X0 is []
%   then PCGEIG uses the default, an all zero vector.
%
%   PCGEIG(AFUN,B,TOL,MAXIT,M1FUN,M2FUN,X0,P1,P2,...) passes parameters 
%   P1,P2,... to functions: AFUN(X,P1,P2,...), M1FUN(X,P1,P2,...), 
%   M2FUN(X,P1,P2,...).
%
%   [X,FLAG] = PCGEIG(A,B,TOL,MAXIT,M1,M2,X0) also returns a convergence FLAG:
%    0 PCGEIG converged to the desired tolerance TOL within MAXIT iterations
%    1 PCGEIG iterated MAXIT times but did not converge.
%    2 preconditioner M was ill-conditioned.
%    3 PCGEIG stagnated (two consecutive iterates were the same).
%    4 one of the scalar quantities calculated during PCGEIG became too
%      small or too large to continue computing.
%
%   [X,FLAG,RELRES] = PCGEIG(A,B,TOL,MAXIT,M1,M2,X0) also returns the
%   relative residual NORM(B-A*X)/NORM(B).  If FLAG is 0, RELRES <= TOL.
%
%   [X,FLAG,RELRES,ITER] = PCGEIG(A,B,TOL,MAXIT,M1,M2,X0) also returns the
%   iteration number at which X was computed: 0 <= ITER <= MAXIT.
%
%   [X,FLAG,RELRES,ITER,RESVEC] = PCGEIG(A,B,TOL,MAXIT,M1,M2,X0) also returns
%   a vector of the residual norms at each iteration including NORM(B-A*X0).
%
%%---------------------------------------------------------------------------%
%   [X,FLAG,RELRES,ITER,RESVEC,EIGEST] = PCGEIG(A,B,TOL,MAXIT,M1,M2,X0) also 
%   returns a vector of three elements containing estimates for the maximum 
%   and the minimum eigenvalue, respectively, and their ratio.
%%---------------------------------------------------------------------------%
%
%   Example:
%      n = 51; on = ones(n,1); A = spdiags([-2*on 4*on -2*on],-1:1,n,n);
%      b = sum(A,2); tol = 1e-6; maxit = 50; M1 = spdiags(4*on,0,n,n);
%      [x,flag,rr,iter,rv,ev] = pcgeig(A,b,tol,maxit,M1);
%
%   See also PCG, BICG, BICGSTAB, CGS, GMRES, 
%            LSQR, MINRES, QMR, SYMMLQ, CHOLINC, @.

%   Penny Anderson, 1996.
%   Copyright 1984-2001 The MathWorks, Inc.
%   $Revision: 1.17 $ $Date: 2001/04/15 12:00:15 $

%%---------------------------------------------------------------------------%
%   Talal Rahman, 1997.
%   Extended the original PCG routine to include estimation of the extremal
%   eigenvalues and the condition number of the coefficient matrix as an
%   extra feature.
%%---------------------------------------------------------------------------%

if (nargin < 2)
   error('Not enough input arguments.');
end

%----------------------------------------------------------------------------%
if (nargout == 6), eigout = 1; else eigout = 0; end
%----------------------------------------------------------------------------%

% Determine whether A is a matrix, a string expression,
% the name of a function or an inline object.
[atype,afun,afcnstr] = iterchk(A);
if isequal(atype,'matrix')
   % Check matrix and right hand side vector inputs have appropriate sizes
   [m,n] = size(A);
   if (m ~= n)
      error('Matrix must be square.');
   end
   if ~isequal(size(b),[m,1])
      es = sprintf(['Right hand side must be a column vector of' ...
            ' length %d to match the coefficient matrix.'],m);
      error(es);
   end
else
   m = size(b,1);
   n = m;
   if (size(b,2) ~= 1)
      error('Right hand side must be a column vector.');
   end
end

% Assign default values to unspecified parameters
if (nargin < 3) | isempty(tol)
   tol = 1e-6;
end
if (nargin < 4) | isempty(maxit)
   maxit = min(n,20);
end

% Check for all zero right hand side vector => all zero solution
n2b = norm(b);                      % Norm of rhs vector, b
if (n2b == 0)                       % if    rhs vector is all zeros
   x = zeros(n,1);                  % then  solution is all zeros
   flag = 0;                        % a valid solution has been obtained
   relres = 0;                      % the relative residual is actually 0/0
   iter = 0;                        % no iterations need be performed
   resvec = 0;                      % resvec(1) = norm(b-A*x) = norm(0)      
   if (nargout < 2)
      itermsg('pcgeig',tol,maxit,0,flag,iter,NaN);
   end
   return
end

if ((nargin >= 5) & ~isempty(M1))
   existM1 = 1;
   [m1type,m1fun,m1fcnstr] = iterchk(M1);
   if isequal(m1type,'matrix')
      if ~isequal(size(M1),[m,m])
         es = sprintf(['Preconditioner must be a square matrix' ...
               ' of size %d to match the problem size.'],m);
         error(es);
      end      
   end   
else
   existM1 = 0;
   m1type = 'matrix';
end

if ((nargin >= 6) & ~isempty(M2))
   existM2 = 1;
   [m2type,m2fun,m2fcnstr] = iterchk(M2);
   if isequal(m2type,'matrix')
      if ~isequal(size(M2),[m,m])
         es = sprintf(['Preconditioner must be a square matrix' ...
               ' of size %d to match the problem size.'],m);
         error(es);
      end
   end
else
   existM2 = 0;
   m2type = 'matrix';
end

if ((nargin >= 7) & ~isempty(x0))
   if ~isequal(size(x0),[n,1])
      es = sprintf(['Initial guess must be a column vector of' ...
            ' length %d to match the problem size.'],n);
      error(es);
   else
      x = x0;
   end
else
   x = zeros(n,1);
end

if ((nargin > 7) & isequal(atype,'matrix') & ...
      isequal(m1type,'matrix') & isequal(m2type,'matrix'))
   error('Too many input arguments.');
end

% Set up for the method
flag = 1;
xmin = x;                          % Iterate which has minimal residual so far
imin = 0;                          % Iteration at which xmin was computed
tolb = tol * n2b;                  % Relative tolerance
if isequal(atype,'matrix')
   r = b - A * x;                  % Zero-th residual
else
   r = b - iterapp(afun,atype,afcnstr,x,varargin{:});
end
normr = norm(r);                   % Norm of residual

if (normr <= tolb)                 % Initial guess is a good enough solution
   flag = 0;
   relres = normr / n2b;
   iter = 0;
   resvec = normr;
   if (nargout < 2)
      itermsg('pcgeig',tol,maxit,0,flag,iter,relres);
   end
   return
end

%----------------------------------------------------------------------------%
if eigout
% Set up the extra vectors needed for extremal eigen value computation.
diagpap = [];                            % Diag(p_i'*A*p_i)
betapar = [];                            % Beta parameter
delta   = [];                            % Residual norms
T = spalloc( maxit, maxit, 3*maxit-2 );  % Tridiagonal matrix
end
%----------------------------------------------------------------------------%

resvec = zeros(maxit+1,1);         % Preallocate vector for norm of residuals
resvec(1) = normr;                 % resvec(1) = norm(b-A*x0)
normrmin = normr;                  % Norm of minimum residual
rho = 1;
stag = 0;                          % stagnation of the method

% loop over maxit iterations (unless convergence or failure)

for i = 1 : maxit
   if existM1
      if isequal(m1type,'matrix')
         y = M1 \ r;
      else
         y = iterapp(m1fun,m1type,m1fcnstr,r,varargin{:});
      end
      if isinf(norm(y,inf))
         flag = 2;
         break
      end
   else % no preconditioner
      y = r;
   end
   
   if existM2
      if isequal(m2type,'matrix')
         z = M2 \ y;
      else
         z = iterapp(m2fun,m2type,m2fcnstr,y,varargin{:});
      end
      if isinf(norm(z,inf))
         flag = 2;
         break
      end
   else % no preconditioner
      z = y;
   end
   
   rho1 = rho;
   rho = r' * z;

%----------------------------------------------------------------------------%
   if eigout
   delta = [delta sqrt( rho )];
   end
%----------------------------------------------------------------------------%

   if ((rho == 0) | isinf(rho))
      flag = 4;
      break
   end
   if (i == 1)
      p = z;
   else
      beta = rho / rho1;
      if ((beta == 0) | isinf(beta))
         flag = 4;
         break
      end
      p = z + beta * p;

%----------------------------------------------------------------------------%
      if eigout
      betapar = [betapar beta];
      end
%----------------------------------------------------------------------------%

   end
   if isequal(atype,'matrix')
      q = A * p;
   else
      q = iterapp(afun,atype,afcnstr,p,varargin{:});         
   end
   pq = p' * q;

%----------------------------------------------------------------------------%
   if eigout
   diagpap = [diagpap pq];
   end
%----------------------------------------------------------------------------%

%----------------------------------------------------------------------------%
   if eigout
   % Update the tridiagonal matrix whose extremal eigen values will give
   % an approximation of the extremal eigen values of the original system.
   [T,k] = cgeigr( T, i, delta, betapar, diagpap );
   end
%----------------------------------------------------------------------------%

   if ((pq <= 0) | isinf(pq))
      flag = 4;
      break
   else
      alpha = rho / pq;
   end
   if isinf(alpha)
      flag = 4;
      break
   end
   if (alpha == 0)                  % stagnation of the method
      stag = 1;
   end
   
   % Check for stagnation of the method
   if (stag == 0)
      stagtest = zeros(n,1);
      ind = (x ~= 0);
      stagtest(ind) = p(ind) ./ x(ind);
      stagtest(~ind & p ~= 0) = Inf;
      if (abs(alpha)*norm(stagtest,inf) < eps)
         stag = 1;
      end
   end
   
   x = x + alpha * p;               % form new iterate
   if isequal(atype,'matrix')
      normr = norm(b - A * x);
   else
      normr = norm(b - iterapp(afun,atype,afcnstr,x,varargin{:}));
   end
   resvec(i+1) = normr;
   
   if (normr <= tolb)               % check for convergence
      flag = 0;
      iter = i;
      break
   end
   
   if (stag == 1)
      flag = 3;
      break
   end
   
   if (normr < normrmin)           % update minimal norm quantities
      normrmin = normr;
      xmin = x;
      imin = i;
   end
   
   r = r - alpha * q;
   
end                                % for i = 1 : maxit

% returned solution is first with minimal residual
if (flag == 0)
   relres = normr / n2b;
else
   x = xmin;
   iter = imin;
   relres = normrmin / n2b;
end

% truncate the zeros from resvec
if ((flag <= 1) | (flag == 3))
   resvec = resvec(1:i+1);
else
   resvec = resvec(1:i);
end

% only display a message if the output flag is not used
if (nargout < 2)
   itermsg('pcgeig',tol,maxit,i,flag,iter,relres);   
end

%----------------------------------------------------------------------------%
if eigout
% Extremal eigen values (condition number) estimates of the system.
opt.disp  = 0;
opt.maxit = 100;
opt.tol   = 1e-9;
opt.issym = 1;
% eigest= 0;
eigest    = eigs( T(1:k,1:k), 1, 'LM', opt );           % Largest e.v.
eigest    = [eigest eigs( T(1:k,1:k), 1, 'SM', opt )];  % Smallest e.v.
eigest    = [eigest eigest(1)/eigest(2)];               % Condition number
end
%----------------------------------------------------------------------------%

return

%----------------------------------------------------------------------------%
function [T,k,e] = cgeigr( T, k, delta, beta, pap )
% CGEIGR Returns the k-th symmetric tridiagonal matrix T associated with
%        the Lanczos vectors generated in the CG algorithm. See the book
%        'Matrix Computations' of Golub & Van Loan for the algorithm.

if (nargout == 3), feig = 1; else feig = 0; end

if k==1

   T(k,k) = pap(k) / (delta(k)^2) ;

else

   % Build the tridiagonal matrix T explicitly.
   % T_k is built from T_{k-1} by adding the k-th row and col.
   T(k,k-1) = -beta(k-1)*pap(k-1)/(delta(k)*delta(k-1));
   T(k-1,k) = T(k,k-1);
   T(k  ,k) = ((beta(k-1)^2)*pap(k-1) + pap(k))/(delta(k)^2);

end

% Return the extremal eigen values of T when requested.
if feig

   opt.disp  = 0; % Set the display to nodisplay.
   opt.maxit = 10;
   opt.tol   = 1e-6;
   opt.issym = 1;
   e = eigs( T(1:k,1:k), 1, 'LM', opt );
   e = [e eigs( T(1:k,1:k), 1, 'SM', opt )];

end

return
%----------------------------------------------------------------------------%
