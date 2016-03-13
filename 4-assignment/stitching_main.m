clear, close all

%% Detect frames (keypoints), descriptors and matches
impath1 = 'assets/left.jpg';
impath2 = 'assets/right.jpg';
im1 = imread(impath1);
im2 = imread(impath2);

[im1sizey, im1sizex, channels] = size(im1);
[im2sizey, im2sizex, ~] = size(im2);

if channels ~= 1
    im1 = rgb2gray(im1);
    im2 = rgb2gray(im2);
end

im1 = im2single(im1);
im2 = im2single(im2);

[frames1, frames2, matches] = get_matches(im1, im2);

%% Set up and perform RANSAC
N = 5;
P = 3;
radius = 10;
[best_params, inliers_count bestSample1 bestSample2] = ransac(N, P, radius, frames1, frames2, matches, im1, im2);


%% Transform second image
% Mean coordinates of features in each image
mean1 = round(mean(bestSample1, 2));
mean2 = round(mean(bestSample2, 2));

% Create background for image 2
temp_image = zeros(size(im2));
temp_image(mean2(2), mean2(1)) = 255;

background = transform_image(temp_image, best_params);

% Transform mean and image 2
[~,ind] = max(background(:));
[mean2_t(2) ,mean2_t(1)] = ind2sub(size(background),ind);

im2_t = transform_image(im2, best_params);
[im2_tsizey, im2_tsizex] = size(im2_t);
figure
imshow(im2_t);


%% Create coordinate system
% Compute corners for overlapping area  (origin at top left of im2)
top = mean2_t(2) - mean1(2);
left = mean2_t(1) - mean1(1);
right = im2_tsizex - mean2_t(1) - im1sizex + mean1(1);
bottom = im2_tsizey - mean2_t(2) - im1sizey + mean1(2);

% Estimate size and create canvas
estimated_y = im1sizey + max(top, 0) + max(bottom, 0);
estimated_x = im1sizex + max(left, 0) + max(right, 0);

new_image = zeros(estimated_y, estimated_x);


%% Stitch
% Place second image
new_image(max(-top,1):min(end, max(-top,1) + im2_tsizey - 1), max(-left,1):min(end, max(-left,1) + im2_tsizex - 1)) = im2_t(1:min(end, estimated_y - max(-top,1) + 1), 1:min(end, estimated_x - max(-left,1)+1));

% Place first image
space_needed = double(im1(1:min(end, estimated_y - max(top,1) + 1), 1:min(end, estimated_x - max(left,1)+1)));
space_available = new_image(max(top,1):min(end, max(top,1) + im1sizey - 1), max(left,1):min(end, max(left,1) + im1sizex - 1));

new_image(max(top,1):min(end, max(top,1) + im1sizey - 1), max(left,1):min(end, max(left,1) + im1sizex - 1)) = max(space_needed, space_available);

figure('Name', 'Stitched Image')
imshow(new_image);




