function [ H, r, c ] = harris_corners( im_path, kernel_length, sigma, window_size, threshold, display )
%HARRIS_CORNERS Find corners in an image and return H an points in r and c

if ~exist('display', 'var')
    display = 1;
end

im_rgb = imread(im_path);
im_gray = rgb2gray(im_rgb);
im = im2double(im_gray);


%% Compute gaussian partial derivatives
kernel_x = gaussian(sigma, kernel_length);
kernel_y = kernel_x';


%% Convolve image with gaussian derivative
% to obtain gradients in X and Y directions
Ix = gaussian_der(im, kernel_x, sigma, 'x');
Iy = gaussian_der(im, kernel_y, sigma, 'y');


if display
    figure % Plot gradient images
    subplot 121, imagesc(Ix), colormap gray, title('Image gradient in X direction I_x');
    subplot 122, imagesc(Iy), colormap gray, title('Image gradient in Y direction I_y');
end


%% Define large gaussian 
% make sure length is odd
if (mod(max(1,fix(6 * window_size)), 2) == 1)
    big_kernel_length = max(1,fix(6 * window_size));
else 
    big_kernel_length = max(1,fix(6 * window_size)) - 1;
end

big_kernel_y = gaussian(sigma, big_kernel_length);
big_kernel_x = big_kernel_y';
g = big_kernel_x * big_kernel_y;

% Convolve with gaussian
Ix2 = conv2(Ix.^2, g, 'same');
Iy2 = conv2(Iy.^2, g, 'same');
Ixy = conv2(Ix.*Iy, g, 'same');


%% Compute the corner metric H
A = Ix2; B = Ixy; C = Iy2;
H = (A.*C - B.^2) - 0.04 * ((A + C).^2);
% Scale H
H = (1000 / max(max(H))) * H;


%% Find local maxima within the window
% Non maximum suppression
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
if display
    figure, imagesc(im_rgb)
    hold on, plot(c, r, 'bo')
    title(sprintf('Detected features with window\\_size=%d \\sigma=%.2f threshold=%d', window_size, sigma, threshold))
    hold off
end

end

