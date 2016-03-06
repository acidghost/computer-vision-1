clear, close all

im_path = 'assets/pingpong/0000.jpeg';
% im_path = 'assets/person_toy/00000001.jpg';
kernel_length = 11;
sigma = 1.5;
window_size = 11;
threshold = 10;
[H, r, c] = harris_corners(im_path, kernel_length, sigma, window_size, threshold);
figure, mesh(H'), title('H surface plot')

fprintf('%d keypoints detected\n', size(r, 1));


im_rgb = imread(im_path);
im = im2double(rgb2gray(im_rgb));
corners = corner(im, length(r));
figure, imagesc(im_rgb), hold on
plot(corners(:,1), corners(:,2), 'bo')
title('Features detected using MATLAB corner function')
fprintf('%d keypoints detected with corners function\n', size(corners, 1));

