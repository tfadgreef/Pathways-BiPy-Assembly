function LSODEMEX_init()
% Build the ODEPACK library

libnames = {'ODEPACK', 'RKSUITE', 'MEBDFSO'};
libdeps = {{'opkdmain', 'opkda1', 'opkda2'}, {'rksuite'}, {'yale', 'mebdfso'}};

[basedir, ~, ~] = fileparts(mfilename('fullpath'));
builddir = fullfile(basedir, 'build');
libdir = fullfile(basedir, 'lib');
fortranext = '.F';
buildext = '.o';
libext = '.a';

mexfflags = '-w -fPIC';
mexflags = ''; % -v

for curlibi=1:length(libnames)
    libname = libnames{curlibi};
    libdep = libdeps{curlibi};

    fprintf('Building the %s library.\n', libname);

    %% ODEPACK
    libsourcedir = fullfile(basedir, 'src', libname);

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
    sourcefiles = '';
    buildfiles = '';
    for i=1:length(libdep)
        % Source files
        f = fullfile(libsourcedir, [libdep{i} fortranext]);
        sourcefiles = [sourcefiles '''' f ''' '];

        if ~exist(f, 'file')
            error(['Missing ''' libname ''' dependencies.']);
        end

        % Build files
        f = fullfile(builddir, [libdep{i} buildext]);
        buildfiles = [buildfiles '''' f ''' '];
    end
    sourcefiles = sourcefiles(1:end-1); % Remove last whitespace
    buildfiles = buildfiles(1:end-1); % Remove last whitespace


    eval(sprintf('mex %s -c %s -outdir ''%s'' FFLAGS=''$FFLAGS %s''', mexflags, sourcefiles, builddir, mexfflags));
    system(sprintf('ar -rcs ''%s'' %s', fullfile(libdir, [libname libext]), buildfiles));
end

end