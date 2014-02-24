function [ values ] = PPODE_getProperties( opts, defaults, varargs )
%PPODE_GETPROPERTIES Get the properties specified in varargin.
%   Returns the values for all properties given by opts, based on the 
%   provided arguments varargs and the default values of the list 
%   defaults.
%
%   ARGUMENTS:
%        'opts' A list of possible option names.
%    'defaults' A list of the default options for the corresponding 
%               option names of opts.
%     'varargs' A list of options passed to the varargin of the 
%               function that calls the PPODE_GETPROPERTIES function.
%
%   RETURNS:
%     A list of values for the options specified in opts.
%
%   EXAMPLE USAGE:
%     A function (function f(varargin)) is called as follows:
%       f('Option 1',5,'Option 2','string')
%     In f the function PPODE_GETPROPERTIES can be called.
%       PPODE_GETPROPERTIES({'OPT1', 'OPT2', OPT3}, {0,'',10}, varargin)
%     This will return the following list of values:
%       {5, 'string', 10}
%


values = containers.Map(upper(opts),defaults);

for k = 1:2:length(varargs)
    if k < length(varargs)
        if isKey(values,upper(varargs{k}))
            values(upper(varargs{k})) = varargs{k+1};
        else
            error(['The provided property ''' varargs{k} ''' is not '...
                   'available for this function.']);
        end
    else
        error('Invalid input arguments.');
    end
end

end

