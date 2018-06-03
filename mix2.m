function [ out ] = mix2(src, w)
    n = length(src);
    len = 0;
    for i = 1:n
        len = max(len, length(src{i}));
    end
    out = zeros(len, 1);
    for i = 1:n
        t = length(src{i});
        out(1:t) = out(1:t) + w(i) .* src{i};
    end
end
