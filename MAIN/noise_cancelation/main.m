%% Adaptive filter for noise cancellation
%{
Evaluation parameters:
- Differece between output signal (e) and pure signal
- Learning curve (convergence speed)
- SNR of desired signal vs output signal
Parts:
- Default LMS filter structure (demo signal, demo noise, filter order, signal length,
convergence speed, learning curve demo)
- Demo algorithm for different types of adaptive filter structure (LMS,
NLMS, RLS, LMS lattice)
- Testing parameters of each adaptive filter type for optimal error
reduction and convergence speed
- Testing different noise characteristic:
    - Normal gaussian noise, clean signal
    - Delay gaussian noise, delay sample lower or higher than filter order
    - Noise from multiple source
    - Reference signal (pure noise) get part of signal mixed in
    - Uncorrelated noise in desired signal
    - Total uncorrelated noise
%}
%{ 
WIP
-   MSE calculate as (error-signal)^2, calculate multiple independent run (DONE)
-   Try a lattice filter (DONE) (LMS_latt.m file)
-   Test convergence speed and error with different filter parameters (test
each filter with variable parameter to observe difference in performance)
-   Fix lattice filter algorithm
-   Calculate other parameter (MSE, SNR?) read Simulation_and_Performance_Analysis_of_Adaptive_Filter_in_Noise_Cancellation
-   Test with real life data (find sample data from research paper)
-   Test uncollerated noise in d/x
-   Implement new NLMS algorithm, fast convergence for same mse
%}
close all;clear;clc;
%% Finding optimal filter paramters for different filter types
filter_parameters_testing();
%% Performance comparision between different type of filter
filter_comparision();