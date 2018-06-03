function syn_out()
    global META;
    global OUTPUT;
    global TRACKS;

    if ~META{4}
        [n, ~] = size(META{3});
        for i = 1:n
            syn_track(i);
        end

        OUTPUT = mix2(TRACKS, META{3}(:, 5));
        META{4} = 1;
    end
end
