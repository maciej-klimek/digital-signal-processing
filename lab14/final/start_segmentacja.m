close all
clear all

tic
% Segmentacja danych CT obszary w p�ucach wype�nione powietrzem

load vol; vol=squeeze(vol); size(vol), %figure, hist(double(vol(:)),100)

rv=2; [x y z vol] = reducevolume(vol, [rv rv rv]); size(vol)

% Wyg�adzanie
vol = SMOOTH3(vol,'gaussian',3);

% Zamiana na binarny
I   = find(vol<200);
vol = zeros(size(vol)); vol(I)=1;

% Segmentacja
%6,18,26
[vol_obj,liczba_obj] = bwlabeln(vol,26); liczba_obj, %figure, hist(vol_obj(:),liczba_obj)
% Wyb�r drzewa oskrzelowego na podstawie pierwszego slajdu
% Wymagana INTERAKCJA u�ytkownika do wybrania wlasciwego obiektu

imview(vol_obj(:,:,1))
clear vol;
toc
return

I=find(round(vol_obj)==2); % uwaga ta warto�� podan przez u�ytkownika
vol = zeros(size(vol_obj)); vol(I)=1;
clear vol_obj; beep
%%%%%%%%%%%%%%%%%% Przegladanie danych CT %%%%%%%%%%%%%%
KK=size(vol,3);
for k=1:KK,
    A=vol(:,:,k);
    imshow(A,[])
end
KK=size(vol,1)
for k=1:KK, k
    A=squeeze(vol(k,:,:));
    imshow((A'),[]'),
end

close all
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic
figure
hiso = patch(isosurface(abs(vol-1),0),'FaceColor',[1,.75,.65],'EdgeColor','none');
%hiso =patch(isosurface(vol,1),'FaceColor',[1,.75,.65],'EdgeColor','none');
axis tight; box on
camproj p;
daspect([1 1 1]);
lighting phong, axis off
VIEW([0, -45])
CAMLIGHT;
%alpha(0.5)
toc
%vol_s=vol; save('vol_s','vol_s'), beep

return
tic
figure
hiso = patch(isosurface(vol_obj,1),'FaceColor',[1,.75,.65],'EdgeColor','none');
%hiso =patch(isosurface(vol,1),'FaceColor',[1,.75,.65],'EdgeColor','none');
axis tight; box on
camproj p;
daspect([1 1 1]);
lighting phong, axis off
VIEW([0, -45])
CAMLIGHT;
%alpha(0.5)
toc

return

I=find(round(vol_obj)==2);
for k=3:max(vol_obj(:))
    k
    figure,hold on
    vol_rys=zeros(size(vol_obj));   vol_rys(I)=1;
    [x,y,z]=rysuj_bryle(vol_rys);
    plot3(x,y,z,'b.'), grid on
    VIEW([-60, 10])
    
    I1=find(round(vol_obj)==k);
    vol_rys=zeros(size(vol_obj));   vol_rys(I1)=1;
    [x,y,z]=rysuj_bryle(vol_rys);
    plot3(x,y,z,'r.'), grid on
    VIEW([-60, 10])
    camproj p;
    daspect([1 1 1]);
    
    pause
    close all
end









