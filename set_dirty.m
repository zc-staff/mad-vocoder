function set_dirty(trk, src, score)
    global META;

    META{4} = 0;

    [n, ~] = size(META{3});
    for i = 1:n
        if i == trk || META{3}(i, 2) == score || META{3}(i, 4) == src
            META{3}(i, 6) = 0;
        end
    end
end
