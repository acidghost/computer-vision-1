clear, close all

%% Load and convert images
impath1 = 'assets/left.jpg';
impath2 = 'assets/right.jpg';
im1 = imread(impath1);
im2 = imread(impath2);

[im1sizey, im1sizex, channels] = size(im1);

if channels ~= 1
    im1 = rgb2gray(im1);
    im2 = rgb2gray(im2);
end

%% Stitch images and show result
new_image = stitch(im1, im2);

figure('Name', 'Stitched Image')
imshow(new_image);

