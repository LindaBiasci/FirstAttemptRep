%% Example of brain connectivity study
% the dataset for this excercise is available in the shared folder 
% on drive in: DATASETS/FEATURES/Brain_fMRI_HOseries_ABIDE 
% the README file explains that
% this dataset is a subset of the rs-fMRI temporal series acquired 
% within the ABIDE project and publicly shared 
% http://preprocessed-connectomes-project.org/abide/

% The dataset includes three files:
% - table_phen_NYU.csv with the ID of the 124 subjects (59 subjects with ASD and 65 control subjects) with information about the diagnostic group (1 for ASD, 2 for control), age at scan, the Full Scale IQ score (FIQ), and the SEX (1 for males, only males are present in this dataset);  
% - data_struct.mat, a MATLAB struct containing the 110 time series for each subjects 
% - legend_series.mat, a MATLAB table containing the names of the 110 ROIs of the HO atlas and their correspondence to the Mesulam functional areas.
% - Each time point in the series has a duration of 2 seconds.

clear
close all
clc

%% load the data

data_dir = 'C:\Users\linda\Desktop\materiali università\magistrale\Computing methods for experimental physics\Imaging\some imaging data\Brain_fMRI_HOseries_ABIDE\';

load(strcat(data_dir, 'data_struct'))
load(strcat(data_dir, 'legend_series.mat'))
T_phen = readtable(strcat(data_dir, 'table_phen_NYU.csv'));

vt = 2; % each timepoint corresponds to 2 seconds

%% Plot some series for the first subject of the dataset

i_sbj = 1; % we plot time series for the first subject

N_ROIs = size(data(i_sbj).t_series,2);
time_points = size(data(i_sbj).t_series(:,1),1);
x = 1:time_points;
x = x*vt;

label_all=[];
figure;
for i = 1: 10 % N_ROIs, for instance 10
    
    plot(x, data(i_sbj).t_series(:,i))
    label_all = [label_all; string(legend_series{i,3})];
    xlabel('t (s)')
    ylabel('bold signal (a.u.)')
    hold on
end
legend(label_all)

%% Compute the functional connectivity (FC) matrix for one subject

FuncConn = zeros(N_ROIs);
for i = 1:N_ROIs
    for j = i+1:N_ROIs
        S1 = data(i_sbj).t_series(:,i);
        S2 = data(i_sbj).t_series(:,j);
        FuncConn(i,j) = corr2(S1,S2); % coefficiente di correlazione tra ROI i e ROI j
        %FuncConn(j,i) = FuncConn(i,j); % copia anche sotto la diagonale
    end
end
%for i = 1:N_ROIs
%    FuncConn(i,i) = 1;
%end

figure; imagesc(FuncConn) % mostra la matrice di correlazioni come immagine
colorbar
title('(half) covariance matrix');

%% Identify and plot the pair of time series with the highest FC value
% Trova la coppia di ROI più correlate nel soggetto selezionato, recupera i
% nomi delle ROI, disegna i due segnali BOLD sovrapposti nel tempo

[i_max, j_max] = find(FuncConn == max(FuncConn(:)));

pair = [i_max, j_max]; 

string(legend_series{pair(1),3})
string(legend_series{pair(2),3})

label_all=[];

figure;
for i = pair(:)
    plot(x, data(i_sbj).t_series(:,i))
    label_all = [label_all; string(legend_series{i,3})];
    hold on
end
legend(label_all)
title('Pair of most positively correlated ROIs');

%% Identify and plot some pairs of time series with high and positive FC value

[i_set, j_set] = find(FuncConn > 0.9*max(FuncConn(:)));

pairs = [i_set, j_set]; 

for i_pairs= 1:size(pairs,1)
    label_all=[];
    figure;
    for i = [pairs(i_pairs,1), pairs(i_pairs,2)]
        plot(x, data(i_sbj).t_series(:,i))
        label_all = [label_all; string(legend_series{i,3})];
        hold on
        title('A pair of time series with high positive correlation');
    end
    legend(label_all)
end

%% write a function which makes the plots of the selected tipe series
% nota bene: qui stiamo definendo la funzione, non ancora chiamandola
% (runnando questo codice non devi ricevere niente in output)

function plot_pair_series(data,i_sbj, x, pairs, legend_series)
% plots two time series 

for i_pairs= 1:size(pairs,1)
    label_all=[];
    figure;
    for i = [pairs(i_pairs,1), pairs(i_pairs,2)]
       plot(x, data(i_sbj).t_series(:,i))
        label_all = [label_all; string(legend_series{i})];
        hold on
    end
    legend(label_all)
    xlabel('t (s)')
    ylabel('bold signal (a.u.)')
end
end

%% Identify and plot the pair of time series with the highest FC value (as before, but now using the function!)

[i_max, j_max] = find(FuncConn == max(FuncConn(:)));
pair = [i_max, j_max]; 

plot_pair_series(data, i_sbj, x, pair, legend_series{:,3})
title('Pair of most positively correlated ROIs');

%% Identify and plot some pairs of time series with high and positive FC value (again, as before, but now using the function)

[i_set, j_set] = find(FuncConn > 0.9*max(FuncConn(:)));
pairs = [i_set, j_set]; 

plot_pair_series(data, i_sbj, x, pairs, legend_series{:,3})
title('A pair of time series with high positive correlation');

%% Identify and plot the pairs of time series with the highest and negative FC value (i.e. anticorrelated)

[i_min,j_min] = find(FuncConn == min(FuncConn(:)));
pair = [i_min, j_min]; 

plot_pair_series(data, i_sbj, x, pair, legend_series{:,3})
title('Pair of most negatively correlated ROIs');

%% Identify and plot some pairs of anticorrelated time series

[i_min,j_min] = find(FuncConn < 0.9*min(FuncConn(:)));
pair = [i_min, j_min]; 

plot_pair_series(data, i_sbj, x, pair, legend_series{:,3})
title('A pair of anticorrelated time series');

%% Identify and plot some pairs of uncorrelated time series (FC value close to 0)

[i_set, j_set]  = find((abs(FuncConn) < 0.0001)&(abs(FuncConn) ~= 0));
pairs = [i_set, j_set]; 

plot_pair_series(data,i_sbj, x, pair, legend_series{:,3})
title('A pair of almost uncorrelated time series');

%% The time series can be grouped according to Mesulam areas (functional brain areas)
% we are still working only on the first subject of the dataset, as with fixed  i_sbj = 1 at the beginning

% raggruppa le 110 ROI singole del dataset per area funzionale, quindi per
% ogni gruppo estrai tutte le time series e calcola il segnale medio

areas_M = unique(legend_series{:,4}); % contiene la classe di Mesulam per ogni ROI (unique prende solo i valori distinti)

for i_areas = 1: size(areas_M,1)
    series_M(i_areas).ID  = areas_M{i_areas};
    % creazione di una struct series_M con nome della Mesulam area "ID"

    selected_series = strcmp(legend_series{:,4}, areas_M{i_areas});
    % selezione delle ROI appartenenti a ciascuna Mesulam area
    % (restituisce un vettore logico, 1 se la ROI appartiene a quell'area, 0 altrimenti)

    series_M(i_areas).series = data(i_sbj).t_series(:,selected_series);   
    % estrazione delle colonne che appartengono ad una certa Mesulam area
    % (restituisce una matrice tempo x numero di ROI per quell'area)

    series_M(i_areas).mean = mean(data(i_sbj).t_series(:,selected_series),2);
    % calcolo della media lungo le colonne per ogni Mesulam area 
    % (restituisce un vettore con il segnale medio BOLD di quell'area)
end

%% Plot of the average temporal signals within the 6 Mesulam areas 

figure;
label_all=[];

for i_areas= 1:size(areas_M,1)

    plot(x, series_M(i_areas).mean)
    label_all = [label_all; string(areas_M{i_areas})];
    hold on

    legend(label_all)
end

%% Compute the FC between Measulam areas

N_ROIs = size(areas_M,1);

FuncConn_M = zeros(N_ROIs);
for i = 1:N_ROIs
    for j = i+1:N_ROIs
        S1 = series_M(i).mean;
        S2 = series_M(j).mean;
        FuncConn_M(i,j) = corr2(S1,S2);
    end
end

figure; imagesc(FuncConn_M)
colorbar

%% Plot the most correlated areas

[i_max, j_max]  = find(FuncConn_M == max(FuncConn_M(:)));
label_all=[];

figure;
for i = [i_max, j_max]
    plot(x, series_M(i).mean)
    label_all = [label_all; string(areas_M{i})];
    hold on
end
legend(label_all)
title('Most positively correlated pair of functional areas')

%% Identification of the average signals of the 6 Mesulam areas for:
% 1) wavelet time-serie analysis

S_heteromodal = series_M(1).mean';
S_limbic = series_M(2).mean';
S_paralimbic = series_M(3).mean';
S_primary = series_M(4).mean';
S_subcortical = series_M(5).mean';
S_unimodal = series_M(6).mean';

% vengono salvati sei vettori riga in memoria, ciascuno è il segnale medio nel tempo di un'area funzionale 
% start the wavelet time-frequency analyzer App e load the time series from the workspace
% nota bene: scalogramma = decomposizione wavelet di un segnale
%% and to carry out the
% 2) wavelet coherence analysis to identify coherent time-varying oscillations in two signals

figure;
wcoherence(S_unimodal, S_primary)
 
figure;
wcoherence(S_heteromodal, S_limbic)

% wcoherence() calcola la coerenza wavelet tra due segnali temporali:
% misura quanto due segnali oscillano in maniera sincronizzata nel tempo e
% nelle frequenze, quindi restituisce un grafico scalogramma con il tempo
% sull'asse X e la frequenza sull'asse Y (i colori indicano l'intensità
% della coerenza)