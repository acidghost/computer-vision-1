% Main assignment 2.2 script

im_path = 'imgs/zebra.png';

kernel_length = 11;
sigmas = [.3 .4 .5:.5:3];
figure
Gds = zeros(length(sigmas), kernel_length);
for i=1:length(sigmas);
    sigma = sigmas(i);
    % Get gaussian 1D kernel
    G = gaussian(sigma, kernel_length);
    % Get derivative of kernel and filter image
    [imout, Gd] = gaussianDer(im_path, G, sigma);
    Gds(i, :) = Gd;
    
    s_str = num2str(sigma);
    % Show filtered image
    subplot(2, 4, i);
    imshow(imout, []);
    title(['Filtered _{\sigma=', s_str, '}']);
end

figure
for i=1:length(sigmas);
    sigma = sigmas(i);
    s_str = num2str(sigma);
    % Plot kernel derivative
    subplot(2, 4, i);
    sx = (5 * sigma);
    y = Gds(i,:);
    x = -sx:(sx/5):sx;
    plot(x, y);
    title(['Kernel derivative _{\sigma=', s_str, '}']);
end
