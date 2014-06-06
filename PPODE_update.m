function PPODE_update( varargin )
%PPODE_UPDATE Summary of this function goes here
%   Detailed explanation goes here

home = pwd;

PPODE_addPaths

mkdir 'tmp';

%% Handle the options passed to the function.
opts = {'VERBOSE', 'SERVER', 'CHANGELOG', 'DOWNLOAD', 'INSTALL', 'REINIT'};
defaults = {1, 'http://www.student.tue.nl/Z/p.a.pieters/PPODESUITE/', 0, 1, 1, 1};

values = PPODE_getProperties(opts, defaults, varargin);

verbose = values('VERBOSE');
server = values('SERVER');

% Get current version
fid = fopen('version');
curver =  fscanf(fid, '%s', [1 1]);
fclose(fid);

[curver, curreltype] = PPODE_getVersion(curver);

if verbose
    fprintf('Current version: %d.%d.%d-%s\n', curver(1), curver(2), curver(3), curreltype);
end

try
    urlwrite([server 'newest/version.txt'], fullfile(home, 'tmp', 'version'));
catch
    error('PPODE_update:URLNotFound', 'There was an error while looking for new versions. URL ''%s'' can not be found.', [server 'newest/version']);
end

fid = fopen(fullfile(home, 'tmp', 'version'));
newver =  fscanf(fid, '%s', [1 1]);
fclose(fid);

[newver, newreltype] = PPODE_getVersion(newver);

if verbose
    fprintf('Newest version: %d.%d.%d-%s\n', newver(1), newver(2), newver(3), newreltype);
end

if (newver(1) > curver(1)) || (newver(1) == curver(1) && (newver(2) > curver(2) || (newver(2) == curver(2) && newver(3) > curver(3))))
    fprintf('\nNewer version available\n\n');
else
    fprintf('\nAlready up-to-date\n\n');
    rmdir('tmp', 's');
    return;
end

if values('CHANGELOG')
    try
        urlwrite([server 'newest/changelog.txt'], fullfile(home, 'tmp', 'changelog'));
        edit(fullfile(home, 'tmp', 'changelog'));
    catch
        warning('PPODE_update:URLNotFound', 'There was an error while looking for the changelog. URL ''%s'' can not be found.', [server 'newest/changelog']);
    end
end

if values('DOWNLOAD')
    try
        urlwrite([server 'newest/PPODESUITE.tar.gz'], fullfile(home, 'tmp', 'PPODESUITE.tar.gz'));
    catch
        error('PPODE_update:URLNotFound', 'There was an error while looking for the update. URL ''%s'' can not be found.', [server 'newest/PPODESUITE.tar.gz']);
    end
    disp('Newest version of software downloaded.');
end

if exist(fullfile(home, 'noupdate'))
    error('PPODE_update:UpdateNotAllowed', 'You are in the development branch of PPODESUITE, updating is disabled using the ''noupdate'' file.')
end

if values('INSTALL')
    system(sprintf('tar --overwrite -zxf ''%s''', fullfile(home, 'tmp', 'PPODESUITE.tar.gz')));
    disp('Newest version of software installed.');
end

if values('INSTALL')
    rmdir('tmp', 's');
end

if values('REINIT')
    PPODE_init
end

end

