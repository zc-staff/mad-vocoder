function [ out ] = make4(data, src)
    global OFS;
    global KEYS;

    t = length(KEYS{src}{1});
    ed = max(data(:, 1));
    k = ceil(ed * OFS) + t;
    out = zeros(k, 1);
    [n, ~] = size(data);

    for i = 1:n
        now = KEYS{src}{1};
        st = 1 + round(data(i, 1) * OFS);
        ed = min(st + length(now) - 1, k);
        out(st:ed) = out(st:ed) + now(1:(ed-st+1));
    end
end
