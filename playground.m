clear;clc;

img = imread('data\test.jpg');
% img = imresize(img, 0.25);
figure;
imshow(img);
% imgR = img(:, :, 1);
% imgG = img(:, :, 2);
% imgB = img(:, :, 3);
% figure;
% imshow(imgR);
% figure;
% imshow(imgG);
% figure;
% imshow(imgB);

% IMGR = fft2(imgR);
% GuvR = fftshift(IMGR);
% figure;
% imshow(log(abs(GuvR) + 1), []);

% IMGG = fft2(imgG);
% GuvG = fftshift(IMGG);
% figure;
% imshow(log(abs(GuvG) + 1), []);
% 
% IMGB = fft2(imgB);
% GuvB = fftshift(IMGB);
% figure;
% imshow(log(abs(GuvB) + 1), []);


IMG = fft2(img);
Guv = fftshift(IMG);
figure;
imshow(log(abs(Guv) + 1), []);