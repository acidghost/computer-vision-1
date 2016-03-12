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


%% Transform im1 using found parameters
imtrans1 = transform_image(im1, best_params);
figure  % plot transformed im1 and im2
subplot 121, imagesc(imtrans1), colormap gray
subplot 122, imagesc(im2), colormap gray

%% Transform im2 using found parameters
imtrans2 = transform_image(im2, best_params, 1);
figure  % plot im1 and transformed im2
subplot 121, imagesc(im1), colormap gray
subplot 122, imagesc(imtrans2), colormap gray


%% Compare with imtransform and maketform
affine = [ best_params(1) best_params(2) 0 ;...
           best_params(3) best_params(4) 0 ;...
           best_params(5) best_params(6) 1 ];

T = maketform('affine', affine);
inv_affine = T.tdata.Tinv;

% transform first image
Tinv = maketform('affine', inv_affine);
imtrans1m = imtransform(im1, Tinv, 'nearest');
% transform second image
imtrans2m = imtransform(im2, T, 'nearest');

figure
subplot 221, imagesc(imtrans1), colormap gray
subplot 222, imagesc(imtrans1m), colormap gray
subplot 223, imagesc(imtrans2), colormap gray
subplot 224, imagesc(imtrans2m), colormap gray
