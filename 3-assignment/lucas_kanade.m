impath1 = 'assets/sphere1.ppm';
impath2 = 'assets/sphere2.ppm';
imrgb1 = imread(impath1);
imrgb2 = imread(impath2);
im1 = im2double(rgb2gray(imrgb1));
im2 = im2double(rgb2gray(imrgb2));

regions_size = 15;
half_regions_size = (regions_size-1) / 2;

[nrows, ncols] = size(im1);





for y = 1+half_regions_size:regions_size:nrows-half_regions_size;
    for x = 1+half_regions_size:regions_size:ncols+half_regions_size;
        yrange = y-half_regions_size:y+half_regions_size;
        xrange = x-half_regions_size:x+half_regions_size;
        region1 = im1(yrange, xrange);
        region2 = im2(yrange, xrange);
        
    end
end
