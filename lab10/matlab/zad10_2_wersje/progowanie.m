function bx = progowanie(bx, P)
    bx(abs(bx) < P) = 0;
end
