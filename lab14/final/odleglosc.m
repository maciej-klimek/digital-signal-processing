function D=odleglosc(A,B);

A=A(:);
B=B(:);
D = sqrt(sum((A-B).^2));