function LSODEMEX_init()
% Build the ODEPACK library

libname = 'ODEPACK';
fprintf('Building the %s library.\n', libname);

[basedir, ~, ~] = fileparts(mfilename('fullpath'));
builddir = fullfile(basedir, 'build');
libdir = fullfile(basedir, 'lib');
fortranext = '.F';
buildext = '.o';
libext = '.a';

mexfflags = '-w -fPIC';
mexflags = ''; % -v

%% ODEPACK
odepackdir = fullfile(basedir, 'src', 'ODEPACK');
odepackdep = {'opkdmain', 'opkda1', 'opkda2'};

%% Create the directories directory
[stat, ~, ~] = mkdir(builddir);
if ~stat
    error('Could not create the ''build'' directory.');
end
[stat, ~, ~] = mkdir(libdir);
if ~stat
    error('Could not create the ''lib'' directory.');
end

%% Dependency check
odepacksourcefiles = '';
odepackbuildfiles = '';
for i=1:length(odepackdep)
    % Source files
    f = fullfile(odepackdir, [odepackdep{i} fortranext]);
    odepacksourcefiles = [odepacksourcefiles '''' f ''' '];

    if ~exist(f, 'file')
        error('Missing ''ODEPACK'' dependencies.');
    end

    % Build files
    f = fullfile(builddir, [odepackdep{i} buildext]);
    odepackbuildfiles = [odepackbuildfiles '''' f ''' '];
end
odepacksourcefiles = odepacksourcefiles(1:end-1); % Remove last whitespace
odepackbuildfiles = odepackbuildfiles(1:end-1); % Remove last whitespace


eval(sprintf('mex %s -c %s -outdir ''%s'' FFLAGS=''$FFLAGS %s''', mexflags, odepacksourcefiles, builddir, mexfflags));
system(sprintf('ar -rcs ''%s'' %s', fullfile(libdir, [libname libext]), odepackbuildfiles));

end