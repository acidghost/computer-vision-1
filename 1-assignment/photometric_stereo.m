function photometric_stereo( )
%PHOTOMETRIC_STEREO Summary of this function goes here
%   Detailed explanation goes here

sp1 = imread('sphere1.png');
sp2 = imread('sphere2.png');
sp3 = imread('sphere3.png');
sp4 = imread('sphere4.png');
sp5 = imread('sphere5.png');
n_sources = 5;
sources = zeros(size(sp1, 1), size(sp1, 2), n_sources);
sources(:, :, 1) = sp1(:,:);
sources(:, :, 2) = sp2(:,:);
sources(:, :, 3) = sp3(:,:);
sources(:, :, 4) = sp4(:,:);
sources(:, :, 5) = sp5(:,:);

light_distance = 10000;
to_center = 120;
v1 = [size(sp1) / 2, light_distance]';
v2 = [size(sp2) - to_center, light_distance]';
v3 = [size(sp3, 1) - to_center, to_center, light_distance]';
v4 = [to_center, size(sp4, 2) - to_center, light_distance]';
v5 = [to_center, to_center, light_distance]';

V = [v1'; v2'; v3'; v4'; v5'];

normals = zeros(size(sp1, 1), size(sp1, 2), 3);
albedos = zeros(size(sp1, 1), size(sp2, 2));
for x=1:size(sp1, 1);
    for y=1:size(sp1, 2);
        % stack image values into array i
        i = zeros(n_sources, 1);
        for k=1:n_sources;
            i(k) = sources(x, y, k);
        end
        % construct diagonal matrix I
        I = zeros(n_sources, n_sources);
        for k=1:n_sources;
            I(k, k) = i(k);
        end
        % solve for g
        g = pinv(I * V) * (I * i);
        albedo = norm(g);
        albedos(x, y) = albedo;
        normal = g ./ albedo;
        normals(x, y, :) = normal;
    end
end

figure
[X, Y] = meshgrid(1:size(sp1, 1), 1:size(sp1, 2));
quiver3(X, Y, albedos, normals(:, :, 1), normals(:, :, 2), normals(:, :, 3));

max(max(albedos))
min(min(albedos))

end

