%% Exercise 2 - Browsing 4D NIfTI data sample
% The objective is to explore 4D data:
% 1) open a functional MRI (fMRI) NIfTI dataset (4D data);
% 2) display the fMRI temporal sequence signals corresponding to two
% different brain voxels;
% 3) display the temporal signal averaged in a cubic Region of Interest
% (ROI) ...;
% 4) ... and see what happens with different ROI sizes.
%
% Sample NIfTI images for this exercise are available at
% <https://pandora.infn.it/public/cmepda/DATASETS/IMAGES/DICOM_Examples/ INFN Pandora>
% or on drive
% <https://drive.google.com/drive/folders/1YqK7ZkM-P2IrqfD7Pj-SCmjz-GWd_1-Y?usp=sharing
% Google drive folder> 
% in the IMAGES/NIfTI_Examples/Brain_MRI_Sub01/ directory. 
% Choose the fMRI data sample:
% sub-01-func-sub-01_task-read_run-1_bold.nii
%
% Complete the lines starting with %c

%% 1) Open a functional MRI (fMRI) NIfTI dataset (4D data) 

%%
% Clear the workspace, close all figures and clear the command window

clear
close all
clc

%% 
% a) define the filename of the NIfTI file to open

filename = 'C:\Users\linda\Desktop\materiali università\magistrale\Computing methods for experimental physics\Imaging\some imaging data\Brain_MRI_Sub01\sub-01-func-sub-01_task-read_run-1_bold.nii';

%%
% b) read the file info with niftiinfo

info = niftiinfo(filename);

%%
% c) check the PixelDimensions and TimeUnits

info.ImageSize
info.PixelDimensions % the forth dimension is time
info.TimeUnits

%%
% d) store in a variable the voxel size along the temporal dimension

vt = info.PixelDimensions(4); % vt is the voxel size along the temporal dimension

%%
% e) read the image data with niftiread and store it in a Matlab array

Im = niftiread(filename);

%%
% f) check the size of the array

size(Im)

%%
% g) display one central axial slice at the first time point

k = round(size(Im,3)/2);
k_slice = Im(:,:,k,1);
figure;
imagesc(k_slice);
colorbar
colormap(gray)
datacursormode on

%% 2) Display the fMRI temporal sequence signals corresponding to two different voxels of the brain

%% 
% a) choose the coordinates of P1 and P2 selecting two points corresponding 
% to gray matter from the previously displayed figure, 
% e.g. P1=[26 26 k_slice];  P2=[28 40 k_slice];

P1 = [30, 26, k];
P2 = [33, 29, k];

%%
% b) Select the corresponding temporal sequence from Im. Check for
% singleton dimensions and squeeze the signal

TS1 = squeeze(Im(P1(2), P1(1), k, :));
TS2 = squeeze(Im(P2(2), P2(1), k, :));

%%
% c) plot the temporal signals reporting physical units (i.e. seconds,
% as reported in info.TimeUnits) on the time axis

time = (0:size(TS1, 1)-1) * vt; % create time vector based on voxel size
figure; 
plot(time, TS1, 'r', time, TS2, 'b'); % plot temporal signals
xlabel(['Time (' info.TimeUnits ')']); % label x-axis with time units
ylabel('Signal Intensity');
legend('Voxel P1', 'Voxel P2');

%% 3) Display the temporal signal averaged in a cubic Region of Interest (ROI) ...
% a) define a three-element vector reporting the displacement in the three
% directions from P to build a cube or parallelepiped ROI centered at P;
% define P1a and P1b as the opposite corners of the cube/
% parallelepiped ROI.

L = [2 2 1];
P1a = P1-L;
P1b = P1+L;

%%
% b) select the 4D array with signals from the defined ROI
% (extrapolate all voxels between P1a and P1b for each time value)

ROI_P1 = Im(P1a(2):P1b(2), P1a(1):P1b(1), P1a(3):P1b(3), :);

%%
% c) average the signal over the spatial dimensions and remove singleton
% dimensions

ROI_P1_t = squeeze(mean(ROI_P1, [1, 2, 3]));

%%
% d) plot the signal at P1 and the signal averaged in the ROI_P1 for
% comparison

figure; % plot with axis label and legend
plot(time, TS1, 'r', time, ROI_P1_t, 'g'); % plot temporal signals
xlabel(['Time (' info.TimeUnits ')']); % label x-axis with time units
ylabel('Signal Intensity');
legend('Voxel P1', 'Averaged ROI Signal (P1)');
title('Comparison of single voxel vs ROI-averaged signal')

%% 4) ... and see what happens with different ROI sizes
% try with a for loop over the ROI side dimension (a cube is fine)

for side = 1:3
    L = side * ones(1, 3); % update ROI size
    P1a = P1-L;
    P1b = P1+L;
    ROI_P1 = Im(P1a(2):P1b(2), P1a(1):P1b(1), P1a(3):P1b(3), :);
    ROI_P1_t = squeeze(mean(ROI_P1, [1, 2, 3]));
    
    figure; % Plot the averaged signal for each ROI size
    plot(time, TS1, 'r', time, ROI_P1_t, 'g');
    xlabel(['Time (' info.TimeUnits ')']);
    ylabel('Signal Intensity');
    legend('Voxel P1', 'Averaged ROI Signal (P1)');
    title(['ROI Size: ' num2str(side)]);
end

%% 5) Extra question: Compute the Pearson correlation between the signals at P1 and P2
% Compute the Pearson correlation coefficient between the signals

TS1 = double(TS1);
TS2 = double(TS2);
correlationCoefficient = corr(TS1, TS2);
disp(['Pearson correlation coefficient between P1 and P2: ' num2str(correlationCoefficient)]);
