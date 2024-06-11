close all
clear all

load vol_sc; vol=squeeze(vol_sc); clear vol_sc; size(vol),

%Df = bwdist(abs(vol-1));
load('Df')

D = floor(Df);
D_max=max(D(:));

% cm=colormap(jet(D_max));
% for k=D_max:-1:1;
%     I=find(D==k); %uwaga zaokraglenie
%     [xx,yy,zz] = ind2sub(size(D),I);
%     plot3(yy,xx,zz,'.','Color',cm(k,:)), grid on   %uwaga zamiana xx z yy
%     axis([0 size(D,2) 0 size(D,1) 0 size(D,3)])
%     % axis tight;
%     box on
%     camproj p;
%     daspect([1 1 1]);
%     hold on
%     view([-10 -60])
%     pause
% end

%%%%%%%%%%%%%%%%% I krok %%%%%%%%%%%%%%%
Z=1;
A=Df(:,:,1);
[X,Y] = find(A==max(A(:))); X=round(mean(X)); Y=round(mean(Y));
PTH=[X Y Z];

Vox=Df(X,Y,Z);
ofset=round(Vox)-1;

A1=Df(X-ofset:X+ofset,Y-ofset:Y+ofset,  Z+ofset);
[X1,Y1] = find(A1==max(A1(:))); X1=round(mean(X1)); Y1=round(mean(Y1));

X=X+X1-ofset-1;
Y=Y+Y1-ofset-1;
Z=Z+ofset;

PTH=[PTH; X Y Z];

%%%%%%%%%%%%%%%%%% Wyznaczanie sciezki %%%%%%%%%%%%%%
%Dla bie��cego voksela sprawdzam, kt�ry woksel le��cy na �cianie
%sze�cianu ma najwi�ksz� warto�� i wybieram voxel najdalszy od poprzedniego
%punkty scie�ki

PTH_w=PTH(2,:);
PTH_temp=PTH; %jedna sciezka (petla k)
% mov = avifile('path_21.avi','quality',99,'fps',1)
for k0=1:50; k0%glowna petla do iteracji algorytmu
    Xp=PTH_w(1,1);
    Yp=PTH_w(1,2);
    Zp=PTH_w(1,3);
    PTH_w(1,:)=[];
    for k=1:50
        Vox=Df(Xp,Yp,Zp);
        ofset=round(Vox)-1;
        if ofset<8, ofset=8; end
        
        if Xp+ofset>size(Df,1), disp('zbyt duze X'), break, end
        if Yp+ofset>size(Df,2), disp('zbyt duze Y'), break, end
        if Zp+ofset>size(Df,3), disp('zbyt duze Z'), break, end
        if Xp-ofset<1,          disp('zbyt male X'), break, end
        if Yp-ofset<1,          disp('zbyt male Y'), break, end
        if Zp-ofset<1,          disp('zbyt male Z'), break, end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        A1=        Df(Xp-ofset:Xp+ofset,Yp-ofset:Yp+ofset,         Zp+ofset) ;
        A2=squeeze(Df(Xp-ofset         ,Yp-ofset:Yp+ofset,Zp-ofset:Zp+ofset));
        A3=squeeze(Df(         Xp+ofset,Yp-ofset:Yp+ofset,Zp-ofset:Zp+ofset));
        A4=squeeze(Df(Xp-ofset:Xp+ofset,Yp-ofset         ,Zp-ofset:Zp+ofset));
        A5=squeeze(Df(Xp-ofset:Xp+ofset,         Yp+ofset,Zp-ofset:Zp+ofset));
        A6=        Df(Xp-ofset:Xp+ofset,Yp-ofset:Yp+ofset,Zp-ofset         ) ;
        
        clear Df_temp;
        Df_temp=Df(Xp-ofset:Xp+ofset,Yp-ofset:Yp+ofset,Zp-ofset:Zp+ofset) ;
        size(Df_temp)
        
        %A1
        [X1,Y1] = find(A1==max(A1(:))); X1=round(mean(X1)); Y1=round(mean(Y1));
        X=Xp+X1-ofset-1;    Y=Yp+Y1-ofset-1;    Z=Zp+ofset;
        Df_vol(1)=A1(X1,Y1);    XYZ(1,:)=[X Y Z];
        %A2
        [Y1,Z1] = find(A2==max(A2(:))); Y1=round(mean(Y1)); Z1=round(mean(Z1));
        X=Xp-ofset;    Y=Yp+Y1-ofset-1;    Z=Zp+Z1-ofset-1;
        Df_vol(2)=A2(Y1,Z1);    XYZ(2,:)=[X Y Z];
        %A3
        [Y1,Z1] = find(A3==max(A3(:))); Y1=round(mean(Y1)); Z1=round(mean(Z1));
        X=Xp+ofset;    Y=Yp+Y1-ofset-1;    Z=Zp+Z1-ofset-1;
        Df_vol(3)=A3(Y1,Z1);    XYZ(3,:)=[X Y Z];
        %A4
        [X1,Z1] = find(A4==max(A4(:))); X1=round(mean(X1)); Z1=round(mean(Z1));
        X=Xp+X1-ofset-1;    Y=Yp-ofset;    Z=Zp+Z1-ofset-1;
        Df_vol(4)=A4(X1,Z1);    XYZ(4,:)=[X Y Z];
        %A5
        [X1,Z1] = find(A5==max(A5(:))); X1=round(mean(X1)); Z1=round(mean(Z1));
        X=Xp+X1-ofset-1;    Y=Yp+ofset;    Z=Zp+Z1-ofset-1;
        Df_vol(5)=A5(X1,Z1);    XYZ(5,:)=[X Y Z];
        %A6
        [X1,Y1] = find(A6==max(A6(:))); X1=round(mean(X1)); Y1=round(mean(Y1));
        X=Xp+X1-ofset-1;    Y=Yp+Y1-ofset-1;    Z=Zp-ofset;
        Df_vol(6)=A6(X1,Y1);    XYZ(6,:)=[X Y Z];
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % usu� voksele, kt�re s� blisko PTH
        Df_dis=ones(1,6);
        for k1=1:6
            for k2=1:size(PTH,1)
                if odleglosc(XYZ(k1,:),PTH(k2,:))<ofset
                    Df_dis(k1)=0; break
                end
            end
        end
        Df_vol=Df_vol.*Df_dis;
        
        if sum(Df_vol)==0, disp('koniec sciezki'),iteracji=k,break, end
        
        [ma_m,I_m] = max(Df_vol);
        
        Xp=XYZ(I_m,1);
        Yp=XYZ(I_m,2);
        Zp=XYZ(I_m,3);
        
        PTH=[PTH; Xp Yp Zp]
        PTH_temp=[PTH_temp; Xp Yp Zp];
        
        %wykrywanie w�z��w
        Df_vol=Df_vol./max(Df_vol);
        Df_vol(I_m)=0;
        [I_m] = find(Df_vol>0.5); %pr�g procentowy na ewentualne odga��zienie
        
        for k1=1:length(I_m)
            PTH_w=[PTH_w; XYZ(I_m(k1),1) XYZ(I_m(k1),2) XYZ(I_m(1),3)];
        end
    end
    %usuwanie blednych wezlow
    for k1=1:size(PTH_w,1)
        for k2=1:size(PTH,1)
            if odleglosc(PTH_w(k1,:),PTH(k2,:))<1
                PTH_w(k1,:)=[0 0 0]; break
            end
        end
    end
    [I_m] = find(PTH_w(:,1)==0); PTH_w(I_m,:)=[];
    if size(PTH_w,1)<2,
        disp('koniec - nie ma wiecej odgal�zie�'),break,
    else
        PTH=[PTH; PTH_w(1,:)];
    end
    close all
    %     open drzewo1.fig
    hold on
    plot3(PTH(:,2),PTH(:,1),PTH(:,3),'g*','LineWidth',3),
    plot3(PTH_temp(:,2),PTH_temp(:,1),PTH_temp(:,3),'b','LineWidth',3),
    plot3(PTH_temp(:,2),PTH_temp(:,1),PTH_temp(:,3),'b.'),
    plot3(PTH_w(:,2),PTH_w(:,1),PTH_w(:,3),'ro','LineWidth',3),
    %grid on,
    axis off
    axis([0 size(Df,2) 0 size(Df,1) 0 size(Df,3)]), box on
    camproj p; daspect([1 1 1]); view([22 5])
    set(gcf,'Position',[10 10 700 700]);
    F = getframe;%(gca, [-35    -30   372   372]);
    %         mov = addframe(mov,F);
    % Tutaj trzeba sprawdzi�, czy PTH_temp mo�e zosta� w PTH
    % 1. Znajd� voksel w PTH najbli�szy do PTH_temp
    dist_1=[];
    for k1=1:size(PTH_temp,1)
        for k2=1:size(PTH,1)-size(PTH_temp,1)-1
            dist_1(k1,k2)=odleglosc(PTH_temp(k1,:),PTH(k2,:));
        end
    end
    % 2. Cyz nie jest on zbyt blisko?
    Df_wsk=[];
    for k1=1:size(dist_1,1)
        Df_wsk(k1)=Df(PTH_temp(k1,1), PTH_temp(k1,2), PTH_temp(k1,3));
    end
    if sum(Df_wsk)==0;
    else
        Df_wsk=Df_wsk/max(Df_wsk)
        Df_wsk=Df_wsk/mean(Df_wsk)
    end
    
    PTH_wsk=ones(1,size(dist_1,1));
    for k1=1:size(dist_1,1)
        [yy Im]=min(dist_1(k1,:));
        Vox=Df( PTH(Im,1), PTH(Im,2), PTH(Im,3));
        %[Vox-yy]
        % Za blisko �cie�ki
        if 1.5*Vox>yy,   PTH_wsk(k1)=0; end %uwaga waga na Vox
        % za blisko �ciany unormowany
        if Df_wsk(k1)<0.5, PTH_wsk(k1)=0; end
    end
    %usu� b��dn� sciezke
    if length(PTH_wsk)
        mean(PTH_wsk)
        if mean(PTH_wsk)<0.5
            PTH(size(PTH,1)-size(dist_1,1):size(PTH,1)-1,:)=[];
        end
    end
    
    %pause
    
    PTH_temp=[];
    PTH_temp=PTH_w(1,:);
end
PTHd=PTH; save('PTHd','PTHd') %wyznaczona z distance transform


close all
%     open drzewo1.fig
hold on
plot3(PTH(:,2),PTH(:,1),PTH(:,3),'g*','LineWidth',3),
%plot3(PTH_temp(:,2),PTH_temp(:,1),PTH_temp(:,3),'b','LineWidth',3),
%plot3(PTH_temp(:,2),PTH_temp(:,1),PTH_temp(:,3),'b.'),
%plot3(PTH_w(:,2),PTH_w(:,1),PTH_w(:,3),'ro','LineWidth',3),
%grid on,
axis off
axis([0 size(Df,2) 0 size(Df,1) 0 size(Df,3)]), box on
camproj p; daspect([1 1 1]); view([22 5])
set(gcf,'Position',[10 10 700 700]);

F = getframe;
% mov = addframe(mov,F);

% mov = close(mov);
return
figure, hold on
hiso = patch(isosurface(vol,0),'FaceColor',[1,.75,.65],'EdgeColor','none');
axis tight; box on
camproj p;
daspect([1 1 1]);
lighting phong,
%VIEW([180, 180])
CAMLIGHT;
alpha(0.5)

%plot3(PTH(:,2),PTH(:,1),PTH(:,3),'b'),
plot3(PTH(:,2),PTH(:,1),PTH(:,3),'b.'),

%plot3(PTH_w(:,2),PTH_w(:,1),PTH_w(:,3),'ro'),

grid on
axis([0 size(D,2) 0 size(D,1) 0 size(D,3)])
% axis tight;
box on
camproj p;
daspect([1 1 1]);
hold on
view([-10 -60])
%pause
xlabel('y')
ylabel('x')
zlabel('z')