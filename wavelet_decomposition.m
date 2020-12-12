clc;
close all;
clear all;

%load example of speech sound
[truesignal,fs] =audioread('gettysburg10.wav');
truesignal = truesignal(:,1);% mono to stero

% amp = 20;
% truesignal = amp*truesignal;

N = length(truesignal);
fprintf('OK\n');

%the scalar SNR specifies the signal-to-noise ratio per sample, in dB
sn = -5;

%add white Gaussian noise to a signal
truesignalN = awgn(truesignal,sn,'measured');  
fprintf('OK\n');

%---------------------------%
%           DWT :           %
%   wavelet decomposition   %
%---------------------------%
%Decomposition. Choose a wavelet, and choose a level N. Compute the wavelet
%decomposition of the signal s at level N.
level = 3;

% fprintf('\n   Input the number of specific wavelet: (1) db13, (2) db40, (3) sym13 or (4) sym21');
% wname = input('\n   wname = ');
wname = 1;
if wname == 1
    wt = 'db13';
elseif wname == 2
    wt = 'db40';
elseif wname == 3
    wt = 'sym13';
elseif wname == 4
    wt = 'sym21';
end

%computes four filters
[Lo_D,Hi_D,Lo_R,Hi_R] = wfilters(wt);        
[C,L] = wavedec(truesignalN,level,Lo_D,Hi_D);
cA3 = appcoef(C,L,wt,level);         
%extract the levels 3, 2, and 1 detail coefficients from C
[cD1,cD2,cD3] = detcoef(C,L,[1,2,3]);  
%reconstruct the level 3 approximation from C
A3 = wrcoef('a',C,L,Lo_R,Hi_R,level);
%reconstruct the details at levels 1, 2, and 3, from C
D1 = wrcoef('d',C,L,Lo_R,Hi_R,1);
D2 = wrcoef('d',C,L,Lo_R,Hi_R,2);
D3 = wrcoef('d',C,L,Lo_R,Hi_R,3);
%a = approximation
%d = detail
fprintf('OK\n');

%-----------------    Listen Result   ------------------------------------      

% fprintf('\n   Play the Original Sound:');
% wavplay(truesignal,Fs,'sync')
% fprintf(' OK');
% fprintf('\n   Play the Noisy Sound:');
% wavplay(truesignalN,Fs,'sync')
% fprintf(' OK');


%-----------------    Display Figure   ------------------------------------  

figure(1)
subplot(3,1,1); plot(truesignal); title('True Speech Signal'); 
subplot(3,2,3); plot(A3); title('Approximation A3')
subplot(3,2,4); plot(D3); title('Detail D3')
subplot(3,2,5); plot(D2); title('Detail D2')
subplot(3,2,6); plot(D1); title('Detail D1')


