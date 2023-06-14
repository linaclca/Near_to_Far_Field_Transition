function [gt,relres,iter]=gabopttight(g,a,M,varargin)
%GABOPTTIGHT  Compute a optimized tight window
%   Usage: gt=gabopttight(Ltight,g,a,M);
%          gt=gabopttight(Ltight,g,a,M, varagin);
%
%   Input parameters:
%     g      : Initial window function
%     a      : Time shift
%     M      : Number of Channels
%
%   Output parameters:
%     gt     : Tight window
%
%   GABOPTTIGHT(g,a,M) computes a tight window gt for a frame of
%   parameter a and M
%
%   This function solves a convex optimization problem that can be written
%   as:
%
%      gd  = argmin_x    || alpha x||_1 +  || beta Fx||_1  
%
%                      + || omega (x -g_l) ||_2^2 + delta || x ||_S0
%
%                      + gamma || nabla F x ||_2^2 + mu || nabla x ||_2^2
%
%          such that  x is a tight window
%
%   *Note**: This function require the unlocbox. You can download it at
%   http://unlocbox.sourceforge.net
%
%   The function uses an iterative algorithm to compute the approximate
%   optimized tight window. Warning The algorithm solve a non convex
%   problem and might be stack in bad local minima.  The algorithm can be
%   controlled by the following flags: 
%
%     'alpha',alpha  Weight in time. If it is a scalar, it represent the
%                  weights of the entire L1 function in time. If it is a 
%                  vector, it is the associated weight assotiated to each
%                  component of the L1 norm (length: Ldual).
%                  Default value is alpha=0.
%                  *Warning**: this value should not be too big in order to
%                  avoid the the L1 norm proximal operator kill the signal.
%                  No L1-time constraint: alpha=0
%
%     'beta',beta  Weight in frequency. If it is a scalar, it represent the
%                  weights of the entire L1 function in frequency. If it is a 
%                  vector, it is the associated weight assotiated to each
%                  component of the L1 norm in frequency. (length: Ldual).
%                  Default value is beta=0.
%                  *Warning**: this value should not be too big in order to
%                  avoid the the L1 norm proximal operator kill the signal.
%                  No L1-frequency constraint: beta=0
%
%     'omega',omega  Weight in time of the L2-norm. If it is a scalar, it represent the
%                  weights of the entire L2 function in time. If it is a 
%                  vector, it is the associated weight assotiated to each
%                  component of the L2 norm (length: Ldual).
%                  Default value is omega=0.
%                  No L2-time constraint: omega=0
%
%     'glike',g_l  g_l is a windows in time. The algorithm try to shape
%                  the dual window like g_l. Normalization of g_l is done
%                  automatically. To use option omega should be different
%                  from 0. By default g_d=0.
%
%     'mu', mu     Weight of the smooth constraint Default value is 1. 
%                  No smooth constraint: mu=0
%   
%     'gamma', gamma  Weight of the smooth constraint in frequency. Default value is 1. 
%                  No smooth constraint: gamma=0
%   
%     'delta', delta  Weight of the S0-norm. Default value is 0. 
%                  No S0-norm: delta=0
%
%     'dual'       Look for a dual windows (default)
%
%     'painless'   Construct a starting guess using a painless-case
%                  approximation. This is the default
%
%     'zero'       Choose a starting guess of zero.
%
%     'rand'       Choose a random starting phase.
%
%     'tol',t      Stop if relative residual error is less than the 
%                  specified tolerance.  
%
%     'maxit',n    Do at most n iterations. default 200
%
%     'print'      Display the progress.
%
%     'debug'      Display all the progresses.
%
%     'quiet'      Don't print anything, this is the default.
%
%     'fast'       Fast algorithm, this is the default.
%
%     'slow'       Safer algorithm, you can try this if the fast algorithm
%                  is not working. Before using this, try to iterate more.
%
%     'printstep',p  If 'print' is specified, then print every p'th
%                    iteration. Default value is p=10;
%
%     'hardconstraint' Force the projection at the end (default)
%
%     'softconstaint' Do not force the projection at the end
%
%   See also: gabfirdual, gabdual, gabtight, gaboptdual, gabconvexopt
%
%   Url: http://ltfat.github.io/doc/gabor/gabopttight.html

% Copyright (C) 2005-2018 Peter L. Soendergaard <peter@sonderport.dk> and others.
% This file is part of LTFAT version 2.4.0
%
% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program.  If not, see <http://www.gnu.org/licenses/>.
  


% Author: Nathanael Perraudin
% Date  : 18 Feb 2014

if nargin<3
  error('%s: Too few input parameters.',upper(mfilename));
end;

if 0
    gt=g;
    for ii=1:50
     gt=gabconvexopt(gt,a,M,varargin{:},'quiet','dual');
     figure(1);
     plot(abs(gt));
     drawnow
     
     fprintf('Error at iteration %i: %g\n',ii,gabdualnorm(gt,gt,a,M,length(gt)));
    end
    gt=gabconvexopt(g,a,M,'alpha',0,'beta',0,'gamma',0,'mu',0,'omega',0, 'tight');
else

[gt,relres,iter]=gabconvexopt(g,a,M,varargin{:}, 'tight');

end
end

