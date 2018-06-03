function out = resample2 (x, ofs, fs)
    n = length(x);
    t = floor((n - 1) / 2);
    t1 = ceil(t / fs * ofs);
    fq = fft(x);
    fq1 = zeros(2 * t1 + 1, 1);
    fq1(1) = fq(1) / fs * ofs;

    tt = min(t, t1);
    fq1(2:(1 + tt)) = fq(2:(1 + tt)) / fs * ofs;
    fq1((2 * t1 + 1):(-1):(t1 + 2)) = conj(fq1(2:(t1 + 1)));

    out = real(ifft(fq1));
end
