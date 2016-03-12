function [ frames1, frames2, matches ] = get_matches( im1, im2 )
%GET_MATCHES Find SIFT descriptors in both images and return the matches


run('vlfeat-0.9.20/toolbox/vl_setup')


[frames1, desc1] = vl_sift(im1);
[frames2, desc2] = vl_sift(im2);

matches = vl_ubcmatch(desc1, desc2);


end

