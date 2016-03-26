function [ sample_idx ] = get_sample_excl( n, nmax, excl )
%GET_SAMPLE_EXCL Samples 'n' ints from 1 to 'nmax' excluding items in 'excl'

sample_idx = zeros(n, 1);
i = 1;
while i < n+1
    r = ceil(rand() * nmax);
    if ~any(excl == r)
        sample_idx(i) = r;
        i = i + 1;
    end
end

end

