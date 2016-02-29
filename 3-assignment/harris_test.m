im_path = 'assets/pingpong/0000.jpeg';
im_rgb = imread(im_path);
im_gray = rgb2gray(im_rgb);
im = im2double(im_gray);

figure, imshow(im), title('Original image');


% Define gaussians
kernel_length = 11;
siz = (kernel_length-1) / 2;
kernel_size = -siz:siz;
[Xk, Yk] = meshgrid(kernel_size);
sigma = 1;
kernel_x = fspecial('gaussian', kernel_length, sigma);
kernel_xd = (Xk .* kernel_x) / (sigma^2);
kernel_y = kernel_x';
kernel_yd = (Yk .* kernel_y) / (sigma^2);


% Convolve image with guassian derivative
Ix = conv2(im, kernel_xd, 'same');
figure, imagesc(Ix), colormap gray, title('I_x');
Iy = conv2(im, kernel_yd, 'same');
figure, imagesc(Iy), colormap gray, title('I_y');


g = fspecial('gaussian',max(1,fix(6*sigma)), sigma); %%%%%% Gaussien Filter


Ix2 = conv2(Ix.^2, g, 'same');  
Iy2 = conv2(Iy.^2, g, 'same');
Ixy = conv2(Ix.*Iy, g,'same');


A = Ix2; B = Ixy; C = Iy2;
H = (A.*C - B.^2) - 0.04 * ((A + C).^2);

nrows = size(H, 1);
ncols = size(H, 2);
n = 10;
im_o = zeros(nrows, ncols);
for x=1:nrows;
    for y=1:ncols;
        % FIXME the window goes over the image boundaries
        window = H((x-n):(x+n), (x-n):(x+n));
        if sum(sum(window)) > .1
            im_o(x, y) = R;
        end
    end
end
figure, imshow(im_o);
