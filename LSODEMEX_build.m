function LSODEMEX_build(infile, outfile, varargin)
% Build the LSODE solver
disp('Building the LSODE solver.');

libname = 'ODEPACK';
[basedir, ~, ~] = fileparts(mfilename('fullpath'));
builddir = fullfile(basedir, 'build');
libdir = fullfile(basedir, 'lib');
fortranext = '.F';
buildext = '.o';
libext = '.a';

mexfflags = '-fPIC'; % -w 
mexflags = ''; % -v

if ~exist(fullfile(libdir, [libname libext]))
    error(sprintf('Could not find the %s library.', libname));
end

interfacedir = fullfile(basedir, 'src', 'interface');
interfacedep = {'lsodamex', 'lsodawrapper'};

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

%% Handle options
opts = {'DEBUG','MAXSTEPS'};
defaults = {0, 0};

values = containers.Map(upper(opts),defaults);
for k = 1:2:length(varargin)
    if isKey(values,upper(varargin{k}))
        values(upper(varargin{k})) = varargin{k+1};
    else
        error('The provided property ''%s'' is not available for this function.', varargin{k});
    end
end

fid = fopen(fullfile(builddir, 'defs.h'), 'w');
if values('MAXSTEPS') || values('DEBUG')
    fprintf(fid, '#define OPTIONALINPUTS\n');
    if values('DEBUG')
        fprintf(fid, '#define DEBUG\n');
    end
    if values('MAXSTEPS')
        fprintf(fid, '#define MAXSTEPS %i\n', values('MAXSTEPS'));
    end
end
fclose(fid);

outmex = fullfile(pwd, outfile);

eval(sprintf('mex %s %s -I''%s'' -o ''%s'' FFLAGS=''$FFLAGS %s'' ''%s''', mexflags, sourcefiles, builddir, outmex, mexfflags, fullfile(libdir, [libname libext])));

end