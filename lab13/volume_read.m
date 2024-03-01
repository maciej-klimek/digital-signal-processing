clear all; close all;
cd( ) % wej�cie do katalogu z DICOM-ami
%% ---- ustalenie wymiaru przekroju
I = dicomread(); imshow(I,[]) % wczytanie pierwszego z brzegu przekroju
info = dicominfo();

Nx = info.  % znale�� wymiary przekroju
Ny = info. % znale�� wymiary przekroju
%% zapisywanie przekroj�w do macierzy 3D i 
pliki = dir('*.dcm');   % struktura z nazwami wszystkich plik�w w formacie .dcm znajduj�cych si� w bie��cym folderze
CT = zeros(Nx,Ny,length(pliki));  % macierz zer do zapisywania kolejnych przekroj�w DICOM
kontrolaZ=zeros(1,length(pliki));

for i = 1:length(pliki)
    % zapisywanie przekroj�w
    slice = dicomread(pliki(i).name);
    info = dicominfo(pliki(i).name);
    CT(:,:, ) = slice;
    % zapisywanie potzebnych metadanych
    kontrolaZ(info.InstanceNumber) = info.SliceLocation;
    kontrolaSeries(info.InstanceNumber)=info.SeriesNumber;
    kontrolaSlice(info.InstanceNumber)=info.SliceThickness;
    kontrolaPosition(info.InstanceNumber,:)=info.ImagePositionPatient;
    kontrolaSpacing(info.InstanceNumber,:)=info.PixelSpacing;
    
end


%% weryfikacja poprawno�ci zapisania danych
% subplot(121)
plot(kontrolaSpacing(:,2));hold on;
plot(kontrolaSlice(1,:),'g');
plot(kontrolaPosition(:,3),'r');grid on;
plot(kontrolaZ,'c');grid on;
legend('Pixel Spacing','SliceThickness','ImagePositionPatient','SliceLocation');
figure;
PS_sl_num = 256;
CT_sp = squeeze(CT(:,PS_sl_num,:));
CT_sp = imresize(CT_sp,[512 512],'bilinear');
% subplot(122);
imshow(CT_sp,[1000 1100])
