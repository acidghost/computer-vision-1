function [ imOut Gd] = gaussianDer (im_path ,G, sigma )

% Load image
im = im2double(imread(im_path));
[size_y, size_x, size_c] = size(im); 

% Apply Gaussian kernel to image
% im_out2 = zeros(size_y, size_x, size_c);
for k=1:size_c;
    for j=0:size_x;
        for i=0:size_y;
            Gd = - (im(i, j, k) * G) / (sigma^2);
            imOut(i, j, k) = Gd;
        end
    end
end

end