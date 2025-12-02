%% Load Data
opts = detectImportOptions('Miami Airline.csv','Delimiter',';');
T = readtable('Miami Airline.csv', opts);

%% Convert year & month to datetime
T.date = datetime(T.year, T.month, 1);

%% Sort dan agregasi bulanan
[uniqueDates, ~, idx] = unique(T.date);
monthly_weather_ct = accumarray(idx, T.weather_ct);

%% Time Series Plot
figure;
plot(uniqueDates, monthly_weather_ct, 'LineWidth', 2);
grid on;
xlabel('Date');
ylabel('Weather Delay Count');
title('Time Series of Weather-caused Flight Delays');
set(gca, 'FontSize', 12);

%% FFT / Spectrum
ts = monthly_weather_ct;
ts_detrend = ts - mean(ts);   % hilangkan komponen DC
N = length(ts);
Y = fft(ts_detrend);
P2 = abs(Y/N);
P1 = P2(1:N/2+1);
P1(2:end-1) = 2*P1(2:end-1);

% Frekuensi dalam satuan siklus per bulan
freq = (0:(N/2)) / N;  

%% Spectrum Plot
figure;
plot(freq, P1, 'LineWidth', 2);
grid on;
xlabel('Frequency (1/month)');
ylabel('Amplitude');
title('Spectrum of Weather Delay Time Series');
set(gca, 'FontSize', 12);