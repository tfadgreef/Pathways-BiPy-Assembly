function s = PPODE_translate(filename)
%PPODE_TRANSLATE   Tranlate a Matlab ODE function to Fortran.
%   PPODE_TRANSLATE(filename) Tranlates the specified file to Fortran.
%   Also computes a Jacobian function.
%   
%   ARGUMENTS:
%    'filename' The name of the input and output files. The file
%               '<filename>.m' will be translated to '<filename>.F'. 
%
%   EXAMPLE USAGE:
%     PPODE_TRANSLATE('ode')
%       Translates 'ode.m' to 'ode.F'.
%
%   AUTHOR:
%     Pascal Pieters <p.a.pieters@student.tue.nl>
%

fortranext = '.F';
matlabext = '.m';

[basedir, ~, ~] = fileparts(mfilename('fullpath'));
builddir = fullfile(basedir, 'build');

system(sprintf('cat ''%s'' | ''%s'' > ''%s''', [filename matlabext], fullfile(builddir, 'PPODE_matlab2fortran'), [filename fortranext]));

end