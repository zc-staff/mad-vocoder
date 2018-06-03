function out = get_key(name, fq, k)
    global OFS;
    global FREQS;
    fq0 = FREQS{name};
    k = ceil(OFS * k * fq / fq0);
    out = get_source(name, k);
    out = resample2(out, fq0, fq);
    out = filter4(out, OFS, fq);
end

function out = filter4 (x, fs, fq)
    n = length(x);
    t = ceil((n + 1) / 2);

    f0 = fft(x);
    f1 = zeros(n, 1);

    idx = fq / fs * n;
    tt = 1:(t-1);
    tt = tt - round(tt / idx) * idx;
    tt = max(0.0, 1.0 - (tt / idx * 4) .^ 2);

    f1(2:t) = f0(2:t) .* tt(:);
    f1((t+1):n) = conj(f1((n+1-t):(-1):2));

    out = real(ifft(f1));
end

function out = get_source(name, k)
    global KEYS;
    i = 1;
    out = KEYS{name}{i};
    while length(out) < k
        i = i + 1;
        if length(KEYS{name}) < i
            KEYS{name}{i} = repeat2(out, 2);
        end
        out = KEYS{name}{i};
    end
    out = out(1:k);
end
