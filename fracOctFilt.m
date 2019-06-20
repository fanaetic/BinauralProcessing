function [ fm, yrms ] = fracOctFilt( y, n, fs )
%FRACOCTFILT Summary of this function goes here
%   Detailed explanation goes here
%n=3;

fmmin = 50;
fmmax = 10000;
order = 2;

k = ceil( n * log2(fmmax/fmmin) );
fm = fmmin * 2.^((0:k)/n);

for in = 1:length( fm )
    [ b, a ] = butter( order, [2^(-1/(2*n)) 2^(1/(2*n))]*fm(in)/fs*2, 'bandpass' );
    yf(in, :) = filter( b, a, y );
            
    yrms(in) = rms( yf(in, :) );
end
%hold off;

refrms = rms( y );

% figure(2);
% h = bar(20*log10(yrms/refrms));
% set(gca,'xTick',[1:length(fm)])
% set(gca,'xTickLabel',fm);
% 
end

