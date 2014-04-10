function PPODE_init(varargin)
%PPODE_INIT   Build PPODE libraries. 
%   PPODE_INIT(options) builds the various libraries needed by the 
%   solvers included in the PPODE package. Options can be provided to 
%   control the compilation.
%   
%   OPTIONS:
%       'DEBUG' Controls whether the libraries should be build using 
%               the debug flag. 1 to enable, 0 to disable.
%     'VERBOSE' Sets the verbose output mode. 1 to enable, 0 to disable.
%
%   EXAMPLE:
%     PPODE_INIT('Verbose', 1, 'Debug', 0)
%       This enables the verbose mode, but disables debugging.
%
%   AUTHOR:
%     Pascal Pieters <p.a.pieters@student.tue.nl>
%

% Make sure all PPODE matlab functions are available.
PPODE_addPaths

% Define all libraries, files, etcetera.
libnames = {'ODEPACK', 'RKSUITE', 'MEBDFSO', 'VODE', 'LSODAS'};
libdeps = {{'opkdmain', 'opkda1', 'opkda2'}, {'rksuite'}, {'yale', 'helpers', 'mebdfso'}, {'vode', 'helpers'},{'lsodas','opkda1','opkda2'}};

[basedir, ~, ~] = fileparts(mfilename('fullpath'));
builddir = fullfile(basedir, 'build');
libdir = fullfile(basedir, 'lib');
fortranext = '.F';
buildext = '.o';
libext = '.a';

% General files
genlibname = 'general';
gendep = {'extramath'};
genlibsourcedir = fullfile(basedir, 'src', genlibname);

% The default flags for mex and the fortran compiler.
mexfflags = '-fPIC';
mexflags = '';

%% Handle the options passed to the function.
opts = {'VERBOSE','DEBUG'};
defaults = {0, 0};

values = PPODE_getProperties(opts, defaults, varargin);

verbose = values('VERBOSE');
debug = values('DEBUG');

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

%% Build all libraries.
for curlibi=1:length(libnames)
    libname = libnames{curlibi};
    libdep = libdeps{curlibi};

    if verbose
        fprintf('Building the %s library.\n', libname);
    end

    libsourcedir = fullfile(basedir, 'src', libname);

    % Create the directories.
    [stat, ~, ~] = mkdir(builddir);
    if ~stat
        error('Could not create the ''build'' directory.');
    end
    [stat, ~, ~] = mkdir(libdir);
    if ~stat
        error('Could not create the ''lib'' directory.');
    end

    % Dependency check.
    sourcefiles = '';
    buildfiles = '';
    for i=1:length(libdep)
        % Source files.
        f = fullfile(libsourcedir, [libdep{i} fortranext]);
        sourcefiles = [sourcefiles '''' f ''' '];

        if ~exist(f, 'file')
            error(['Missing ''' libname ''' dependencies.']);
        end

        % Build files.
        f = fullfile(builddir, [libdep{i} buildext]);
        buildfiles = [buildfiles '''' f ''' '];
    end

    for i=1:length(gendep)
        % Source files.
        f = fullfile(genlibsourcedir, [gendep{i} fortranext]);
        sourcefiles = [sourcefiles '''' f ''' '];

        if ~exist(f, 'file')
            error(['Missing ''' genlibname ''' dependencies.']);
        end

        % Build files.
        f = fullfile(builddir, [gendep{i} buildext]);
        buildfiles = [buildfiles '''' f ''' '];
    end

    % Remove last whitespaces.
    sourcefiles = sourcefiles(1:end-1); 
    buildfiles = buildfiles(1:end-1);

    %% Use MEX to build the library and create the library file.
    eval(sprintf('mex %s -c %s -outdir ''%s'' FFLAGS=''$FFLAGS %s''', mexflags, sourcefiles, builddir, mexfflags));
    system(sprintf('ar -rcs ''%s'' %s', fullfile(libdir, [libname libext]), buildfiles));
end

%% Build the parser
system(sprintf('gcc ''%s'' ''%s'' ''%s'' ''%s'' ''%s'' ''%s'' ''%s'' -o ''%s''', fullfile(basedir, 'src', 'parser', 'lex.yy.c'), fullfile(basedir, 'src', 'parser', 'y.tab.c'), fullfile(basedir, 'src', 'parser', 'fortran.c'), fullfile(basedir, 'src', 'parser', 'simplify.c'), fullfile(basedir, 'src', 'parser', 'jacobian.c'), fullfile(basedir, 'src', 'parser', 'tree.c'), fullfile(basedir, 'src', 'parser', 'node.c'), fullfile(builddir, 'PPODE_matlab2fortran')));

end