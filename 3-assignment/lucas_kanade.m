function [ u, v ] = lucas_kanade( imfull1, imfull2, regions_size, show_loops, quiver_scale, keypoints )
%LUCAS_KANADE Compute optical flow using Lucas-Kanade method


% Load frames
if size(imfull1, 3) ~= 1
    isrgb = true;
    im1 = im2double(rgb2gray(imfull1));
    im2 = im2double(rgb2gray(imfull2));
else
    isrgb = false;
    im1 = im2double(imfull1);
    im2 = im2double(imfull2);
end


[nrows, ncols] = size(im1);
imsize = [nrows, ncols];


kernel_length = 5;
sigma = 1;
siz = (kernel_length-1) / 2;
kernel_size = -siz:siz;
kernel_x = gaussian(sigma, kernel_length);
kernel_xd = (kernel_size .* kernel_x) / (sigma^2);
kernel_y = kernel_x';
kernel_yd = (kernel_size' .* kernel_y) / (sigma^2);


%% Apply gaussian derivative to compute image derivatives
Ix_full = conv2(im1, kernel_xd, 'same') + conv2(im2, kernel_xd, 'same');
Iy_full = conv2(im1, kernel_yd, 'same') + conv2(im2, kernel_yd, 'same');
It_full = conv2(im1, .5 * ones(size(kernel_xd)), 'same') + conv2(im2, -.5 * ones(size(kernel_xd)), 'same');


%% Apply Lucas-Kanade method
half_regions_size = (regions_size-1) / 2;
if ~exist('keypoints', 'var')
    u = zeros(imsize);
    v = zeros(imsize);
    % Loop over the non-overlapping regions
    for y = 1+half_regions_size:regions_size:nrows-half_regions_size;
        for x = 1+half_regions_size:regions_size:ncols-half_regions_size;
            U = solve_region(y, x, half_regions_size, Ix_full, Iy_full, It_full);

            u(y, x) = U(1);
            v(y, x) = U(2);
        end
    end
else
    u = zeros(size(keypoints, 1), 1);
    v = zeros(size(keypoints, 1), 1);
    % Loop over the keypoints
    for k = 1:size(keypoints, 1)
        y = keypoints(k, 1);
        x = keypoints(k, 2);
        
        U = solve_region(y, x, half_regions_size, Ix_full, Iy_full, It_full);
        
        % Keypoints are yx-based, so U(1) contains x values (is the motion 
        % vector x component). Same thing holds for U(2), y and u
        v(k) = U(1);
        u(k) = U(2);
    end
end


%% Show results
% Animate two frames with optic flow
if show_loops > 0
    figure
    if ~isrgb
        colormap gray
    end
    for i = 1:show_loops;
        imagesc(imfull1), hold on
        quiver(u, v, quiver_scale )
        title('First frame'), hold off
        drawnow, pause(.5)

        imagesc(imfull2), hold on
        quiver(u, v, quiver_scale )
        title('Second frame'), hold off
        drawnow, pause(.5)
    end
end


end


function U = solve_region(y, x, half_regions_size, Ix_full, Iy_full, It_full)
% SOLVE_REGION Solves the system of constraints for the region around (x,y)
%              with radius 'half_regions_size' returning the optic flow

yrange = y-half_regions_size:y+half_regions_size;
xrange = x-half_regions_size:x+half_regions_size;
Ix = Ix_full(yrange, xrange);
Iy = Iy_full(yrange, xrange);
It = It_full(yrange, xrange);

A = [Ix(:) Iy(:)];
b = -It(:);

U = pinv(A' * A) * A' * b;

end

