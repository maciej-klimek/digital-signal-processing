function [ PhaseRefSymb, sigPhaseRefSymb ] = PhaseRefSymbGen( Mode )
% Phase Reference Symbol generation for DAB frames
% Input: Mode : DAB mode: 1,2,3,4; only 1 is supported
% Output:
% PhaseRefSymb    - frequency spectrum of the the Phase Reference Symbol (length: Nfft)
% sigPhaseRefSymb - time waveform of the Phase Reference Symbol (length: NSampPerGuard+Nfft)

%############
if( Mode ==1)
    
% Table 39, page 147, only for mode=1
  Nfft = 2048;
  NSampPerGuard = 504;
 
tab  = [ -768 -737 -768 0 1;
         -736 -705 -736 1 2;
         -704 -673 -704 2 0;
         -672 -641 -672 3 1;
         -640 -609 -640 0 3;
         -608 -577 -608 1 2;
         -576 -545 -576 2 2;
         -544 -513 -544 3 3;
         -512 -481 -512 0 2;
         -480 -449 -480 1 1;
         -448 -417 -448 2 2;
         -416 -385 -416 3 3;
         -384 -353 -384 0 1;
         -352 -321 -352 1 2;
         -320 -289 -320 2 3;
         -288 -257 -288 3 3;
         -256 -225 -256 0 2;
         -224 -193 -224 1 2;
         -192 -161 -192 2 2;
         -160 -129 -160 3 1;
         -128  -97 -128 0 1;
          -96  -65  -96 1 3;
          -64  -33  -64 2 1;
          -32   -1  -32 3 2;
            1   32    1 0 3
           33   64   33 3 1;
           65   96   65 2 1;
           97  128   97 1 1;
          129  160  129 0 2;
          161  192  161 3 2;
          193  224  193 2 1;
          225  256  225 1 0;
          257  288  257 0 2;
          289  320  289 3 2;
          321  352  321 2 3;
          353  384  353 1 3;
          385  416  385 0 0;
          417  448  417 3 2;
          449  480  449 2 1;
          481  512  481 1 3;
          513  544  513 0 3;
          545  576  545 3 3;
          577  608  577 2 3;
          609  640  609 1 0;
          641  672  641 0 3;
          673  704  673 3 0;
          705  736  705 2 1;
          737  768  737 1 1 ];
 
 [ K, L ] = size(tab);
 
% Table 43, page 148
h = [ 0 2 0 0 0 0 1 1 2 0 0 0 2 2 1 1   0 2 0 0 0 0 1 1 2 0 0 0 2 2 1 1 ; ...
      0 3 2 3 0 1 3 0 2 1 2 3 2 3 3 0   0 3 2 3 0 1 3 0 2 1 2 3 2 3 3 0; ...
      0 0 0 2 0 2 1 3 2 2 0 2 2 0 1 3   0 0 0 2 0 2 1 3 2 2 0 2 2 0 1 3; ...
      0 1 2 1 0 3 3 2 2 3 2 1 2 1 3 2   0 1 2 1 0 3 3 2 2 3 2 1 2 1 3 2 ];

% Equation page 147  
PhaseRefSymb(769) = 0;
for k = 1 : K
    for kk = tab(k,1) : tab(k,2)
        fi(kk+769) = (pi/2)*( h( tab(k,4)+1, kk-tab(k,3)+1) + tab(k,5) );
        work(kk+769) = exp( j*fi(kk+769) );
    end    
end
PhaseRefSymb = zeros(1,2048);
PhaseRefSymb(1:769) = work(769:1537);
PhaseRefSymb(end:-1:end-768+1) = work(768:-1:1);

PhaseRefSymb = PhaseRefSymb.';

sigref = ifft(PhaseRefSymb); sigref = [ sigref(end-NSampPerGuard+1:1:end); sigref ];
sigPhaseRefSymb = sigref;

% stem(PhaseRefSymb); title('Spectrum of the Phase Ref Symbol'), size(PhaseRefSymb), pause
% stem(sigPhaseRefSymb); title('Time Waveform of Phase Ref Symbol'); pause

%############
else
    disp('Only Mode==1 is supported');
    PhaseRefSymb = [];
    
%############    
end

    




    