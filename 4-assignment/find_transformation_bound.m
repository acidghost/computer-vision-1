function [ xsize, ysize ] = find_transformation_bound( imsize, params )
%FIND_TRANSFORMATION_BOUND Find the transformed image boundaries

tl = [1 1];
bl = [imsize(2) 1];
br = [imsize(2) imsize(1)];
tr = [1 imsize(1)];


[affine1, affine2] = get_affine(params);

t_tl = transform_point(tl(2), tl(1), affine1, affine2);
t_bl = transform_point(bl(2), bl(1), affine1, affine2);
t_br = transform_point(br(2), br(1), affine1, affine2);
t_tr = transform_point(tr(2), tr(1), affine1, affine2);

max_x = max([ t_tl(1) t_bl(1) t_br(1) t_tr(1) ]);
min_x = min([ t_tl(1) t_bl(1) t_br(1) t_tr(1) ]);
max_y = max([ t_tl(2) t_bl(2) t_br(2) t_tr(2) ]);
min_y = min([ t_tl(2) t_bl(2) t_br(2) t_tr(2) ]);

xsize = ceil(max_x - min_x);
ysize = ceil(max_y - min_y);

end

