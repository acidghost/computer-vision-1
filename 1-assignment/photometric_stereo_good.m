function photometric_stereo( )
%PHOTOMETRIC_STEREO Implement the photometric stereo algorithm, which aims
%to recover a patch of surface from multiple pictures under different light
%sources. 
%Detailed explanation goes here
    % Assumes five different light sources, all far away, with frontal, 
    % left-above, right-above, right-below, and left-below directions.

% STEP 1: Read images and store them all together in a matrix
sp1 = im2double(imread('sphere1.png'));
sp2 = im2double(imread('sphere2.png'));
sp3 = im2double(imread('sphere3.png'));
sp4 = im2double(imread('sphere4.png'));
sp5 = im2double(imread('sphere5.png'));

n_sources = 5;
nrows = size(sp1, 1);
ncols = size(sp1, 2);

sources = zeros(nrows, ncols, n_sources);
sources(:, :, 1) = sp1(:,:);
sources(:, :, 2) = sp2(:,:);
sources(:, :, 3) = sp3(:,:);
sources(:, :, 4) = sp4(:,:);
sources(:, :, 5) = sp5(:,:);

% STEP 2: Represent light sources with vectors assuming a coordinate system
% with origin in the middle.
light_distance = 1;
light_depth = -1; 

% frontal
v1 = [ 0; 0; -light_depth ];
v1 = v1/norm(v1);
% bottom-right
v2 = [ +light_distance; -light_distance; -light_depth ];
v2 = v2/norm(v2);
% bottom-left
v3 = [ -light_distance; -light_distance; -light_depth ];
v3 = v3/norm(v3);
% top-right
v4 = [ +light_distance; +light_distance; -light_depth ];
v4 = v4/norm(v4);
% top-left
v5 = [ -light_distance; +light_distance; -light_depth ];
v5 = v5/norm(v5);

% STEP 3: Determine matrix V from light sources
V = [v1'; v2'; v3'; v4'; v5'];
V = V.* 100;

% STEP 4: Create structures to store albedo and normal per pixel
normals = zeros(nrows, ncols, 3);
albedos = zeros(nrows, ncols);

% Loop through pixels in the array
for x=1:size(sp1, 1);
    for y=1:size(sp1, 2);
        % STEP 5: Retrieve the pixel values for all images and store them as i
        i = reshape(sources(x, y, :), n_sources, 1);
        % STEP 6: Construct diagonal matrix I
        I = zeros(n_sources, n_sources);
        for k=1:n_sources;
            I(k, k) = i(k);
        end
        % STEP 7: Solve for g
        A =  I * V;
        b =  I * i;
        g = pinv(A) * b;
        %opts.SYM = true;
        %g = linsolve(A,b);
        %g = mldivide(A, b);
        % STEP 8: calculate albedo
        albedos(x, y) = norm(g);
        % STEP 9: calculate normals
        if albedos(x, y) == 0;
            normals(x, y, :) = [0 0 0];
        else
            normals(x, y, :) = g / albedos(x, y);
        end
    end
end

disp(['albedo values in range [', num2str(max(max(albedos))), ', ', num2str(min(min(albedos))), ']']);

% show recovered albedo
figure
imshow(albedos, [])
title('Recovered albedo')

% show normal map
figure
Un = normals(:, :, 1);
Vn = normals(:, :, 2);
Wn = normals(:, :, 3);

%  mask = albedos > 0.05;
%  ar = reshape(albedos(mask), [nrows ncols]);
%  ur = reshape(Un(mask), [nrows ncols]);
%  vr = reshape(Vn(mask), [nrows ncols]);
%  wr = reshape(Wn(mask), [nrows ncols]);
%  quiver3(ar, ur, vr, wr, 'AutoScale', 'off', 'AutoScaleFactor', 10)

quiver3(albedos, Un, Vn, Wn, 'AutoScale', 'off', 'AutoScaleFactor', 10)
view(-35,45)
title('Normal map image')


% reconstruct height map
height_map = zeros(nrows, ncols);
for y=2:nrows;
    q = Vn(y, 1) / Wn(y, 1);
    if isnan(q);
        q = 0;
    end
    height_map(y, 1) = height_map(y-1, 1) - q;
end
for y=1:nrows;
    for x=2:ncols;
        p = Un(y, x) / Wn(y, x);
        if isnan(p);
            p = 0;
        end
        height_map(y, x) = height_map(y, x-1) - p;
    end
end

figure
surfl(height_map); shading interp; colormap gray

end