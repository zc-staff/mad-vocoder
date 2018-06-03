function out = base2(x, fs)
    n = length(x);
    t = floor((n - 1) / 2);

    fq = abs(fft(x));
    fq = fq(2:(1+t));

    mx = max(fq);
    peaks = findpeaks2(max(mx / 10, fq));
    idx = peaks(1);

    out = (idx - 1) / n * fs;
    end

    function out = findpeaks2(x)
    n = length(x);
    out = [];
    for i = 2:(n-1)
        if x(i) > x(i-1) && x(i) > x(i+1)
            out(length(out) + 1) = i;
        end
    end
end
