function LSODEMEX_build(infile, outfile)
% Build the LSODE solver
disp('Building the LSODE solver.');

libname = 'ODEPACK';
[basedir, ~, ~] = fileparts(mfilename('fullpath'));
builddir = fullfile(basedir, 'build');
libdir = fullfile(basedir, 'lib');
fortranext = '.F';
buildext = '.o';
libext = '.a';

mexfflags = '-w -fPIC';
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

outmex = fullfile(pwd, outfile);

eval(sprintf('mex %s %s -o ''%s'' FFLAGS=''$FFLAGS %s'' ''%s''', mexflags, sourcefiles, outmex, mexfflags, fullfile(libdir, [libname libext])));

end