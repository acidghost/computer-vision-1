function [ best_params, inliers_count ] = ransac( N, P, radius, frames1, frames2, matches, im1, im2 )
%RANSAC Perform RANSAC

[im1sizey, im1sizex] = size(im1);
[im2sizey, im2sizex] = size(im2);

nmatches = size(matches, 2);
matches_x1 = frames1(1, matches(1, :));
matches_y1 = frames1(2, matches(1, :));
matches_x2 = frames2(1, matches(2, :));
matches_y2 = frames2(2, matches(2, :));


max_inliers_iteration = 1;
inliers_count = zeros(N, 1);

%% Find best
figure    % open figure to show matches
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


    %% Sample and plot
    % sample 50 matches
    [ sampled_tx, sampled_idx ] = get_sample(nmatches, 50, transformed_x);
    sampled_ty = transformed_y(1, sampled_idx);
    sampled_x = matches_x1(1, sampled_idx);
    sampled_y = matches_y1(1, sampled_idx);


    % find transformation boundaries
    [ xsize, ysize ] = find_transformation_bound([im1sizey, im1sizex], params);

    
    space = 20;   % add some space between images
    halfimxsize = max([im2sizex xsize]);
    imfullx = im1sizex + halfimxsize + space;
    imfully = max([im1sizey im2sizey ysize]);
    halfimy = round((imfully - im1sizey) / 2);

    % create final image containing both images and
    % sampled matches connected by lines
    imfull = zeros(imfully, imfullx);
    imfull(1+halfimy:im1sizey+halfimy, 1:im1sizex) = im1;
    imstart = im1sizex + space;
    imfull(1+halfimy:im2sizey+halfimy, imstart:imstart+im2sizex-1) = im2;

    % translate sampled points
    full_sampled_tx = sampled_tx + space + im1sizex;
    full_sampled_ty = sampled_ty + halfimy;
    full_sampled_y = sampled_y + halfimy;

    imagesc(imfull), colormap gray, hold on
    plot(sampled_x, full_sampled_y, 'ro')
    plot(full_sampled_tx, full_sampled_ty, 'ro')
    line([sampled_x; full_sampled_tx], [full_sampled_y; full_sampled_ty])
    title(sprintf('%d inliers over %d matches (%.2f)',...
        inliers_count(n), nmatches, inliers_count(n) / nmatches))
    hold off; drawnow, pause(.1)

    fprintf('\n')
end


end

