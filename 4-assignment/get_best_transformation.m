function [best_params matches_x1 matches_y1] = get_best_transformation(im1, im2, N)
%TODO refactor sub demo functions for deliverables

run('vlfeat-0.9.20/toolbox/vl_setup')

%% Detect frames (keypoints), descriptors and matches
[~, ~, channels] = size(im1);

if channels ~= 1
    im1 = rgb2gray(im1);
    im2 = rgb2gray(im2);
end

im1 = im2single(im1);
im2 = im2single(im2);

[frames1, desc1] = vl_sift(im1);
[frames2, desc2] = vl_sift(im2);

matches = vl_ubcmatch(desc1, desc2);


%% Set up
% Note: sub demo function 1 is this!!
nmatches = size(matches, 2);
P = 3;
max_inliers_iteration = 1;
best_params = zeros(6, 1);
radius = 10;
matches_x1 = frames1(1, matches(1, :));
matches_y1 = frames1(2, matches(1, :));
matches_x2 = frames2(1, matches(2, :));
matches_y2 = frames2(2, matches(2, :));
inliers_count = zeros(N, 1);

%% Find best
for n = 1:N
    fprintf('Iteration %d\n', n)

    % sample P matches (pairs of points)
    sample = get_sample(nmatches, P, matches);
    sampled1 = frames1(:, sample(1, :));
    sampled2 = frames2(:, sample(2, :));

    % build A matrix
    % TODO: P determines A and b rows?
    A = [sampled1(1, 1) sampled1(2, 1) 0 0 1 0;...
         0 0 sampled1(1, 1) sampled1(2, 1) 0 1;...
         sampled1(1, 2) sampled1(2, 2) 0 0 1 0;...
         0 0 sampled1(1, 2) sampled1(2, 2) 0 1;...
         sampled1(1, 3) sampled1(2, 3) 0 0 1 0;...
         0 0 sampled1(1, 3) sampled1(2, 3) 0 1];

    % build b vector
    b = [sampled2(1, 1); sampled2(2, 1);...
         sampled2(1, 2); sampled2(2, 2);...
         sampled2(1, 3); sampled2(2, 3)];

    % solve system of equations
    params = pinv(A) * b;


    % transform matched points from im1 using parameters
    [ transformed_x, transformed_y ] = transform_points(matches_x1, matches_y1, params);


    % count inliers
    inliers_count(n) = 0;
    for i = 1:nmatches
        mx1 = transformed_x(1, i);
        my1 = transformed_y(1, i);
        mx2 = matches_x2(i);
        my2 = matches_y2(i);
        dist = norm([mx1 my1] - [mx2 my2]);
        if dist <= radius
            inliers_count(n) = inliers_count(n) + 1;
        end
    end
    fprintf('Found %d inliers over %d matches (%.2f)\n',...
        inliers_count(n), nmatches, inliers_count(n) / nmatches)
    
    % store parameters if there's improvement
    if inliers_count(n) >= inliers_count(max_inliers_iteration)
        best_params = params;
        max_inliers_iteration = n;
        disp('New best!')
    end
end

end