function PPODE_addPaths()
%PPODE_ADDPATHS   Add the PPODE paths to the path variable.

[basedir, ~, ~] = fileparts(mfilename('fullpath'));
addpath(basedir);
addpath(fullfile(basedir,'src','matlab'));

end