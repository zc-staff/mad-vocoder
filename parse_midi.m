function [ out ] = parse_midi(path)
    fid = fopen(path);
    tempo = 0.5;

    [ len, div ] = parse_header(fid);
    out = {};
    for i = 1:len
        magic = fread(fid, 1, 'uint32=>uint32', 'b');
        if magic ~= 1297379947
            error('bad format %d', magic);
        end
        fread(fid, 1, 'uint32');
        stop = 0;
        cur = 0;
        trk = zeros(0, 3);
        prs = zeros(128, 1);
        while ~stop
            delta = double(read_vari(fid));
            cur = cur + delta;
            old_magic = magic;
            magic = fread(fid, 1, 'uint8=>uint8');
            if magic == 255
                ml = fread(fid, 1, 'uint8=>uint8');
                if ml == 88
                    fread(fid, 5, 'uint8');
                elseif ml == 47
                    fread(fid, 1, 'uint8');
                    stop = 1;
                elseif ml == 81
                    fread(fid, 1, 'uint8');
                    x = fread(fid, 1, 'uint8');
                    y = fread(fid, 1, 'uint16', 'b');
                    tempo = (x * 65536 + y) / 1000000;
                elseif ml == 3 || ml == 33 || ml == 1
                    k = read_vari(fid);
                    fread(fid, k, 'uint8');
                elseif ml == 89
                    fread(fid, 1, 'uint8');
                    fread(fid, 2, 'uint8');
                else
                    error('bad format %d', ml);
                end
            elseif magic == 240
                k = read_vari(fid);
                fread(fid, k, 'uint8');
            elseif magic >= 176 && magic < 192
                fread(fid, 2, 'uint8');
            elseif magic >= 192 && magic < 208
                fread(fid, 1, 'uint8') + 1;
            elseif magic >= 224 && magic < 240
                fread(fid, 2, 'uint8');
            elseif magic >= 128 && magic < 160
                k = fread(fid, 1, 'uint8');
                sp = fread(fid, 1, 'uint8');
                if magic >= 144 && sp ~= 0
                    prs(k + 1) = cur;
                else
                    [n, ~] = size(trk);
                    st = prs(k + 1) * tempo / div;
                    le = (cur - prs(k + 1)) * tempo / div;
                    ke = 261.626 * 2 ^ ((k - 60) / 12);
                    trk(n + 1, :) = [ st, le, ke ];
                end
            elseif magic < 128 && old_magic >= 128 && old_magic < 160
                k = double(magic);
                magic = old_magic;
                sp = fread(fid, 1, 'uint8');
                if magic >= 144 && sp ~= 0
                    prs(k + 1) = cur;
                else
                    [n, ~] = size(trk);
                    st = prs(k + 1) * tempo / div;
                    le = (cur - prs(k + 1)) * tempo / div;
                    ke = 261.626 * 2 ^ ((k - 60) / 12);
                    trk(n + 1, :) = [ st, le, ke ];
                end
            elseif magic < 128 && old_magic >= 176 && old_magic < 192
                magic = old_magic;
                fread(fid, 1, 'uint8');
            else
                error('bad format %d, %d', magic, old_magic);
            end
        end
        [n, ~] = size(trk);
        if n > 0
            out{length(out) + 1} = trk;
        end
    end

    fclose(fid);
end

function [ len, div ] = parse_header(fid)
    magic = fread(fid, 1, 'uint32=>uint32', 'b');
    if magic ~= 1297377380
        error('bad format %d', magic);
    end
    fread(fid, 1, 'uint32');
    fread(fid, 1, 'uint16');
    len = fread(fid, 1, 'uint16', 'b');
    div = fread(fid, 1, 'uint16', 'b');
end

function [ out ] = read_vari(fid)
    out = uint32(0);
    x = fread(fid, 1, 'uint8=>uint32');
    while x > 127
        out = out * 128 + x - 128;
        x = fread(fid, 1, 'uint8=>uint32');
    end
    out = out * 128 + x;
end
