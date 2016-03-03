function [ u, v ] = lucas_kanade( impath1, impath2, regions_size, show_loops, quiver_scale )
%LUCAS_KANADE Compute optical flow using Lucas-Kanade method


imfull1 = imread(impath1);
imfull2 = imread(impath2);
if size(imfull1, 3) ~= 1
    isrgb = true;
    im1 = im2double(rgb2gray(imfull1));
    im2 = im2double(rgb2gray(imfull2));
else
    isrgb = false;
    im1 = im2double(imfull1);
    im2 = im2double(imfull2);
end

half_regions_size = (regions_size-1) / 2;

[nrows, ncols] = size(im1);
imsize = [nrows, ncols];


kernel_length = 11;
sigma = 1;
siz = (kernel_length-1) / 2;
kernel_size = -siz:siz;
kernel_y = gaussian(sigma, kernel_length);
kernel_yd = (kernel_size .* kernel_y) / (sigma^2);
kernel_x = kernel_y';
kernel_xd = (kernel_size' .* kernel_x) / (sigma^2);


Ix_full = conv2(im1, kernel_xd, 'same') + conv2(im2, kernel_xd, 'same');
Iy_full = conv2(im1, kernel_yd, 'same') + conv2(im2, kernel_yd, 'same');
It_full = conv2(im1, .5 * ones(kernel_length), 'same') + conv2(im2, -.5 * ones(kernel_length), 'same');


u = zeros(imsize);
v = zeros(imsize);
for y = 1+half_regions_size:regions_size:nrows-half_regions_size;
    for x = 1+half_regions_size:regions_size:ncols-half_regions_size;
        yrange = y-half_regions_size:y+half_regions_size;
        xrange = x-half_regions_size:x+half_regions_size;
        Ix = Ix_full(yrange, xrange)';
        Iy = Iy_full(yrange, xrange)';
        It = It_full(yrange, xrange);
        
        A = [Ix(:) Iy(:)];
        b = -It(:);
        
        U = pinv(A' * A) * A' * b;

        u(y, x) = U(1);
        v(y, x) = U(2);
    end
end


% figure
% subplot 121, imagesc(imfull1), hold on
% quiver(u, v, quiver_scale), hold off
% subplot 122, imagesc(imfull2), hold on
% quiver(u, v, quiver_scale), hold off


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

