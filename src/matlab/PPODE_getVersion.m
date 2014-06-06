function [curver, curreltype] = PPODE_getVersion( versiontext )
%PPODE_GETVERSION Summary of this function goes here
%   Detailed explanation goes here

curver = textscan(versiontext, '%s %s %s', 'delimiter', '.');
curver{3} = textscan(curver{3}{1}, '%s %s', 'delimiter', '-');

curreltype = curver{3}{2}{1};
curver = [str2num(curver{1}{1}) str2num(curver{2}{1}) str2num(curver{3}{1}{1})];

end

