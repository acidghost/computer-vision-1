function G = gaussian( sigma, kernel_length )
%GAUSSIAN Implements a 1D Gaussian filter

if mod(kernel_length, 2) == 0
    error('kernel_length should be an odd numeber')
end

siz = (kernel_length-1) / 2;

x = -siz:siz;
G = (1 / (sigma * (2*pi)) * exp(-(x.*x) / (2 * sigma^2)));

% sumg = sum(G(:));
% if sumg ~= 0
%     G = G / sumg;
% end

end

