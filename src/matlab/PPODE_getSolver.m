function solver = PPODE_getSolvers( name )
%PPODE_GETSOLVER Get solver information.
%   Returns a struct containing information about the solver given by 
%   the argument name.
%
%   ARGUMENTS:
%        'name' Shorthand name of the solver.
%
%   RETURNS:
%     The output takes the following form:
%      's.name' Comprehensive name of the solver.
%      's.libs' Libraries required by the solver.
% 's.interface' Interface files needed by the solver.
%      's.defs' Definitions to be passed to the preprocessor.
%     's.error' Specifies whether a solver with the specified name was 
%               found. true means not found, false means found.
%
%   EXAMPLE USAGE:
%     PPODE_GETSOLVER('STIFF')
%       Returns the specifications of the stiff (BDF) solver.
%

solver.error = false;

switch upper(name)
    case {'STIFF', 'BDF'}
        solver.name = ['LSODE: Backward Differential Formulas [1-5] '...
                      '(Stiff)'];
        solver.libs = {'ODEPACK'};
        solver.interface = {'lsodewrapper', 'ppodemex'};
        solver.defs = {'STIFFSOLVER', 'ODEPACK'};
        solver.maxorder = 5;
    case {'ADAMS-MOULTON', 'NON-STIFF'}
        solver.name = 'LSODE: Adams Moulton Method [1-12] (Non-Stiff)';
        solver.libs = {'ODEPACK'};
        solver.interface = {'lsodewrapper', 'ppodemex'};
        solver.defs = {'NONSTIFFSOLVER', 'ODEPACK'};
        solver.maxorder = 12;
    case {'SWITCHING', 'LSODA'}
        solver.name = ['LSODA: Adaptive method, switching between:'...
                      '(a) Backward Differential Formulas [1-5] '...
                      '(Stiff) and (b) Adams Moulton Method [1-12] '...
                      '(Non-Stiff)'];
        solver.libs = {'ODEPACK'};
        solver.interface = {'lsodewrapper', 'ppodemex'};
        solver.defs = {'SWITCHINGSOLVER', 'ODEPACK'};
        solver.maxorder = [5 12];
    case {'RK23'}
        solver.name = 'RKSUITE: Runge-Kutta Methods [2-3] (Non-Stiff)';
        solver.libs = {'RKSUITE'};
        solver.interface = {'rksuitewrapper', 'ppodemex'};
        solver.defs = {'RK23SOLVER', 'RKSUITE'};
        solver.maxorder = -1;
    case {'RK45'}
        solver.name = 'RKSUITE: Runge-Kutta Methods [4-5] (Non-Stiff)';
        solver.libs = {'RKSUITE'};
        solver.interface = {'rksuitewrapper', 'ppodemex'};
        solver.defs = {'RK45SOLVER', 'RKSUITE'};
        solver.maxorder = -1;
    case {'RK78'}
        solver.name = 'RKSUITE: Runge-Kutta Methods [7-8] (Non-Stiff)';
        solver.libs = {'RKSUITE'};
        solver.interface = {'rksuitewrapper', 'ppodemex'};
        solver.defs = {'RK78SOLVER', 'RKSUITE'};
        solver.maxorder = -1;
    case {'MEBDFSO', 'MEBDFSPARSE'}
        solver.name = ['MEBDFSO: Modified Extended Backward '...
                      'Differential Formulas using a Sparse Jacobian '...
                      'Matrix [1-5] (Stiff)'];
        solver.libs = {'MEBDFSO'};
        solver.interface = {'mebdfsowrapper', 'ppodemex'};
        solver.defs = {'MEBDFSOSOLVER', 'MEBDFSO'};
        solver.maxorder = 5;
    case {'VODE', 'STIFF2'}
        solver.name = ['VODE: Backward Differential Formulas [1-5] '...
                      '(Stiff)'];
        solver.libs = {'VODE'};
        solver.interface = {'vodewrapper', 'ppodemex'};
        solver.defs = {'VODESTIFFSOLVER', 'VODE'};
        solver.maxorder = 5;
    case {'VODEAM', 'NON-STIFF2'}
        solver.name = ['VODE: Adams Moulton Method [1-12] (Non-Stiff)'];
        solver.libs = {'VODE'};
        solver.interface = {'vodewrapper', 'ppodemex'};
        solver.defs = {'VODENONSTIFFSOLVER', 'VODE'};
        solver.maxorder = 12;
    case {'BDFSPARSE', 'LSODES'}
        solver.name = ['LSODES: Backward Differential '...
                      'Formulas using a Sparse Jacobian Matrix'...
                      '[1-5] (Stiff)'];
        solver.libs = {'ODEPACK'};
        solver.interface = {'lsodewrapper', 'ppodemex'};
        solver.defs = {'BDFSPARSESOLVER', 'ODEPACK'};
        solver.maxorder = 5;
    case {'SWITCHINGSPARSE', 'LSODAS'}
        solver.name = ['LSODAS: Backward Differential '...
                      'Formulas using a Sparse Jacobian Matrix'...
                      '[1-5] (Stiff)'];
        solver.libs = {'ODEPACK'};
        solver.interface = {'lsodewrapper', 'ppodemex'};
        solver.defs = {'SWITCHINGSPARSESOLVER', 'ODEPACK'};
        solver.maxorder = [5 12];
    otherwise
        solver.error = true;
end

end

