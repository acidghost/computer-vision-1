function [ xsize, ysize, min_x, min_y ] = find_transformation_bound( imsize, params, invert )
%FIND_TRANSFORMATION_BOUND Find the transformed image boundaries

% define original image boundaries
tl = [ 1 1 ];
bl = [ imsize(1) 1 ];
br = [ imsize(1) imsize(2) ];
tr = [ 1 imsize(2) ];

if ~exist('invert', 'var')
    invert = 0;
end

% transform the four corners
t_tl = transform_point(tl(1), tl(2), params, invert);
t_bl = transform_point(bl(1), bl(2), params, invert);
t_br = transform_point(br(1), br(2), params, invert);
t_tr = transform_point(tr(1), tr(2), params, invert);

% find maxs and mins
max_y = max([ t_tl(1) t_bl(1) t_br(1) t_tr(1) ]);
min_y = min([ t_tl(1) t_bl(1) t_br(1) t_tr(1) ]);
max_x = max([ t_tl(2) t_bl(2) t_br(2) t_tr(2) ]);
min_x = min([ t_tl(2) t_bl(2) t_br(2) t_tr(2) ]);

% find transformed image size
xsize = ceil(max_x - min_x);
ysize = ceil(max_y - min_y);

end

