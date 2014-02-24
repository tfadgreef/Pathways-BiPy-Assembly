function s = PPODE_interpreter(filename)
%PPODE_INTERPRETER 

fortranext = '.F';
matlabext = '.m';

fid = fopen([filename matlabext], 'r');
if fid < 0
    error('Invalid filename.');
end

line = fgetl(fid)
while ischar(line)
    fprintf('%s\n', line);
    line = fgetl(fid);    
end

fclose(fid);

end