%% MATLAB SCRIPT FOR MONTHLY DATA TIME SERIES AND SPECTRUM PLOT
% Data Source: Miami Area Weather Station

% 1. READING AND PROCESSING DATA
try
    % Reading CSV file into a table
    data = readtable('DATAMIAMIBULANAN.csv');
catch
    error('DATAMIAMIBULANAN.csv file not found in the current directory.');
end

% List of month columns to be extracted
MonthCols = {'JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN', 'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC'};

% --- A. EXTRACTION OF PRECIPITATION (PRECTOTCORR) ---
PrecipitationTable = data(strcmp(data.PARAMETER, 'PRECTOTCORR'), MonthCols);
% Converting monthly table into a single time series (column vector)
Precipitation = reshape(PrecipitationTable{:, :}.', [], 1);

% --- B. EXTRACTION OF WIND SPEED (WS10M_MIN) ---
WindSpeedTable = data(strcmp(data.PARAMETER, 'WS10M_MIN'), MonthCols);
% Converting monthly table into a single time series (column vector)
WindSpeed = reshape(WindSpeedTable{:, :}.', [], 1);

% Defining number of data points (N) and sampling frequency (Fs)
N = length(Precipitation);
Fs = 12; % Sampling frequency = 12 samples/year (monthly data)
T = (0:N-1)' / Fs; % Time vector (in Years)

%% 2. PLOT TIME SERIES AND SPECTRUM OF PRECIPITATION

figure('Name', 'Monthly Time Series and Spectrum Analysis - Miami Area');

% --- PLOT 1: TIME SERIES PRECIPITATION ---
subplot(2, 2, 1);
plot(T, Precipitation, 'b-o', 'MarkerSize', 3, 'LineWidth', 1);
title('Precipitation Time Series');
xlabel('Time (Years)');
ylabel('Precipitation (mm/month)');
grid on;

% --- PLOT 2: POWER SPECTRUM OF PRECIPITATION ---
% Using pwelch for power spectral density estimation
[P_P, F_P] = pwelch(Precipitation, N, N/2, N, Fs);

subplot(2, 2, 2);
plot(F_P, 10*log10(P_P), 'r-'); % Conversion to decibels (dB)
title('Spectrum of Precipitation');
xlabel('Frequency (Cycles/Year)');
ylabel('Power Spectral Density (dB/(Cycles/Year))');
% Focusing on low frequencies up to 6 cycles/year (half of Fs)
xlim([0 Fs/2]);
% Marking annual frequency (1 cycle/year)
xline(1, '--k', '1 Year Cycle'); 
grid on;

%% 3. PLOT TIME SERIES AND SPECTRUM OF WIND SPEED

% --- PLOT 3: TIME SERIES WIND SPEED ---
subplot(2, 2, 3);
plot(T, WindSpeed, 'g-o', 'MarkerSize', 3, 'LineWidth', 1);
title('Wind Speed Time Series');
xlabel('Time (Years)');
ylabel('Wind Speed (m/s)');
grid on;

% --- PLOT 4: POWER SPECTRUM OF WIND SPEED ---
% Using pwelch for power spectral density estimation
[P_WS, F_WS] = pwelch(WindSpeed, N, N/2, N, Fs);

subplot(2, 2, 4);
plot(F_WS, 10*log10(P_WS), 'm-'); % Conversion to decibels (dB)
title('Spectrum of Wind Speed');
xlabel('Frequency (Cycles/Year)');
ylabel('Power Spectral Density (dB/(Cycles/Year))');
% Focusing on low frequencies up to 6 cycles/year
xlim([0 Fs/2]);
% Marking annual frequency (1 cycle/year)
xline(1, '--k', '1 Year Cycle'); 
grid on;

% Adjusting subplot layout for neatness
sgtitle('Monthly Data Time Series and Spectrum Analysis for Miami Area');