function varargout = srmITDdemo( varargin )

% handle the input
if nargin == 0
    snr = -5;
    ITDnoise = 0;
elseif nargin == 1
    snr = varargin{1};
    ITDnoise = 0;
elseif nargin == 2
    snr = varargin{1};
    ITDnoise = varargin{2};
else
    error("Number of input arguments exceeded")
end

% load the speech signal from the OLSA
[speech, FSspeech] = audioread( '07970.wav' );

% set the duration of the noise relative to the speech signal. Here, the
% noise will be cut randomly and with an extra second.
wavsize = length( speech );
startIndex = floor(rand * (wavsize-2*FSspeech)); startIndex = startIndex(1,1);
endIndex = startIndex + wavsize + 1*FSspeech;
[noise, FSnoise] = audioread( 'olnoise.wav', [startIndex endIndex] );

% place olspeech in the middle of olnoise
add_noise_dur = 500e-3; %500 ms noise before and after speech signal
add_zeros_size = round(add_noise_dur*FSnoise);
nrchans = size(noise,2);
if mod(add_zeros_size,2) ~= 0 %uneven diff/2
    speech = [zeros(add_zeros_size/2,nrchans); speech; zeros(add_zeros_size/2+1,nrchans)];
else % even diff/2
    speech = [zeros(add_zeros_size/2,nrchans); speech; zeros(add_zeros_size/2,nrchans)];
end

% cut noise to needed size
noise = noise(1:length(speech),:);

% scale the noise signal 5 dB louder than the speech signal (-5 dB SNR).
factor = 10.^(-snr ./ 20);
noise = bsxfun(@times, noise, factor);

% interaural time difference so that the signal originates from the front
ITDspeech = 0;
outSpeech = ITD_emul( speech, ITDspeech );

% interaural time difference so that the signal originates from the side
outNoise = ITD_emul( noise, ITDnoise );

% mix both signlas
outSignal = outNoise + outSpeech;
outSignal = hanwin( outSignal, (100e-3*FSspeech) );

% scale the signal
outSignal = 0.7*outSignal/max(max(abs(outSignal)));

% handle the outpu
if nargout == 0
    sound( outSignal, FSspeech );
elseif nargout == 1
    varargout{1} = outSignal;
elseif nargout == 2
    varargout{1} = outSignal;
    varargout{2} = FSspeech;
end

end