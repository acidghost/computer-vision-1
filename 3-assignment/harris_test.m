close all

im_path = 'assets/pingpong/0000.jpeg';
kernel_length = 11;
sigma = 1.2;
window_size = 15;
threshold = 8;
[H, r, c] = harris_corners(im_path, kernel_length, sigma, window_size, threshold);
