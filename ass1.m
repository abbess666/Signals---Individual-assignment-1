
% 1. individual assignment
% Alžběta Murcková

[recorded_signal, Fs] = audioread('aaa.wav');

% Extract the portion of the recorded signal based on start_time and end_time
start_time = 1.4; 
end_time = 1.9;  
start_sample = round(start_time * Fs);
end_sample = round(end_time * Fs - 1);
recorded_signal_trimmed = recorded_signal(start_sample:end_sample);
t_trimmed = (0:length(recorded_signal_trimmed)-1)/Fs;

% FFT for both signals
N_trim = length(recorded_signal_trimmed);
frequencies = (0:N_trim-1)*(Fs/N_trim);

% FFT for the recorded signal
FFT_recorded = fft(recorded_signal_trimmed);

% Find the magnitude of the FFT
magnitude_recorded = abs(FFT_recorded)/N_trim;

% Find the index of the peak in the magnitude spectrum
[~, peak_idx] = max(magnitude_recorded);

% Get the corresponding frequency from the frequency axis
f_clean = frequencies(peak_idx);  % Frequency corresponding to the peak

% Generate a clean signal using the detected frequency
window = hamming(N_trim)';  % Applying a Hamming window
clean_signal = sin(2*pi*f_clean*t_trimmed) .* window;  % Clean sine signal with window

% FFT of the clean signal
FFT_clean = fft(clean_signal);

% Calculate magnitude spectra for clean signal
magnitude_clean = abs(FFT_clean)/N_trim;

% Calculate corresponding frequency axis for the clean signal
frequencies_clean = (0:N_trim-1)*(Fs/N_trim);

% Convert magnitudes to dB
magnitude_clean_dB = 20*log10(max(magnitude_clean, eps));
magnitude_recorded_dB = 20*log10(max(magnitude_recorded, eps));

% Plot magnitude spectrum and time-domain signals in one figure
figure;

% Subplot 1: Time domain of recorded signal
subplot(2,2,1);
plot(t_trimmed, recorded_signal_trimmed);
title('Original Trimmed Recorded Signal');
xlabel('Time (s)');
ylabel('Amplitude');

% Subplot 2: Time domain of clean signal
subplot(2,2,2)
plot(t_trimmed, clean_signal);
title('Clean Signal');
xlabel('Time (s)');
ylabel('Amplitude');

% Subplot 3: Magnitude Spectrum of Recorded Signal
subplot(2,2,[3,4]);
plot(frequencies(1:floor(N_trim/2)), magnitude_recorded_dB(1:floor(N_trim/2)));
xlim([0 3000]);
hold on
% Subplot 4: Magnitude Spectrum of Clean Signal

plot(frequencies_clean(1:floor(N_trim/2)), magnitude_clean_dB(1:floor(N_trim/2)));
title('Magnitude Spectrum of Recorded and Clean Signal');
xlabel('Frequency (Hz)');
ylabel('Magnitude (dB)');
xlim([0 3000]);
legend('Recorded signal', 'Clean signal');

% Play the recorded signal
sound(recorded_signal_trimmed,Fs);