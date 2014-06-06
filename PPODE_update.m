%function PPODE_update( varargin )
%PPODE_UPDATE Summary of this function goes here
%   Detailed explanation goes here

varargin = [];
home = pwd;

PPODE_addPaths

mkdir 'tmp';

%% Handle the options passed to the function.
opts = {'VERBOSE', 'SERVER', 'CHANGELOG', 'DOWNLOAD', 'INSTALL'};
defaults = {1, 'http://localhost/PPODESUITE/Download/', 1, 1, 1};

values = PPODE_getProperties(opts, defaults, varargin);

verbose = values('VERBOSE');
server = values('SERVER');

% Get current version
fid = fopen('version');
curver =  fscanf(fid, '%s', [1 1]);
fclose(fid);

[curver, curreltype] = PPODE_getVersion(curver);

if verbose
    disp('# Current version:');
    fprintf('Major version: %d; Minor version: %d; Bugfix version: %d\n', curver(1), curver(2), curver(3));
    fprintf('Release type: %s\n', curreltype);
    
    disp('# Checking for new releases...');
end

urlwrite([server 'newest/version'], fullfile(home, 'tmp', 'version'));

%end

