function init_db(FS)
    global OFS;
    global KEYS;
    global FREQS;
    global SCORES;
    global TRACKS;
    global META;
    global OUTPUT;
    OFS = FS;
    KEYS = {};
    FREQS = {};
    SCORES = {};
    TRACKS = {};
    META = {{}, {}, zeros(0, 6), 0};
    OUTPUT = [];
end
