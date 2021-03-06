function [ out ] = make3(data, src)
    global OFS;

    ed = max(data(:, 1) + data(:, 2));
    k = ceil(ed * OFS);
    out = zeros(k, 1);
    [n, ~] = size(data);

    for i = 1:n
        now = get_key(src, data(i, 3), data(i, 2));
        st = 1 + round(data(i, 1) * OFS);
        ed = min(st + length(now) - 1, k);
        out(st:ed) = out(st:ed) + now(1:(ed-st+1));
    end
end
