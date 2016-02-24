function [ imOut, Gd ] = gaussianDer (im_path , G, sigma )

kernel_length = length(G);
siz = (kernel_length-1) / 2;
x = -siz:siz;

Gd = - (x.* G) / (sigma^2);

% Load image
im = im2double(imread(im_path));
[~, ~, size_c] = size(im); 


% Apply 2D kernel to image
imOut = zeros(size(im));
for i=1:size_c;
    imOut(:,:,i) = conv2(im(:,:,i), Gd, 'same');
end

end