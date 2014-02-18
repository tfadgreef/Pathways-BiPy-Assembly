function LSODEMEX_build(infile, outfile, varargin)
% Build the LSODE solver
disp('Building the LSODE solver.');

[basedir, ~, ~] = fileparts(mfilename('fullpath'));
builddir = fullfile(basedir, 'build');
libdir = fullfile(basedir, 'lib');
fortranext = '.F';
buildext = '.o';
libext = '.a';

mexfflags = '-fPIC'; % -w 
mexflags = ''; % -v

%% Handle options
opts = {'DEBUG','MAXSTEPS','SOLVER','ADJUSTTOLERANCES'};
defaults = {0, 0, 'Stiff',0};

values = containers.Map(upper(opts),defaults);
for k = 1:2:length(varargin)
    if isKey(values,upper(varargin{k}))
        values(upper(varargin{k})) = varargin{k+1};
    else
        error('The provided property ''%s'' is not available for this function.', varargin{k});
    end
end

fid = fopen(fullfile(builddir, 'defs.h'), 'w');

libnames = {};
interfacedep = {'lsodamex'};
if strcmpi(values('SOLVER'), 'STIFF') || strcmpi(values('SOLVER'), 'NONSTIFF') || strcmpi(values('SOLVER'), 'SWITCHING')
    libnames = [libnames 'ODEPACK'];
    interfacedep = [interfacedep 'lsodawrapper'];
    fprintf(fid, '#define ODEPACK\n');
elseif strcmpi(values('SOLVER'), 'RK45') || strcmpi(values('SOLVER'), 'RK23') || strcmpi(values('SOLVER'), 'RK78')
    libnames = [libnames 'RKSUITE'];
    interfacedep = [interfacedep 'rksuitewrapper'];
    fprintf(fid, '#define RKSUITE\n');
elseif strcmpi(values('SOLVER'), 'MEBDFSO')
    libnames = [libnames 'MEBDFSO'];
    interfacedep = [interfacedep 'mebdfsowrapper'];
    fprintf(fid, '#define MEBDFSO\n');
end

% Defs
if values('MAXSTEPS') || values('DEBUG')
    fprintf(fid, '#define OPTIONALINPUTS\n');
    if values('DEBUG')
        fprintf(fid, '#define DEBUG\n');
    end
    if values('MAXSTEPS')
        fprintf(fid, '#define MAXSTEPS %i\n', values('MAXSTEPS'));
    end
end

if values('ADJUSTTOLERANCES')
    fprintf(fid, '#define ADJUSTTOLERANCES\n');
end

%% Choose the right solver
if strcmpi(values('SOLVER'), 'STIFF')
    fprintf(fid, '#define STIFFSOLVER\n');
elseif strcmpi(values('SOLVER'), 'NONSTIFF')
    fprintf(fid, '#define NONSTIFFSOLVER\n');
elseif strcmpi(values('SOLVER'), 'SWITCHING')
    fprintf(fid, '#define SWITCHINGSOLVER\n');
elseif strcmpi(values('SOLVER'), 'RK23')
    fprintf(fid, '#define RK23\n');
elseif strcmpi(values('SOLVER'), 'RK45')
    fprintf(fid, '#define RK45\n');
elseif strcmpi(values('SOLVER'), 'RK78')
    fprintf(fid, '#define RK78\n');
elseif strcmpi(values('SOLVER'), 'MEBDFSO')
    fprintf(fid, '#define MEBDFSO\n');
else
    error('Unknown solver.')
end
fclose(fid);

libstr = '';
for i=1:length(libnames)
    if ~exist(fullfile(libdir, [libnames{i} libext]))
        error(sprintf('Could not find the %s library.', libnames{i}));
    end
    libstr = [libstr '''' fullfile(libdir, [libnames{i} libext]) ''' '];
end
libstr = libstr(1:end-1);

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

eval(sprintf('mex %s %s -I''%s'' -o ''%s'' FFLAGS=''$FFLAGS %s'' %s', mexflags, sourcefiles, builddir, outmex, mexfflags, libstr));

end