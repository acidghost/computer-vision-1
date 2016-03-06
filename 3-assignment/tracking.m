clear, close all

im_format = 'assets/person_toy/00000%03d.jpg';
video_name = 'person_toy';
nfirst = 1;
nim = 104;
% im_format = 'assets/pingpong/00%02d.jpeg';
% video_name = 'pingpong';
% nfirst = 0;
% nim = 52;

%% Set video 
save_video = true;
frame_pause = .1;

if save_video
    vid = VideoWriter(video_name, 'Motion JPEG AVI');
    vid.FrameRate = 10;
    open(vid)
end

%% Detect features using Harris corner detector
kernel_length = 11;
sigma = 1.5;
window_size = 11;
threshold = 10;
[H, r, c] = harris_corners(sprintf(im_format, nfirst), kernel_length, sigma, window_size, threshold);

%% Set parameters for Lucas Kanade
regions_size = 15;
u = r; v = c;
fig = figure; figure(fig)

%% Track using Lucas Kanade optical flow estimation
% For each pair of consecutive frames, compute displacement vectors
% of keypoints to track using Lucas-Kanade optical flow estimation
im_indexes = nfirst+1:nim;
for i = im_indexes
    impath1 = sprintf(im_format, i - 1);
    impath2 = sprintf(im_format, i);
    im1 = imread(impath1);
    im2 = imread(impath2);

    ksize = size(u, 1);
    % Remove keypoints for which the region falls outside the image boundaries
    [ u, v ] = rm_keypoints([u v], regions_size, size(im1));
    fprintf('Removed %d keypoints (outside viewport)\n', ksize - size(u, 1));

    % Apply LK. Need to round points to pixel location
    [ du, dv ] = lucas_kanade(im1, im2, regions_size, 0, 0, round([u v]));
    
    % Save sample value to plot at the end
    if i == 20
       im1_sample = im1;
       v_sample = v;
       u_sample = u;
       dv_sample = dv;
       du_sample = du;
    end
    
    imagesc(im1), hold on
    plot(v, u, 'bo')
    quiver(v, u, dv, du, 1, 'r'), hold off
    
    if save_video
        frame = getframe(fig);
        fr = frame.cdata;
        writeVideo(vid, fr)
    end
    drawnow, pause(frame_pause)
    
    % Add motion vector components to tracked features
    u = u + du;
    v = v + dv;
end

figure
imagesc(im1_sample), hold on
plot(v_sample, u_sample, 'bo')
quiver(v_sample, u_sample, dv_sample, du_sample, 1, 'r'), hold off

%% Save video
if save_video
    close(vid)
end
