function kod=tablicaKodera( kod, tr )
if( 0==isempty( tr.symbol ) )
    kod(length(kod)+1).symbol = tr.symbol;
    kod(end).bits = [];
    return;
end
kodleft = tablicaKodera( kod, tr.left );
kodright = tablicaKodera( kod, tr.right );
for n=1:length(kodleft)
    kodleft(n).bits = ['1', kodleft(n).bits];
end
for n=1:length(kodright)
    kodright(n).bits = ['0', kodright(n).bits];
end
kod = [kod, kodleft, kodright];