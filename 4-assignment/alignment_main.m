clear, close all


run('vlfeat-0.9.20/toolbox/vl_setup')

impath1 = 'assets/boat/img1.pgm';
impath2 = 'assets/boat/img2.pgm';
im1 = im2single(imread(impath1));
im2 = im2single(imread(impath2));

[frames1, desc1] = vl_sift(im1);
[frames2, desc2] = vl_sift(im2);

matches = vl_ubcmatch(desc1, desc2);

N = 200;
nmatches = size(matches, 2);
P = 3;
max_inliers_iteration = 1;
best_params = zeros(6, 1);
radius = 10;
figure
subplot 121, imagesc(im1), colormap gray, hold on
matches_x1 = frames1(1, matches(1, :));
matches_y1 = frames1(2, matches(1, :));
plot(matches_x1, matches_y1, 'ro'), hold off
inliers_count = zeros(N, 1);
for n = 1:N
    fprintf('Iteration %d\n', n)

    rndIDX = randperm(nmatches);
    sample = matches(:, rndIDX(1:P));
    sampled1 = frames1(:, sample(1, :));
    sampled2 = frames2(:, sample(2, :));

    A = [sampled1(1, 1) sampled1(2, 1) 0 0 1 0;...
         0 0 sampled1(1, 1) sampled1(2, 1) 0 1;...
         sampled1(1, 2) sampled1(2, 2) 0 0 1 0;...
         0 0 sampled1(1, 2) sampled1(2, 2) 0 1;...
         sampled1(1, 3) sampled1(2, 3) 0 0 1 0;...
         0 0 sampled1(1, 3) sampled1(2, 3) 0 1];

    b = [sampled2(1, 1); sampled2(2, 1);...
         sampled2(1, 2); sampled2(2, 2);...
         sampled2(1, 3); sampled2(2, 3)];

    x = pinv(A) * b;

    % transform matched points from im1 using parameters
    [ transformed_x, transformed_y ] = transform_points(matches_x1, matches_y1, x);


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
    fprintf('Found %d inliers\n', inliers_count(n))
    
    % store parameters if there's improvement
    if inliers_count(n) >= inliers_count(max_inliers_iteration)
        best_params = x;
        max_inliers_iteration = n;
        disp('New best!')
    end


    % remove transformed points outside image
    k = 1;
    transformed_inside_x = zeros(1, nmatches);
    transformed_inside_y = zeros(1, nmatches);
    for i = 1:nmatches
        px = transformed_x(1, i);
        py = transformed_y(1, i);
        if px > 0 && px < size(im1, 2) && py > 0 && py < size(im1, 1)
            transformed_inside_x(1, k) = px;
            transformed_inside_y(1, k) = py;
            k = k + 1;
        end
    end
    transformed_inside_x = transformed_inside_x(transformed_inside_x ~= 0);
    transformed_inside_y = transformed_inside_y(transformed_inside_y ~= 0);
        
    subplot 122, imagesc(im2), colormap gray, hold on
    plot(transformed_inside_x, transformed_inside_y, 'ro'), hold off
    drawnow, pause(.05)
    
    fprintf('\n')
end


% transform im1 using found parameters

