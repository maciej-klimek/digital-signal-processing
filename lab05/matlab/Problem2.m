
N_values = [2, 4, 6, 8];
omega_3dB = 2*pi*100; 
w = 0:0.1:2000;
ang = zeros(4,length(w));
Hdec= zeros(4,length(w));
Hlin = zeros(4,length(w));

i=1;
for N = N_values
    poles = omega_3dB*exp(1i*(pi/2 + 1/2 * pi/N + ((1:N)-1)*pi/N));
    wzm = prod(-poles);
    a = poly(poles);
    b = wzm;
    h = freqs(b,a,w);
    
    ang(i,:) = angle(h);
    Hdec(i,:)= 20*log10(abs(h));
    Hlin(i,:) = abs(h);

    i=i+1;
    
end
figure;
hold on;
grid on;
wlog = logspace(0,2,20001)
for row=1:4
semilogx(w./(2*pi),Hdec(row,:));
end
legend("2","4","6","8");
title("Charakterystyka A-cz skala logarytmiczna")

figure;
hold on;
for row=1:4
plot(w./(2*pi),Hlin(row,:));
end
legend("2","4","6","8");
title("Charakterystyka A-cz skala liniowa")

figure;
hold on;
for row=1:4
plot(w./(2*pi),ang(row,:));
end
legend("2","4","6","8");
title("Charakterystyka cz-f");

figure;
poles4 = omega_3dB*exp(1i*(pi/2 + 1/2 * pi/4 + ((1:4)-1)*pi/4));
a = poly(poles4);
b = wzm;
H = tf(b,a);
[y,tOut] =impulse(H);
plot(tOut,y );
title("Odpowiedź impulsowa")
figure;
[y,tOut] = step(H);
plot(tOut,y)
title("Odpowiedź na skok jednostkowy");



