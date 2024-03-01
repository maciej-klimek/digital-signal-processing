function d=costFuncSAD(X,Y);
% d=costFuncSAD(X,Y);

d=mean(abs(X(:)-Y(:)));

% KONIEC FUNKCJI;