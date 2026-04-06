%% Exercise 1 -  DICOM file reading and visualizing 
% The objective is: 
%   1) to read a DICOM folder that contains different series of 2D DICOM
%   images
%   2) to read a DICOM folder that contains different 3D DICOM series 
%   3) to display 2D axial, coronal and sagittal views of 3D volumes
%
% Sample DICOM images are available at
% <https://pandora.infn.it/public/cmepda/DATASETS/IMAGES/DICOM_Examples/ INFN Pandora>
% or on drive <https://drive.google.com/drive/folders/1YqK7ZkM-P2IrqfD7Pj-SCmjz-GWd_1-Y?usp=sharing Google drive folder>
%
% Choose for this exercise:
% the Breast_Mammography_Case2/ dataset to complete point 1), 
% the Lung_CT_cd2/ dataset for points 2) and 3).
%
% Complete the lines starting with %c

%% 1) Read a DICOM folder that contains different series of 2D DICOM images
% A preliminary exploration of the content of a directory containing dicom files
% can be done with the DICOM Browser app (check the MATLAB APP menu)


%% 
% Clear the workspace, close all figures and clear the command window

close all
clear
clc

%% 
% Define the path of the data folder dir (mammography example)

filedir = 'C:\Users\linda\Desktop\materiali università\magistrale\Computing methods for experimental physics\Imaging\some imaging data\Breast_Mammography_Case2';

%% 
% Use dicomCollection to gather details about the series included in DICOM
% folder

collection = dicomCollection(filedir);

%% 
% Read the right (R) mediolateral oblique (MLO) view (to which series it corresponds?) 
% using dicomread
% NB: dicomCollection returns a table, use the table element containing 
% the filename of the image to read  

filename = collection.Filenames{4};
R_MLO = dicomread(filename);

%% 
% Visualize the 2D image 

figure; %create a new empty graphical window
imagesc(R_MLO)

%%
% Change the colormap to gray
colorbar
colormap(gray)

%% 2) Read a DICOM folder that contains different 3D DICOM series
% Define the path of the data folder dir (lung CT example)

filedir = 'C:\Users\linda\Desktop\materiali università\magistrale\Computing methods for experimental physics\Imaging\some imaging data\Lung_CT_cd2';

%% 
% In that directory there is a file named dicomdir. 
% 
% A DICOM directory file (DICOMDIR) is a special DICOM file that serves 
% as a directory to a collection of DICOM files stored on removable media, 
% such as CD/DVD ROMs. When devices write DICOM files to removable media, 
% they typically write a DICOMDIR file on the disk to serve as a list of 
% the disk contents.
%
% Use dicomCollection to gather details about the series included in DICOM
% folder. You can pass to dicomCollection either the filedir or the
% dicomdir file name

collection = dicomCollection(filedir);

%%
% Use dicomreadVolume to read a series of DICOM files (high resolution CT
% volume). Open only the series of interest with dicomreadVolume

[V,spatial,dim] = dicomreadVolume(collection.Filenames{1});

%%
% Explore the dicomreadVolume output.
%
% spatial and dim variables contain useful voxel size information:
% - spatial is a structure describing the location, resolution, 
% and orientation of slices in the volume. 
% - dim specifies which real-world dimension (X = 1, Y = 2, Z = 3) 
% has the largest amount of offset from the previous slice.
%
% Check the dimension of V

size(V)

%%
% The dimensions of V are [rows,columns,samples,slices] where samples 
% is the number of color channels per voxel. For example, grayscale volumes 
% have one sample, and RGB volumes have three samples. 
% Use the squeeze function to remove any singleton dimensions
% (in this case, samples has a dimension equal to 1, so it can be removed)

V_3D = squeeze(V);
size(V_3D)

%%
% Display one axial slice of the volume V 
% (now slices are on the third and last axis of the V_3D matrix)

figure;
sliceIndex = 200;
imshow(V_3D(:,:,sliceIndex), [])

%% 3) Display 2D axial, coronal and sagittal views of 3D volumes
% Display the axial, coronal and sagittal views of the 3D volume V_3D 
% intersecting at a given point P(i,j,k), 
% similarly to the Mango viewer default display.
% Let's stat from a central point P=[i,j,k].
% Define the cordinates of a central point for the volume V_3D

dims = size(V_3D); % [rows, columns, slices]
i = round(dims(1)/2);
j = round(dims(2)/2);
k = round(dims(3)/2);
P = [i, j, k]; 

%% 
% Display an axial slice passing by P (i.e. z is fixed)

Im_Ax = V_3D(:,:,P(3));
figure;
imshow(Im_Ax, [])

%%
% It is not correctly oriented. To oriented it as in Mango's neurological coordinate 
% system ("Left is left"), try to left-right flip with fliplr

Im_Ax_flipped = fliplr(Im_Ax);
figure;
imshow(Im_Ax_flipped, [])

%% 
% Display a coronal slice passing by P (i.e. x is fixed) 
% Tip: check for singleton dimensions

Im_Cor = squeeze(V_3D(P(1), :, :));

%% 
% Display Im_Cor

figure;
imshow(Im_Cor, [])

%% 
% It is not correctly oriented. To oriented it as in Mango's neurological coordinate 
% system, try a 90degree rotation (rot90), then a left-right flip

Im_Cor_rot = rot90(Im_Cor);
Im_Cor_flipped = fliplr(Im_Cor_rot);
figure;
imshow(Im_Cor_flipped, [])

%%
% Display a sagittal slice passing by P (i.e. y is fixed)

Im_Sag = squeeze(V_3D(:, P(2), :));

%% 
% Display Im_Sag

figure;
imshow(Im_Sag, [])

%% 
% It is not correctly oriented. To oriented it as in Mango's neurological coordinate 
% system, try a 90degree rotation

Im_Sag_rot = rot90(Im_Sag);
figure;
imshow(Im_Sag_rot, [])

%% 
% Display the three views together, with a big axial on top and smaller
% coronal and sagittal in the second row.

figure;
subplot(2,2,1:2)
imshow(Im_Ax_flipped, []);
title('Axial slice');
subplot(2,2,3);
imshow(Im_Cor_flipped, []);
title('Coronal slice');
subplot(2,2,4);
imshow(Im_Sag_rot, []);
title('Sagittal slice');

%% 
% Display the views passing for a different point P 
% (e.g. P=[300 70 100] corresponding to point (69,299,200) in Mango 
% (which starts numbering from zero)

P = [300, 70, 100];
Im_Ax = V_3D(:,:,P(3));
Im_Ax_flipped = fliplr(Im_Ax);
Im_Cor = squeeze(V_3D(P(1), :, :));
Im_Cor_rot = rot90(Im_Cor);
Im_Cor_flipped = fliplr(Im_Cor_rot);
Im_Sag = squeeze(V_3D(:, P(2), :));
Im_Sag_rot = rot90(Im_Sag);
figure;
subplot(2,2,1:2), imagesc(Im_Ax_flipped), title('Axial slice');
subplot(2,2,3), imagesc(Im_Cor_flipped), title('Coronal slice');
subplot(2,2,4), imagesc(Im_Sag_rot), title('Sagittal slice');
colormap(gray)

%% 
% In R2019b the orthosliceViewer has been introduced in MATLAB.
% The orthosliceViewer object opens a viewer for exploring grayscale 
% and RGB volumes. The viewer displays three orthogonal views of the 
% volume: a view along the x, y, and z dimensions.