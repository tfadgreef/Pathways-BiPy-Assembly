function s = PPODE_translate(filename, varargin)
%PPODE_TRANSLATE   Tranlate a Matlab ODE function to Fortran.
%   PPODE_TRANSLATE(filename) Tranlates the specified file to Fortran.
%   Also computes a Jacobian function.
%   
%   ARGUMENTS:
%    'filename' The name of the input and output files. The file
%               '<filename>.m' will be translated to '<filename>.F'. 
%   OPTIONS:
%      'ANAJAC' Whether to create a analytical Jacobian function.
%               Setting this option to 1 (default) will create a
%               Jacobian, 0 will disable this feature.
%
%   EXAMPLE USAGE:
%     PPODE_TRANSLATE('ode')
%       Translates 'ode.m' to 'ode.F'.
%
%   AUTHOR:
%     Pascal Pieters <p.a.pieters@student.tue.nl>
%

opts = {'ANAJAC'};
defaults = {1};

values = PPODE_getProperties(opts, defaults, varargin);

if values('ANAJAC')
  anajac = ' 1';
else
  anajac = ' 0';
end

fortranext = '.F';
matlabext = '.m';

[basedir, ~, ~] = fileparts(mfilename('fullpath'));
builddir = fullfile(basedir, 'build');

system(sprintf('cat ''%s'' | ''%s''%s > ''%s''', [filename matlabext], fullfile(builddir, sprintf('PPODE_matlab2fortran')), anajac, [filename fortranext]));

end