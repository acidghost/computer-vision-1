function [ H, r, c ] = harris_corners( im_path, kernel_length, sigma, window_size, threshold )
%HARRIS_CORNERS Find corners in an image and return H an points in r and c

im_rgb = imread(im_path);
im_gray = rgb2gray(im_rgb);
im = im2double(im_gray);


%% Compute gaussian partial derivatives
siz = (kernel_length-1) / 2;
kernel_size = -siz:siz;
[Xk, Yk] = meshgrid(kernel_size);
kernel_x = fspecial('gaussian', kernel_length, sigma);
kernel_xd = (Xk .* kernel_x) / (sigma^2);
kernel_y = kernel_x';
kernel_yd = (Yk .* kernel_y) / (sigma^2);


%% Convolve image with guassian derivative
% to obtain gradients in X and Y directions
Ix = conv2(im, kernel_xd, 'same');
Iy = conv2(im, kernel_yd, 'same');
figure % Plot gradient images
subplot 121, imagesc(Ix), colormap gray, title('Image gradient in X direction I_x');
subplot 122, imagesc(Iy), colormap gray, title('Image gradient in Y direction I_y');


% Define large gaussian 
g = fspecial('gaussian',max(1,fix(6 * window_size)), sigma);
% Convolve with gaussian
Ix2 = conv2(Ix.^2, g, 'same');
Iy2 = conv2(Iy.^2, g, 'same');
Ixy = conv2(Ix.*Iy, g, 'same');


%% Compute the 'cornerness' matrix H
A = Ix2; B = Ixy; C = Iy2;
H = (A.*C - B.^2) - 0.04 * ((A + C).^2);
% Scale H
H = (1000 / max(max(H))) * H;

%% Find local maxima within the window
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
        if p > threshold && sum(sum(p > window)) == (window_size^2) - 1
            r(k, 1) = y;
            c(k, 1) = x;
            k = k + 1;
        end
    end
end
r = r(r ~= 0);
c = c(c ~= 0);

%% Plot feature points found over original image
figure, imagesc(im_rgb)
hold on, plot(r, c, 'bo')
title(sprintf('Detected features with window\\_size=%d \\sigma=%.2f', window_size, sigma))
hold off

end

