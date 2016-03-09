clear, close all


run('vlfeat-0.9.20/toolbox/vl_setup')

impath1 = 'assets/boat/img1.pgm';
impath2 = 'assets/boat/img2.pgm';
im1 = im2single(imread(impath1));
im2 = im2single(imread(impath2));

[imsizey, imsizex] = size(im1);


[frames1, desc1] = vl_sift(im1);
[frames2, desc2] = vl_sift(im2);

matches = vl_ubcmatch(desc1, desc2);

N = 200;
nmatches = size(matches, 2);
P = 3;
max_inliers_iteration = 1;
best_params = zeros(6, 1);
radius = 10;
matches_x1 = frames1(1, matches(1, :));
matches_y1 = frames1(2, matches(1, :));
inliers_count = zeros(N, 1);

figure    % open figure to show matches
for n = 1:N
    fprintf('Iteration %d\n', n)


    % sample P matches (pairs of points)
    sample = get_sample(nmatches, P, matches);
    sampled1 = frames1(:, sample(1, :));
    sampled2 = frames2(:, sample(2, :));

    % build A matrix
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
    matches_x2 = frames2(1, matches(2, :));
    matches_y2 = frames2(2, matches(2, :));
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


    % sample 50 matches and plot them with lines
    [ sampled_tx, sampled_idx ] = get_sample(nmatches, 50, transformed_x);
    sampled_ty = transformed_y(1, sampled_idx);
    sampled_x = matches_x1(1, sampled_idx);
    sampled_y = matches_y1(1, sampled_idx);


    % find transformation boundaries
    [ xsize, ysize ] = find_transformation_bound(size(im1), params);

    
    space = 20;   % add some space between images
    halfimxsize = max(imsizex, xsize);
    imfullx = imsizex + halfimxsize + space;
    imfully = max([imsizey ysize]);
    halfimy = round((imfully - imsizey) / 2);

    % create final image containing both images and
    % sampled matches connected by lines
    imfull = zeros(imfully, imfullx);
    imfull(1+halfimy:imsizey+halfimy, 1:imsizex) = im1;
    imstart = imsizex + space;
    imfull(1+halfimy:imsizey+halfimy, imstart:imstart+imsizex-1) = im2;

    % translate sampled points
    full_sampled_tx = sampled_tx + 20 + imsizex;
    full_sampled_ty = sampled_ty + halfimy;
    full_sampled_y = sampled_y + halfimy;

    imagesc(imfull), colormap gray, hold on
    plot(sampled_x, full_sampled_y, 'ro')
    plot(full_sampled_tx, full_sampled_ty, 'ro')
    line([sampled_x; full_sampled_tx], [full_sampled_y; full_sampled_ty])
    title(sprintf('%d inliers over %d matches (%.2f)',...
        inliers_count(n), nmatches, inliers_count(n) / nmatches))
    hold off; drawnow, pause(1)

    fprintf('\n')
end


% transform im1 using found parameters

