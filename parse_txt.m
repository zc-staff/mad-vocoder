function [ out ] = parse_txt(path, bmp)
    bmp = 60 / bmp;
    strs = textread(path, '%s');
    n = length(strs);

    keys = 'C D EF G A B';
    out = zeros(0, 3);
    tot = 0;

    for i = 1:n
        str = strs{i};
        cur = 1;
        a = str2double(str(cur));
        cur = cur + 1;
        ch = str(cur);
        if ch == 'A' || ch == 'a'
            a = a / 16;
        elseif ch == 'B' || ch == 'b'
            a = a / 32;
        else
            a = a / str2double(ch);
        end
        a = a * bmp;
        cur = cur + 1;
        ch = str(cur);
        if ch ~= '-'
            b = (strfind(keys, ch) - 1) / 12;
            cur = cur + 1;
            ch = str(cur);
            if ch == 'b'
                b = b - 1 / 12;
                cur = cur + 1;
            elseif ch == '#'
                b = b + 1 / 12;
                cur = cur + 1;
            end
            b = b + str2double(str(cur)) - 4;
            b = 2 ^ b * 261.626;

            [kk, ~] = size(out);
            out(kk + 1, 1) = tot;
            out(kk + 1, 2) = a;
            out(kk + 1, 3) = b;
        end
        tot = tot + a;
    end
    out = {out};
end
