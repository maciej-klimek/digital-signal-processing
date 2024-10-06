function [symb, prawd] = sortuj( x );
symb = unique( x );
prawd = zeros( size(symb) );
for n=1:length(prawd)
    prawd(n)=sum( x == symb(n) );
end