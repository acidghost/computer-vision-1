close all

im_path = 'assets/pingpong/0000.jpeg';
kernel_length = 11;
sigma = 1;
window_size = 3;
threshold = 1;
[H, r, c] = harris_corners(im_path, kernel_length, sigma, window_size, threshold);
figure, mesh(H), title('')

im_rgb = imread(im_path);
im = im2double(rgb2gray(im_rgb));
corners = corner(im);
figure, imagesc(im_rgb), hold on
plot(corners(:,1), corners(:,2), 'bo')

