function syn_track(idx)
    global META;
    global TRACKS;
    global SCORES;

    if ~META{3}(idx, 6)
        sc = META{3}(idx, 2);
        tr = META{3}(idx, 3);
        sr = META{3}(idx, 4);
        if META{3}(idx, 1)
            TRACKS{idx} = make4(SCORES{sc}{tr}, sr);
        else
            TRACKS{idx} = make3(SCORES{sc}{tr}, sr);
        end
        META{3}(idx, 6) = 1;
    end
end
