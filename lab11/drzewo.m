function tr = drzewo( symb, prawd )
for n=1:length(prawd);
    node.pr=prawd(n);
    node.left=[];
    node.right=[];
    node.symbol=symb(n);
    tr(n)=node;
end
while( length(tr) > 1 )
    pr = cat( 0, tr.pr );
    [ dummy, idx ] = sort( pr, 'ascend' );
    tr = tr(idx);                   % sortuj według prawdopodobieństwa
    trNew.pr=tr(1).pr+tr(2).pr;     % suma prawdopodobieństw
    trNew.left=tr(1);
    trNew.right=tr(2);
    trNew.symbol=[];                % symbol pusty (suma symboli)
    tr = [tr, trNew];               % dodaj nowy złożony symbol na końcu
    tr(1:2) = [];                   % skasuj dwa pierwsze symbole
end