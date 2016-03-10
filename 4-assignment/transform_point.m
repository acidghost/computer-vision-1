function p = transform_point(px, py, params, invert)
%TRANSFORM_POINT Transform the point [px; py] using affine transformation
%                defined by 'params'. If the 'invert' argument is defined
%                and true then the inverse transformation is applied.

if exist('invert', 'var') && invert
    A1 = [ params(1) params(2) ;...
           params(3) params(4) ];
    A2 = [ params(5); params(6) ];

    pin = [ px; py ];

    % equal to p = inv(A1) * (pin - A2)
    p = A1 \ (pin - A2);
else
    A = [ px py 0 0 1 0 ;...
          0 0 px py 0 1 ];

     p = A * params;
end

end

