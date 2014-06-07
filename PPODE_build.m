function PPODE_build(infile, outfile, varargin)
%PPODE_BUILD   Build the ODE source file.
%   PPODE_BUILD(infile, outifle, options) builds the ODE source file 
%   given by infile against the PPODE libraries. The result is a MEX 
%   function by the name of outfile. Infile should include the correct 
%   extension, outfile should not specify an extension.
%   
%   ARGUMENTS:
%      'infile' The input fortran file defining the ODEs of the problem.
%               This filename should include a file extension.
%     'outfile' The output MEX file. This filename should not include a
%               file extension. The appropriate extension will 
%               automaticly be added.
%   OPTIONS:
%       'DEBUG' Controls whether the libraries should be build using 
%               the debug flag. 1 to enable, 0 to disable.
%     'VERBOSE' Sets the verbose output mode. 1 to enable, 0 to disable.
%      'SOLVER' Specifies the solver to be used for the problem. 
%               Available solvers are:
%                'STIFF' (or 'BDF'):
%                  LSODE: Backward Differential Formulas [1-5] (Stiff)
%                'STIFF2' (or 'VODE'):
%                  VODE: Backward Differential Formulas [1-5] (Stiff)
%                'NON-STIFF' (or 'ADAMS-MOULTON'):
%                  LSODE: Adams Moulton Method [1-12] (Non-Stiff)
%                'NON-STIFF2' (or 'VODEAM'):
%                  VODE: Adams Moulton Method [1-12] (Non-Stiff)
%                'SWITCHING' (or 'LSODA'):
%                  LSODA: Adaptive method, switching between:
%                  (a) Backward Differential Formulas [1-5] (Stiff) and 
%                  (b) Adams Moulton Method [1-12] (Non-Stiff)
%                'MEBDFSO' (or 'MEBDFSparse'):
%                  MEBDFSO: Modified Extended Backward Differential
%                  Formulas using a Sparse Jacobian Matrix [1-5] (Stiff)
%                'LSODES' (or 'BDFSparse'):
%                  LSODES: Backward Differential Formulas
%                  using a Sparse Jacobian Matrix [1-5] (Stiff)
%                'LSODAS' (or 'SWITCHINGSPARSE'):
%                  LSODAS: Adaptive method, switching between:
%                  (a) Sparse Jacobian BDF [1-5] (Stiff) and 
%                  (b) Adams Moulton Method [1-12] (Non-Stiff)
%                'AUTO' (or 'AUTOSWITCHING'): (DEFAULT)
%                  Automatically chooses between LSODA and LSODAS.
%                'RK23':
%                  RKSUITE: Runge-Kutta Methods [2-3] (Non-Stiff)
%                'RK45':
%                  RKSUITE: Runge-Kutta Methods [4-5] (Non-Stiff)
%                'RK78':
%                  RKSUITE: Runge-Kutta Methods [7-8] (Non-Stiff)
%    'MAXSTEPS' Set the maximum number of integration steps for each 
%               time step. The default value is 1000 steps for all
%               solvers. The value 'high' will set the maximum number of
%               steps to 42e7, which will probably not cause the solver
%               to abort due to the maximum number of steps. If the
%               number contains an imaginary part, the solver will 
%               enable an intelligent distribution for determining the
%               maximum number of steps. imag(value) should then give
%               the maximum number of steps per time unit. The
%               intelligent maxsteps feature might be useful when using
%               a not evenly distributed (e.g. exponential) sequence.
%               The option maxsteps is not available for the Runge-Kutta
%               solver.
%      'TIMING' Enable per step timing of the integration. This option
%               will require an extra output argument for the generated
%               function.
%    'MAXORDER' The maximum order the solution algorithm should take. 
%               For all (modified-)BDF algorithms the default value is
%               5, whereas the Adams-Moulton algorithm has a default
%               maximum order of 12. The order can not exceed the
%               respective default values. This option is not available
%               for the Runge-Kutta methods, since these are specified
%               in specific pairs of orders (2-3, 4-5 or 7-8). For the
%               switching solver 2 maximum orders can be set using a
%               vector. The first element of this vector should specify
%               the maximum order of the BDF algorithm, the second
%               element should specify the maximum order of the Adams-
%               Moulton algorithm.
%     'MAXTIME' The maximum time the complete evaluation is allowed to
%               take. By default there is no maximum. A scalar value
%               represents a number of seconds. A vector of length 2
%               represents minutes and seconds ([min sec]). A vector of
%               length 3 represents the number of hours, minutes and
%               seconds ([hr min sec]). Please note that checks of the
%               evaluation time only take place on the output time
%               points. Therefore the evaluation might actually go on
%               significantly longer than specified here.
%      'ANAJAC' Whether to use the analytical Jacobian function. If set
%               to 1, the analytical Jacobian, generated by the Matlab to
%               Fortran translator, will be used. When set to 0
%               (default) the solver will use a numerical approximation.
%               Setting this option for Non-Stiff solvers makes no 
%               sense.
%    'INPUTNNZ' Whether to require Number of Non-Zero elements (NNZ) as
%               input argument. If set to 1, the Number of EQuations
%               (NEQ) argument should be a vector of which the fist
%               element is the NEQ and the second element the NNZ. If
%               set to 0 (default), the NNZ will be calculated using the
%               generated analytical jacobian.
%
%   EXAMPLE USAGE:
%     PPODE_BUILD('ode.F', 'odeADAMS', 'Solver', 'Adams-Moulton')
%       Generates a Adams-Moulton solver for the problem ode.F.
%
%   AUTHOR:
%     Pascal Pieters <p.a.pieters@student.tue.nl>
%

% Make sure all PPODE matlab functions are available.
PPODE_addPaths

% Define all paths etcetera.
[basedir, ~, ~] = fileparts(mfilename('fullpath'));
builddir = fullfile(basedir, 'build');
libdir = fullfile(basedir, 'lib');
fortranext = '.F';
buildext = '.o';
libext = '.a';

% The default flags for mex and the fortran compiler.
mexfflags = '-fPIC -llapack -lblas';
mexflags = '';

%% Handle the options passed to the function.
opts = {'VERBOSE','DEBUG','MAXSTEPS','SOLVER','TIMING','MAXORDER', ...
        'MAXTIME', 'ANAJAC', 'INPUTNNZ'};
defaults = {0, 0, 0, 'AUTO',0,0, ...
            0, 0, 0};

values = PPODE_getProperties(opts, defaults, varargin);

verbose = values('VERBOSE');
debug = values('DEBUG');

solver = PPODE_getSolver(values('SOLVER'));
if solver.error
    error('ERROR: Unknown solver.')
end

%% Maxorder
maxorder = values('MAXORDER');
if sum(solver.maxorder == -1) && (sum(maxorder) ~= 0)
    error(['The specified solver does not allow the '...
            'specification of a maximum order.']);
end
if maxorder == 0
    maxorder = zeros(length(solver.maxorder), 1);
end
if length(solver.maxorder) ~= length(maxorder)
    error(['The number of maximum orders specified does not '...
            'match the amount required by the solver.']);
end
for i=1:length(solver.maxorder)
    if maxorder(i) == 0
        maxorder(i) = solver.maxorder(i);
    elseif maxorder(i) > solver.maxorder(i)
        error(['The maximum order specified exceeds the maximum '...
                'order allowed by the solver.']);
    end
end

% Maxsteps
maxsteps = 0;
if values('MAXSTEPS') ~= 0
    if strcmpi(values('MAXSTEPS'), 'HIGH')
        maxsteps = int32(42e7);
    else
        maxsteps = values('MAXSTEPS');
    end
end

% Maxsteps
maxtime = 0;
if sum(values('MAXTIME')) ~= 0
    mt = values('MAXTIME');
    if length(mt) <= 3
        if length(mt) == 3
            maxtime = maxtime + mt(3)*60*60;
        end
        if length(mt) >= 2
            maxtime = maxtime + mt(2)*60;
        end
        maxtime = maxtime + mt(1);
    else
        error('Invalid maximum time value.');
    end
end

% Verbose mode
if verbose
    fprintf('Building the PPODE solver of choice.\n');
    fprintf('Verbose   : On\n');
    fprintf('Solver    : %s', linewrap(solver.name, 10));
    if debug
        fprintf('Debug     : On\n');
    end
    if values('TIMING')
        fprintf('Timing    : On\n');
    end
    if maxorder
        fprintf('Maxord    : %d\n', maxorder);
    end
    if maxsteps ~= 0
        fprintf('Maxsteps  : %d\n', maxsteps);
    end
    if maxtime
        fprintf('Maxtime   : %f s\n', maxtime);
    end
    if values('ANAJAC')
        fprintf('AnaJac    : on\n');
    end
    if values('INPUTNNZ')
        fprintf('Input NNZ : on\n');
    end
end

libnames = solver.libs;
interfacedep = solver.interface;

% Defs
fid = fopen(fullfile(builddir, 'defs.h'), 'w');

for i=solver.defs
    fprintf(fid, '#define %s\n', i{1});
end

if (maxsteps ~= 0) || debug
    fprintf(fid, '#define OPTIONALINPUTS\n');
    if debug
        fprintf(fid, '#define DEBUG\n');
    end
    if maxsteps ~= 0
        if imag(maxsteps) == 0
            fprintf(fid, '#define MAXSTEPS %d\n', maxsteps);
        else
            fprintf(fid, '#define IMAXSTEPS %E\n', imag(maxsteps));
        end
    end
end

for i=1:length(maxorder)
    if maxorder(i) ~= 0
        fprintf(fid, '#define MAXORDER%d %d\n', i, maxorder(i));
    end
end

if maxtime
    fprintf(fid, '#define MAXTIME %E\n', maxtime);
end

if values('TIMING')
    fprintf(fid, '#define TIMING\n');
end

if values('ANAJAC')
    fprintf(fid, '#define USERSUPPLIEDJAC\n');
end

if values('INPUTNNZ')
    fprintf(fid, '#define INPUTNONZERO\n');
end

fclose(fid);

libstr = '';
for i=1:length(libnames)
    if ~exist(fullfile(libdir, [libnames{i} libext]))
        error(sprintf('Could not find the %s library.\n Try executing PPODE_init to build the PPODE libraries.', libnames{i}));
    end
    libstr = [libstr '''' fullfile(libdir, [libnames{i} libext]) ''' '];
end
libstr = libstr(1:end-1);

if verbose
    fprintf('Libs      : %s', linewrap(libstr, 12));
end

interfacedir = fullfile(basedir, 'src', 'interface');

%% Create the directories directory
[stat, ~, ~] = mkdir(builddir);
if ~stat
    error('Could not create the ''build'' directory.');
end

%% Dependency check
sourcefiles = '';
for i=1:length(interfacedep)
    % Source files
    f = fullfile(interfacedir, [interfacedep{i} fortranext]);
    sourcefiles = [sourcefiles '''' f ''' '];

    if ~exist(f, 'file')
        error('Missing interface dependencies.');
    end
end

insource = fullfile(pwd, infile);
if ~exist(insource)
    error('Input file not found.')
end
sourcefiles = [sourcefiles '''' insource ''''];

outmex = fullfile(pwd, outfile);

% Set the correct flags for each option.
if debug
    mexflags = [mexflags ' -g'];
else
    mexfflags = [mexfflags ' -O2'];
end

if verbose
    mexflags = [mexflags ' -v'];
else
    mexfflags = [mexfflags ' -w'];
end

eval(sprintf('mex %s %s -I''%s'' -o ''%s'' FFLAGS=''$FFLAGS %s'' %s', mexflags, sourcefiles, builddir, outmex, mexfflags, libstr));

end