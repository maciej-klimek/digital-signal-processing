close all
clear all

% Jazda kamery w drzewie oskrzelowym po scie�ce
load vol_sc; vol=squeeze(vol_sc); clear vol_sc; size(vol),
%vol_old=vol;

load PTH;
load PTHs;
load('lok_tab_ct'); %zniekszta�cenia geometryczne kamery
LineWidth=3;
is_tr=0.5; %pr�g do izosurfice


SE = strel('ball',1,1);
N=3; SE=ones(N,N,N);
SE
vol = IMDILATE(vol,SE); %pogrubienie drzewa

% figure, hold on
%     I=find(vol_old==1);
%     [xx,yy,zz] = ind2sub(size(vol_old),I);
%     plot3(yy,xx,zz,'b.'), grid on
%
%     I=find(abs(vol-vol_old)>0);
%     [xx,yy,zz] = ind2sub(size(vol_old),I);
%     plot3(yy,xx,zz,'r.'), grid on
%
%     axis([0 size(vol,2) 0 size(vol,1) 0 size(vol,3)])
%     box on
%     camproj p;
%     daspect([1 1 1]);
%     hold on
%     view([-10 -60])
%

%tic, vol = smooth3(vol,'gaussian',3); toc
tic, vol = smooth3(vol,'box',3); toc       %wygladzenie 3-D

%return
FV=isosurface(vol,is_tr);

% figure(1), set(gcf,'Position',[5   299   494   396]);
% % hiso = patch(FV,'FaceColor',[1,.75,.65],'EdgeColor','none');
% % %set(gcf,'Renderer','zbuffer'),
% % lighting phong,
% % alpha(0.5)
% % hlight = camlight('headlight');
% hold on,
% plot3(PTH(:,2),PTH(:,1),PTH(:,3),'r.')
% plot3(PTHs(:,2),PTHs(:,1),PTHs(:,3),'b.')
% %axis tight;
% axis([0 size(vol,2) 0 size(vol,1) 0 size(vol,3)])
% box on
% camproj perspective;
% daspect([1 1 1]);
% VIEW([0, -20])


figure(2),  %set(gcf,'Position',[507   299   513   396]);
set(gcf,'Position',[5   315   369   382]);

hiso = patch(FV,'FaceColor',[1,.75,.65],'EdgeColor','none');
%hiso = patch(FV,'FaceColor',red,'EdgeColor','none');
axis tight; box on
camproj perspective;
daspect([1 1 1]);
lighting phong,
VIEW([0, -83])
hlight = camlight('headlight');
MATERIAL DULL
camva(45);


%F = getframe;
%hold on,
%plot3(PTH(:,2),PTH(:,1),PTH(:,3),'r.')
%plot3(PTHs(:,2),PTHs(:,1),PTHs(:,3),'b.')

%figure(3), set(gcf,'Position',[388    18   355   675]);
% imshow(F.cdata), clear F;

%H = FSPECIAL('average',[3 3]);
H = FSPECIAL('gaussian');

% PNG = double(IMREAD('00000043.png'));
% Normowanie
% PNG = (PNG(:,:,1)+PNG(:,:,2)+PNG(:,:,3))/3;
% PNG = PNG-min(PNG(:));
% PNG = uint8((255*PNG/max(PNG(:))));

ofset=5;
for k=1:1:20%size(PTHs,1)-ofset-1;
    %     figure(1)
    %         plot3(PTHs(:,2),PTHs(:,1),PTHs(:,3),'b*','LineWidth',LineWidth)
    %         plot3(PTHs(k,2), PTHs(k,1), PTHs(k,3),'r*','LineWidth',LineWidth)
    %         plot3(PTHs(k+ofset,2), PTHs(k+ofset,1), PTHs(k+ofset,3),'g*','LineWidth',LineWidth)
    figure(2),
    campos([PTHs(k,2), PTHs(k,1), PTHs(k,3)])
    camtarget([PTHs(k+ofset,2), PTHs(k+ofset,1), PTHs(k+ofset,3)])
    camlight(hlight,'headlight')
    drawnow
    F = getframe; A=double(F.cdata); clear F;
    %         A = IMRESIZE(A,[size(PNG,1),size(PNG,2)], 'bilinear'); %niestey nie panuje nad rozmiarem zrzutki ekranu
    % Normowanie
    %         A = (A(:,:,1)+A(:,:,2)+A(:,:,3))/3;
    %         A = A-min(A(:));
    %         A = uint8((255*A/max(A(:))));
    %     figure(3),
    %     A=cam_dist(A, lok_tab_ct);
    
    
    
    %     B = IMFILTER(A,H); %wyg�adzenie 2-D
    
    %     imshow([B; PNG],[]), set(gcf,'Position',[388    18   355   675]);
end

