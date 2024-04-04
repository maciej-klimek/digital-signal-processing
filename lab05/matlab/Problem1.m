p12 = -0.5 + 9.5j;
p34 = -1 + 10j;
p56 = -0.5 + 10.5j;
z12 = 5j;
z34 = 15j;
p = [p12,p34,p56];
p = [p conj(p)];
z = [z12,z34];
z = [z  conj(z)];
wzm=0.42;
hold on;
plot(real(p),imag(p),"o");
plot(real(z),imag(z),"x");
grid on
axis equal
xlabel("Re(z)");
ylabel("Im(z)");

a = poly(p);
b = poly(z)*wzm;

w =  4:0.1:16;
s = w*j;
Hlinear = abs(polyval(b,s) ./ polyval(a,s));

figure;
plot(w,Hlinear);
xlabel("Częstotliwość [rad/s]")
ylabel("|H(jw)|");
figure;
Hlog = 20*log10(Hlinear);
wlog = logspace(0,1000,40);
plot(w,Hlog,'r');
xlabel("Częstotliwość [rad/s]")
ylabel("20log10(|H(jw)|)")

% Charakterystyka fazowa-częstotliwościowa
figure;
H_phase = angle(polyval(b,s) ./ polyval(a,s));
plot(w, H_phase, 'g');
xlabel('Częstotliwość [rad/s]');
ylabel('Kąt [rad]');
title('Charakterystyka fazowo-częstotliwościowa');
grid on;
figure;
freqs(b,a,w);