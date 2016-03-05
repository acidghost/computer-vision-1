function [ keypoints_r, keypoints_c ] = rm_keypoints( keypoints, region_size, imsize )
%RM_KEYPOINTS Remove keypoints for which the corrisponding region
%             falls off the image boundaries
half_region = floor(region_size / 2);
j = 1;
keypoints_r = zeros(size(keypoints, 1), 1);
keypoints_c = zeros(size(keypoints, 1), 1);
for i = 1:size(keypoints, 1)
    kpy = keypoints(i, 1);
    kpx = keypoints(i, 2);
    if kpy-half_region > 0 && kpy+half_region < imsize(1)+1 && ...
            kpx-half_region > 0 && kpx+half_region < imsize(2)+1
        keypoints_r(j) = kpy;
        keypoints_c(j) = kpx;
        j = j + 1;
    end
end
keypoints_r = keypoints_r(keypoints_r ~= 0);
keypoints_c = keypoints_c(keypoints_c ~= 0);

end

