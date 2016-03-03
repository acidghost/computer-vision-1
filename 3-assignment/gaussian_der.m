function [ im_out ] = gaussian_der (im , G, sigma, orientation)

kernel_length = length(G);
siz = (kernel_length-1) / 2;
x = -siz:siz;

% Determine the orientation of the derivative
if strcmp(orientation, 'x')
    Gd = (x.* G) / (sigma^2); 
elseif strcmp(orientation, 'y')
    Gd = (x'.* G) / (sigma^2);
else 
    error('Not a valid orientation!')
end

% Get image channels
[~, ~, size_c] = size(im); 

% Apply 2D kernel to image
im_out = zeros(size(im));
for i=1:size_c;
    im_out(:,:,i) = conv2(im(:,:,i), Gd, 'same');
end

end