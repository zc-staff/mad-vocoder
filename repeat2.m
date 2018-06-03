function out = repeat2(x, ratio)
    step = 32;
    win_ratio = 32;
    step_ratio = ratio;

    win_len = ceil(step * win_ratio);
    step2 = ceil(step * step_ratio);
    n = length(x);
    seg = max(0, ceil((n - win_len) / step));
    x = [x; zeros(win_len + seg * step - n, 1)];

    m = win_len + seg * step2;
    out = zeros(m, 1);
    amp = zeros(m, 1);
    win = hamming(win_len);
    win2 = win .^ 2;

    now = win .* x(1:win_len);
    out(1:win_len) = win .* now;
    amp(1:win_len) = amp(1:win_len) + win2;
    unwrap = 2 * pi * step * (0:win_len-1)' / win_len;
    phase = angle(fft(now));
    phase1 = phase;

    for i = 1:seg
        st = 1 + i * step;
        ed = st + win_len - 1;
        now = win .* x(st:ed);

        f = fft(now);
        fq = abs(f);
        phase0 = phase;
        phase = angle(f);

        delta = (phase - phase0) - unwrap;
        delta = delta - round(delta / (2 * pi)) * (2 * pi);
        delta = (delta + unwrap) * step_ratio;

        phase1 = phase1 + delta;
        fq = fq .* exp(1i * phase1);
        syns = win .* real(ifft(fq));

        st1 = 1 + i * step2;
        ed1 = st1 + win_len - 1;
        out(st1:ed1) = out(st1:ed1) + syns;
        amp(st1:ed1) = amp(st1:ed1) + win2;
    end

    out = out ./ amp;
end
