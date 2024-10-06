% rng(0);
% x4 = randi([1 5], 1, 10),
% wygenerowano  3     5     1     2     1     1     5     3     3     1
x4 = [ 3,     5,     1,     2,     1,     1,     5,     3,     3,     1]
%  Łącznie: 10, Unikalnych: 4
%  Symbol:          Prawdopodobieństwo:      Kod:
%   5                       0.2              110
%   4                       0                 -
%   3                       0.3               10
%   2                       0.1              111
%   1                       0.4               0
%
%         1
%   0.1 -----          1
%            |- 0.3 ------       1
%   0.2 -----            |- 0.6 --  1
%         0              |       |
%   0.3 ------------------       |
%                      0         |
%                                |
%   0.4 -------------------------|
%                                0

entropia(x4),

code(x4),


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

function bit_sequence = code(symbols)
    bit_sequence = strings(size(symbols));
    for i = 1:numel(symbols)
        switch symbols(i)
            case 1
                bit_sequence(i) = "0";
            case 2
                bit_sequence(i) = "111";
            case 3
                bit_sequence(i) = "10";
            case 5
                bit_sequence(i) = "110"; 
            otherwise
                continue
        end
    end
end