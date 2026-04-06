%% Exercise 3 - Display image overlays 
% The objective is to visualize image overlays:
% 1) load NIfTI file of a 3D structural MRI AD_002_S_0619.nii and segmented tissues:
%    - c1AD_002_S_0619.nii is the segmented gray matter (GM);
%    - c2AD_002_S_0619.nii is the segmented white matter (WM);
%    - c3AD_002_S_0619.nii is the segmented cerebrospinal fluid (CSF);
% 2) display a set of slices for each volume;
% 3) overlay the segmented tissues to the structural MRI;
%
% Sample NIfTI images for this exercise are available at
% <https://pandora.infn.it/public/cmepda/DATASETS/IMAGES/DICOM_Examples/ INFN Pandora>
% or on drive
% <https://drive.google.com/drive/folders/1YqK7ZkM-P2IrqfD7Pj-SCmjz-GWd_1-Y?usp=sharing
% Google drive folder> 
% in the /IMAGES/NIfTI_Examples/Brain_segment/ folder.
% Choose the following NIfTI volumes:
% AD_002_S_0619.nii c1AD_002_S_0619.nii c2AD_002_S_0619.nii c3AD_002_S_0619.nii
%
% Complete the lines starting with %c

%% 1) Read the images (T1w MRI and the segmented tissues)
% Use strcat to build the filenames of the tissue files

dirname = 'C:\Users\linda\Desktop\materiali università\magistrale\Computing methods for experimental physics\Imaging\some imaging data\Brain_segment\';
filename = 'AD_002_S_0619.nii';
Im = niftiread(strcat(dirname, filename));
Im_c1 = niftiread((strcat(dirname,'c1', filename)));   
Im_c2 = niftiread((strcat(dirname, 'c2', filename)));
Im_c3 = niftiread((strcat(dirname, 'c3', filename)));

%% 2) Display a set of slices for each volume 
% Use montage to display a multiple images, montage(filename,Name,Value). 
% The following "Name, Value" pairs could be useful:
% 'Indices', values  - to select some images to display 
% 'DisplayRange', Value - to adjust the contrast of the images

numSlices = size(Im, 3);
minVal = min(Im(:));
maxVal = max(Im(:));
figure; montage(Im(:,:,1:numSlices), 'DisplayRange', [minVal maxVal]);
title('3D structural MRI');

%%
% repeat for Im, Im_c1, Im_c2, Im_c3 

figure; 
montage(uint8(Im_c1*255), 'DisplayRange', [0 255]); title('Grey matter');
figure; 
montage(uint8(Im_c2*255), 'DisplayRange', [0 255]); title('White matter');
figure; 
montage(uint8(Im_c3*255), 'DisplayRange', [0 255]); title('Cerebrospinal fluid');

%% 3) Overlay the segmented tissues to the structural MRI
%
% a) explore the possibility to view image overlays with imshowpair
% work at a fixed k position, e.g. k_slice=110, and select 2D images from
% each volume

k_slice = 110;
Im1 = Im(:,:,k_slice);
Im1_c1 = Im_c1(:,:,k_slice);
Im1_c2 = Im_c2(:,:,k_slice);
Im1_c3 = Im_c3(:,:,k_slice);
% explore 'blend', 'falsecolor', 'montage'
figure; imshowpair(Im1_c1, Im1, 'montage'); title('MRI and grey matter');
figure; imshowpair(Im1_c2, Im1, 'falsecolor'); title('MRI and white matter');
figure; imshowpair(Im1_c3, Im1, 'blend'); title('MRI and cerebrospinal fluid');

%%
% b) Make an overlay with imoverlay, which overlays binary mask into 2-D image
% generate binary masks for GM with imbinarize

c1 = imbinarize(Im1_c1);

%%
% Make the samefor WM and CSF

c2 = imbinarize(Im1_c2);
c3 = imbinarize(Im1_c3);

%% 
% Rescale the grey levels of Im1 with rescale to correctly display it with imoverlay.  
% rescale scales the entries of an array to the interval [0,1]

Im1_scaled = rescale(Im1);  
B1 = imoverlay(Im1_scaled, c1, 'red');
figure; imshow(B1); title('Overlay of MRI and grey matter');
C1 = imoverlay(Im1_scaled, c2, 'magenta');
figure; imshow(C1); title('Overlay of MRI and white matter');
D1 = imoverlay(Im1_scaled, c3, 'cyan');
figure; imshow(D1); title('Overlay of MRI and cerebrospinal fluid');

%% 
% c) overlay more than two images iterating the imoverlay procedure

B2 = imoverlay(B1, c2, 'yellow');
figure; imshow(B2); title('Overlay of MRI, grey matter, and white matter');
B3 = imoverlay(B2, c3, 'green');
figure; imshow(B3); title('Overlay of MRI, grey matter, white matter, and cerebrospinal fluid');

%% 
% Change the selected slice and run it again 

k_slice = 50;
Im1 = Im(:,:,k_slice);
Im1_c1 = Im_c1(:,:,k_slice);
Im1_c2 = Im_c2(:,:,k_slice);
Im1_c3 = Im_c3(:,:,k_slice);
c1 = imbinarize(Im1_c1);
c2 = imbinarize(Im1_c2);
c3 = imbinarize(Im1_c3);
Im1_scaled = rescale(Im1); 
B1 = imoverlay(Im1_scaled, c1, 'red');
figure; imshow(B1); title('Overlay of MRI and grey matter');
B2 = imoverlay(B1, c2, 'blue');
figure; imshow(B2); title('Overlay of MRI, grey matter, and white matter');
B3 = imoverlay(B2, c3, 'white');
figure; imshow(B3); title('Overlay of MRI, grey matter, white matter, and cerebrospinal fluid');
