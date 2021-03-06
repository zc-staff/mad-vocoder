function parse_meta(path, out)
    global SCORES;
    global META;

    fid = fopen(path);

    line = fgetl(fid);
    ofs = strread(line, '%f');
    init_db(double(ofs));

    line = fgetl(fid);
    srcs = strread(line, '%s');
    n_srcs = length(srcs);
    for i = 1:n_srcs
        if ends(srcs{i}, '.txt')
            SCORES{i} = parse_txt(srcs{i});
            META{2}{i} = srcs{i};
        else
            SCORES{i} = parse_midi(srcs{i});
            META{2}{i} = srcs{i};
        end
    end

    line = fgetl(fid);
    libs = strread(line, '%s');
    n_libs = length(libs);
    for i = 1:n_libs
        set_source(i, libs{i});
    end

    k = 0;
    while ~feof(fid)
        line = fgetl(fid);
        k = k + 1;
        META{3}(k, 1:5) = strread(line, '%f');
    end

    fclose(fid);
end

function tf = ends(src, pat)
    n = length(pat);
    m = length(src);
    if m < n
        tf = 0;
    else
        tf = strcmp(src((m-n+1):m), pat);
    end
end
