clear, close all

%% Detect frames (keypoints), descriptors and matches
impath1 = 'assets/left.jpg';
impath2 = 'assets/right.jpg';
im1 = imread(impath1);
im2 = imread(impath2);

[im1sizey, im1sizex, channels] = size(im1);
[im2sizey, im2sizex, ~] = size(im2);

if channels ~= 1
    im1 = rgb2gray(im1);
    im2 = rgb2gray(im2);
end

im1 = im2single(im1);
im2 = im2single(im2);

[frames1, frames2, matches] = get_matches(im1, im2);

%% Set up and perform RANSAC
N = 35;
P = 3;
radius = 10;
[best_params, inliers_count, best_inliers] = ransac(N, P, radius, frames1, frames2, matches, im1, im2);

nonzero_inlier = find(best_inliers == 1);

kps1 = frames1(1:2, matches(1, nonzero_inlier));
kps2 = frames2(1:2, matches(2, nonzero_inlier));
[tkps_x, tkps_y] = transform_points(kps2(1,:), kps2(2,:), best_params, 1);
im2_t = transform_image(im2, best_params, 1);
figure
subplot 121, imagesc(im1), colormap gray, hold on
plot(kps1(1, :), kps1(2, :), 'o'), hold off
subplot 122, imagesc(im2_t), colormap gray, hold on
plot(kps2(1, :), kps2(2, :), 'bo'),
plot(tkps_x, tkps_y, 'ro'), hold off


%% Estimate length
[xsize, ysize, xmin, ymin] = find_transformation_bound([im2sizey, im2sizex], best_params);

im2start = mean(kps2 - [tkps_x; tkps_y], 2);

im2start = ceil(im2start);
estimated_x = im1sizex + xsize + im2start(1);
estimated_y = im1sizey + ysize + im2start(2);


%% Stitch
new_image = zeros(estimated_y, estimated_x);
for y = 1:im1sizey
    for x = 1:im1sizex
        new_image(y, x) = im1(y, x);
    end
end
for y = 0:ysize-1
    for x = 0:xsize-1
        if new_image(y + im1sizey + im2start(2), x + im1sizex + im2start(1)) == 0
            new_image(y + im1sizey + im2start(2), x + im1sizex + im2start(1)) = im2_t(y+1, x+1);
        end
    end
end

figure, imagesc(new_image), colormap gray


% for i = 1:estimated_y
%    for j = 1:estimated_x
%        % copy first image
%        if(i <= im1sizey) && (j  <= im1sizex)
%            new_image(i, j) = im1(i, j);
%        elseif (i <= im1sizey)
%            new_image(i, j) = im2_t(i, j-im1sizex);
%        elseif (j  <= im1sizex)
%            new_image(i, j) = im2_t(i-im1sizey, j);
%        else
%            new_image(i, j) = im2_t(i-im1sizey, j-im1sizex);
%        end
%    end
% end
