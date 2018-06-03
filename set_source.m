function set_source(name, path)
global OFS;
global KEYS;
global FREQS;
global META;

[ X, FS ] = audioread(path);
X = resample2(X(:, 1), OFS, FS);
KEYS{name} = {X};
FREQS{name} = base2(X, OFS);
META{1}{name} = path;
end

