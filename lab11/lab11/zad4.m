% Przykłady ciągów
x1 = [ 0, 1, 2, 3, 3, 2, 1, 0 ];
x2 = [0, 7, 0, 2, 0, 2, 0, 7, 4, 2];
x3 = [ 0, 0, 0, 0, 0, 0, 0, 15 ];

% Obliczanie entropii dla przykładowych ciągów
[H1, symbols1, p1] = entropia(x1);
[H2, symbols2, p2] = entropia(x2);
[H3, symbols3, p3] = entropia(x3);

% Wyświetlanie wyników
fprintf('Entropia ciągu x1: %.2f bit/symbol\n', H1);
fprintf('Symbole i ich prawdopodobieństwa dla x1:\n');
disp([symbols1; p1]);

fprintf('Entropia ciągu x2: %.2f bit/symbol\n', H2);
fprintf('Symbole i ich prawdopodobieństwa dla x2:\n');
disp([symbols2; p2]);

fprintf('Entropia ciągu x3: %.2f bit/symbol\n', H3);
fprintf('Symbole i ich prawdopodobieństwa dla x3:\n');
disp([symbols3; p3]);

% Funkcja do obliczania entropii
function [H, symbols, p] = entropia(x)
    symbols = unique(x);  % Unikalne symbole
    N = length(x);
    H = 0;
    p = zeros(1, length(symbols));  % Inicjalizacja wektora prawdopodobieństw
    for i = 1:length(symbols)
        p(i) = sum(x == symbols(i)) / N;  % Prawdopodobieństwo symbolu
        H = H - p(i) * log2(p(i));  % Obliczanie entropii
    end
end
