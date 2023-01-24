%% Adaptive filter for noise cancellation
%{ 
-   MSE calculate as (error-signal)^2, calculate multiple independent run (DONE)
-   Try a lattice filter (DONE) (LMS_latt.m file)
-   Test convergence speed and error with different filter parameters (test
each filter with variable parameter to observe difference in performance)
-   Test noise cancelation without noise source (apply delay to the desired signal)(only viable with periodic inteference)
-   Calculate other parameter (MSE, SNR?) read Simulation_and_Performance_Analysis_of_Adaptive_Filter_in_Noise_Cancellation
-   Test with real life data (find sample data from research paper)
-   Test uncollerated noise in d/x
%}
close all;clear;clc;
%% Finding optimal filter paramters for different filter types

%% Performance comparision between different type of filter
filter_comparision();