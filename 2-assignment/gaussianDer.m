function [ imOut Gd] = gaussianDer (im_path , G, sigma )

kernel_length = size(G);
siz = (kernel_length-1) / 2;
x = -siz:siz;

Gd = - (x.* G) / (sigma^2);

% Load image
im = im2double(imread(im_path));
[size_y, size_x, size_c] = size(im); 
size(im)


% Apply 2D kernel to image
for i=1:size_c;
    imOut(:,:,i) = conv2(im(:,:,i), Gd, 'full');
end
size(imOut)

% Show original image
figure
subplot(1,2,1);
imshow(im, []);
title('Original');
s_str = num2str(sigma);
% Show image filtered with 2D kernel
%subplot(1,2,2);
figure
imshow(imOut, []);
title(['2D filtered _{\sigma=', s_str, '}']);

end