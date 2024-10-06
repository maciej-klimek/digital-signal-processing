% Generowanie x4

x4 = randi([1 5], 1, 10),

% Sortowanie symboli i obliczanie prawdopodobieństw
[symb, prawd] = sortuj(x4);

% Budowanie drzewa Huffmana
tr = drzewo(symb, prawd);

% Generowanie tablicy kodera
kod = struct('symbol', {}, 'bits', {});
kod = tablicaKodera(kod, tr);

% Kodowanie x4
zakodowany = '';
for i = 1:length(x4)
    symbol = x4(i);
    for j = 1:length(kod)
        if kod(j).symbol == symbol
            zakodowany = [zakodowany, kod(j).bits];
            break;
        end
    end
end

disp(['Zakodowana sekwencja x4: ', zakodowany]);

% Dekodowanie zakodowanej sekwencji
dekodowany = [];
bits = '';
for i = 1:length(zakodowany)
    bits = [bits, zakodowany(i)];
    for j = 1:length(kod)
        if strcmp(kod(j).bits, bits)
            dekodowany = [dekodowany, kod(j).symbol];
            bits = '';
            break;
        end
    end
end

disp(['Dekodowana sekwencja x4: ', num2str(dekodowany)]);