clc;	% Clear command window.
clear;	% Delete all variables.
close all;	% Close all figure windows except those created by imtool.
imtool close all;	% Close all figure windows created by imtool.
workspace;	% Make sure the workspace panel is showing.
fontSize = 15;
%% Question 1a

%Image 'albert.jpg' is loaded into MATLAB
rgbIm = imread('albert.jpg');

%Preprocessing of the image
rgbIm = im2double(rgbIm);
[rows, columns, colourband] = size(rgbIm);

%Performing 2D Fourier Transform for the laoded image.
rgbIm_fft = fft2(rgbIm);
rgbIm_amp = abs(rgbIm_fft);   %The magnitude part of the image
rgbIm_phase = angle(rgbIm_fft);   %The phase part of the image

%Reconstruct the image by combining again the mangnitude and phase part of
%the image
Im_fft_recon = rgbIm_amp .* exp(1j*rgbIm_phase);
Im_recon = ifft2(Im_fft_recon);

%Displaying original image
subplot(3, 3, 1);
imshow(rgbIm);
title('Original Color Image', 'FontSize', fontSize);
% Enlarge figure to full screen.
set(gcf, 'Position', get(0,'Screensize')); 
% Give a name to the title bar.
set(gcf,'name','Image processing of Albert Einstein','numbertitle','off') 


% Display the magnitude, phase and reconstructed image
subplot(3, 3, 2);
imshow(rgbIm_amp);
title('Image amplitude', 'FontSize', fontSize);
subplot(3, 3, 3);
imshow(rgbIm_phase);
title('Image phase', 'FontSize', fontSize);
subplot(3, 3, 4);
imshow(Im_recon);
title('Reconstructed image', 'FontSize', fontSize);

%%  Question 1b

%Creating randomm gaussian noise to the reconstructed Einstein image
Gaussian_noiseIm=imnoise(rgbIm,'gaussian');

%Showing the image with noise
subplot(3, 3, 5);
imshow(Gaussian_noiseIm);
title('Gaussian noise', 'FontSize', fontSize);


%% Question 1c

%Adding random noise (salt and pepper type) to the image in 1(b)
Sum_noiseIm=imnoise(Gaussian_noiseIm, 'salt & pepper');

%Showing the image with all noise added
subplot(3, 3, 6);
imshow(Sum_noiseIm);
title('Gaussian + Salt & Pepper noise', 'FontSize', fontSize);

%% Question 1d

% ##### Filtering 'Salt and Pepper' noise #####
% Extract the individual red, green, and blue color channels.
redChannel = Sum_noiseIm(:, :, 1);
greenChannel = Sum_noiseIm(:, :, 2);
blueChannel = Sum_noiseIm(:, :, 3);

% Median Filter the RGB channels:
redMF = medfilt2(redChannel, [3 3]);
greenMF = medfilt2(greenChannel, [3 3]);
blueMF = medfilt2(blueChannel, [3 3]);

% Find the noise in the red.
noiseImage = (redChannel == 0 | redChannel == 255);
% Get rid of the noise in the red by replacing with median.
noiseFreeRed = redChannel;
noiseFreeRed(noiseImage) = redMF(noiseImage);

% Find the noise in the green.
noiseImage = (greenChannel == 0 | greenChannel == 255);
% Get rid of the noise in the green by replacing with median.
noiseFreeGreen = greenChannel;
noiseFreeGreen(noiseImage) = greenMF(noiseImage);

% Find the noise in the blue.
noiseImage = (blueChannel == 0 | blueChannel == 255);
% Get rid of the noise in the blue by replacing with median.
noiseFreeBlue = blueChannel;
noiseFreeBlue(noiseImage) = blueMF(noiseImage);

%Image with filtered salt and pepper noise
denoisedIm = cat(3, noiseFreeRed, noiseFreeGreen, noiseFreeBlue);


% ##### Using convolution method to filter out gaussian noises #####
denoisedIm = convn(double(denoisedIm), ones(3)/9, 'same');

%Showing the denoised image
subplot(3, 3, 7);
imshow(denoisedIm);
title('Denoised image', 'FontSize', fontSize);

%% Question 1e

%Implementing a high pass filter on the image in 1(a), reconstructed image

kernel1 = [0 -1/4 0;-1/4 2 -1/4;0 -1/4 0];  %High pass filter for sharpening image
kernel2 = [-1 -1 -1;-1 8 -1;-1 -1 -1];    %High pass filter with oversharped feature

%Applying high pass filter (kernel1 and kernel2) to Image reconstructed
%from 1(a)

filteredIm1 = imfilter(Im_recon, kernel1, 'same');
filteredIm2 = imfilter(Im_recon, kernel2, 'same');

%Showing the filtered image from high pass filter with good sharpening
%technique
subplot(3, 3, 8);
imshow(filteredIm1);
title('Good high-pass filtered image', 'FontSize', fontSize);

%Showing the filtered image from high pass filter with bad sharpening
%technique
subplot(3, 3, 9);
imshow(filteredIm2);
title('Bad high-pass filtered image', 'FontSize', fontSize);