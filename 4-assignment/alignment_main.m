clear, close all


%% Detect frames (keypoints), descriptors and matches
impath1 = 'assets/boat/img1.pgm';
impath2 = 'assets/boat/img2.pgm';
im1 = im2single(imread(impath1));
im2 = im2single(imread(impath2));

[frames1, frames2, matches] = get_matches(im1, im2);

%% Set up and perform RANSAC
N = 1;
P = 3;
radius = 10;
[best_params, inliers_count] = ransac(N, P, radius, frames1, frames2, matches, im1, im2);


% %% Transform im1 using found parameters
% imtrans = transform_image(im1, best_params);
% figure  % plot transformed im1 and im2
% subplot 121, imagesc(imtrans), colormap gray
% subplot 122, imagesc(im2), colormap gray
% 
% %% Transform im2 using found parameters
% imtrans = transform_image(im2, best_params, 1);
% figure  % plot transformed im1 and im2
% subplot 121, imagesc(im1), colormap gray
% subplot 122, imagesc(imtrans), colormap gray


% TODO compare with imtransform and maketform

