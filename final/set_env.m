% This script sets up the environment with VLFeat and LIBSVM
% Note: you have to compile LIBSVM by going into its matlab folder (via
% matlab) and running make.m. Then run this script from the final folder.

% remove ML toolbox from path
rmpath([matlabroot '/toolbox/stats/stats']);

if ~exist('svmtrain', 'file')
    P = path;
    path(P, 'libsvm-3.21/matlab');
end

if ~exist('vl_sift', 'file')
    run('vlfeat-0.9.20/toolbox/vl_setup');
end
