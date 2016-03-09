function [ affine1, affine2 ] = get_affine( params )
%GET_AFFINE Get the two affine matrices from the list of model params

affine1 = [params(1) params(2);...
           params(3) params(4)];

affine2 = [params(5); params(6)];

end

