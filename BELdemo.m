function varargout = BELdemo( simulationCase, varargin )

% handle input of the function
if nargin == 1
    earside = 1;
    hearingloss = 25.*ones(1, 24);
elseif nargin == 2
    earside = varargin{1};
    hearingloss = 25.*ones(1, 24);
elseif nargin == 3
    earside = varargin{1};
    hearingloss = {2};
else
    error('Number of input arguments exceeded!')
end

switch simulationCase
    case 'ITD'
        [inSignal, FS] = srmITDdemo(15);
    case 'HRTF'
        [inSignal, FS] = srmHRTFdemo(15);
    otherwise
        error(['"' simulCase '" is not a valid case for ' mfilename])
end

factor = 10.^(-hearingloss ./20 );

% simulate onesided hearing loss with simple filtering and dampening
fmmin = 50;
fmmax = 10000;
order = 2;
n = 3;
k = ceil( n * log2(fmmax/fmmin) );
fm = fmmin * 2.^((0:k)/n);

for in = 1:length( fm )
    [ b, a ] = butter( order, [2^(-1/(2*n)) 2^(1/(2*n))]*fm(in)/FS*2, 'bandpass' );
    outfiltered = filter( b, a, inSignal(:, earside) );
    outTmp = factor(in)*outfiltered;
    if in == 1
        outSignal = outTmp;
    else
        outSignal = outSignal + outTmp;
    end
end

if earside == 1
    outSignal = [outSignal inSignal(:, 2)];
else
    outSignal = [inSignal(:, 1) outSignal];
end

% handle the output
if nargout == 0
    sound( outSignal, FS );
elseif nargout == 1
    varargout{1} = outSignal;
elseif nargout == 2
    varargout{1} = outSignal;
    varargout{2} = FS;
end

end
