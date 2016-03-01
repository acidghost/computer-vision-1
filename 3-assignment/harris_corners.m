function [ H, r, c ] = harris_corners( im_path, kernel_length, sigma, window_size, threshold )
%HARRIS_CORNERS Find corners in an image and return H an points in r and c

im_rgb = imread(im_path);
im_gray = rgb2gray(im_rgb);
im = im2double(im_gray);


% Define gaussians
siz = (kernel_length-1) / 2;
kernel_size = -siz:siz;
[Xk, Yk] = meshgrid(kernel_size);
kernel_x = fspecial('gaussian', kernel_length, sigma);
kernel_xd = (Xk .* kernel_x) / (sigma^2);
kernel_y = kernel_x';
kernel_yd = (Yk .* kernel_y) / (sigma^2);


% Convolve image with guassian derivative
Ix = conv2(im, kernel_xd, 'same');
figure, imagesc(Ix), colormap gray, title('Image gradient in X direction I_x');
Iy = conv2(im, kernel_yd, 'same');
figure, imagesc(Iy), colormap gray, title('Image gradient in Y direction I_y');


% Define large gaussian 
g = fspecial('gaussian',max(1,fix(6*sigma)), sigma);

Ix2 = conv2(Ix.^2, g, 'same');
Iy2 = conv2(Iy.^2, g, 'same');
Ixy = conv2(Ix.*Iy, g,'same');


A = Ix2; B = Ixy; C = Iy2;
H = (A.*C - B.^2) - 0.04 * ((A + C).^2);

nrows = size(H, 1);
ncols = size(H, 2);
k = 1;
r = zeros(ncols + nrows, 1);
c = zeros(ncols + nrows, 1);
half_winsize = (window_size - 1) / 2;
for y=1+half_winsize:nrows-half_winsize;
    for x=1+half_winsize:ncols-half_winsize;
        window = H((y-half_winsize):(y+half_winsize), (x-half_winsize):(x+half_winsize));
        p = H(y, x);
        if p > threshold && sum(sum(p > window)) == length(window) - 1
            r(k, 1) = y;
            c(k, 1) = x;
            k = k + 1;
        end
    end
end
r = r(r ~= 0);
c = c(c ~= 0);

figure, imshow(im_rgb), hold on
plot(r, c, 'b+', 'MarkerSize', 8)
title(sprintf('Detected features with n=%d \\sigma=%f', window_size, sigma))
hold off

end

