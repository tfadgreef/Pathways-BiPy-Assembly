% RunAvg.m
% This script computes the running average of the entries of vector
% Yvalues, thus acting as a smoothing mask. Parameter n sets the width of
% the running average.

function [A] = RunAvg(Xvalues,Yvalues,n)
% Compute running average of Yvalues at Xvalues 
Xl=length(Xvalues);
A=zeros(1,Xl);
for i=1:length(Xvalues)
    if i <= n
        A(i)=mean(Yvalues(1:2*i-1));
    elseif i >= length(Xvalues)-(n-1)
        A(i)=mean(Yvalues(Xl-2*(Xl-i):end));
    else
        A(i)=mean(Yvalues(i-n:i+n));
    end
end

end

