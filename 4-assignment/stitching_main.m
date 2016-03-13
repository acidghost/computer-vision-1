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

%% Detect frames (keypoints), descriptors and matches
im1 = im2single(im1);
im2 = im2single(im2);

[frames1, frames2, matches] = get_matches(im1, im2);

%% Set up and perform RANSAC
N = 35;
P = 3;
radius = 10;

[best_params, inliers_count, bestSample1, bestSample2] = ransac(N, P, radius, frames1, frames2, matches, im1, im2);

%% Stitch images and show result
new_image = stitch(im1, im2, best_params, bestSample1, bestSample2);

figure('Name', 'Stitched Image')
imshow(new_image);

