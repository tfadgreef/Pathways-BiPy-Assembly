function s = PPODE_interpreter(filename)
%PPODE_INTERPRETER 

fortranext = '.F';
matlabext = '.m';

[basedir, ~, ~] = fileparts(mfilename('fullpath'));
builddir = fullfile(basedir, 'build');

system(sprintf('cat ''%s'' | ''%s'' > ''%s''', [filename matlabext], fullfile(builddir, 'PPODE_matlab2fortran'), [filename fortranext]));

end