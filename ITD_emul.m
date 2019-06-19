% ITD_emul   Blabla
%
% Call these as a nice self-test - the delay 
% is applied to the right channel:
% ITD_emul( '..\wavs\NT_Edith.wav', 0.0004 )

function out = ITD_emul( wavname, ITD )

    % This loads one set of HRTFs:
if ischar( wavname )
    [s, fs] = audioread(wavname);
    % [s, fs] = wavread(wavname);  % Alternative according to Matlab/Octave-version
else 
    fs = 44100;
    s = wavname;
end
    
% DFT-length; estimate by "0.2/340*48000":
N = 256;
k = 0:N/2;
om = exp(-1i*2*pi*k'/N*ITD*fs);
H = [om; conj(om(N/2:-1:2))];
h = real(fftshift(ifft(H))) .* hann(N);
% see 01_Psychoacoustic_Basics.pdf page 17/26: Here the simulation of
% binaural cues can be achieved with amplitude factors (a_n) and delays
% (d_n) for the respective cues. ILDs with a_n and ITDs with d_n. With this
% it is possible to control the cues whereas HRTFs are fixed.

% delay of N/2. Why? The delay's impulse response is non-causal and shifted by N/2 to
% be made causal - the left channel has to be adjusted to this.
sl = [zeros(N/2,1); s(1:end-N/2)];  
% Apply the ir to the right channel:
sr = fftfilt(h, s);

out = [sl sr];
% sound([sl sr], fs);



% EOF