close all; clc;

javaaddpath('.\core.jar');
javaaddpath('.\javase.jar');
%----  COVER  ---------------------------------------------------

cover = imread("Lenna.png");
coverResized = imresize(cover , [800 800]);
% coverResizedGray= rgb2gray(coverResized); 
% figure; 
%     subplot(1,2,1); imshow(cover);  axis on; title("Original Image");
%     subplot(1,2,2); imshow(coverResized); axis on; title("Resized Original Image");
%     subplot(1,3,3);imshow(coverResizedGray);axis on;title("Gray Original Image");

%----  QR CODES  ---------------------------------------------------

% qr1 = encode_qr('www.google.com', [800 800]);  qr1 = uint8(qr1);  %  birinci qr
% qr2 = encode_qr('SECRET MESSAGE', [800 800]);  qr2 = uint8(qr2);  % ikinci qr 

figure;
       subplot(1,2,1);imshow(qr1);axis on; title("First QR Code");
       subplot(1,2,2);imshow(qr2);axis on; title("Second QR Code");

qr1b= bitget(qr1,1); qr2b = bitget(qr2,1);
DQR = qr1;

%----  ENCRYPTION OF QR2 ---------------------------------------------------------

figure; 
      subplot(2,4,1); imshow(qr2); axis on; title("Second QR Code");


epoch = seconds(datetime('now') - datetime(1970,1,1));
rng(epoch,'twister');



KEY1  = uint8(rand(800,800)); subplot(2,4,2); imshow(KEY1.*255); axis on; title("KEY1");
KEY2 = uint8(rand(800,800));  subplot(2,4,3); imshow(KEY2.*255); axis on; title("KEY2");
KEY3 = uint8(rand(800,800));  subplot(2,4,4); imshow(KEY3.*255); axis on; title("KEY3");

MASTERKEY = uint8(rand(800,800)); subplot(2,4,5); imshow(MASTERKEY.*255); axis on; title("MASTER KEY");

encQR2 = bitxor(qr2b,KEY1);   subplot(2,4,6); imshow(encQR2.*255); axis on; title("Encrypted QR Image(Step 1)");
encQR2 = bitxor(encQR2,KEY2); subplot(2,4,7); imshow(encQR2.*255); axis on; title("Encrypted QR Image(Step 2)");
encQR2 = bitxor(encQR2,KEY3); subplot(2,4,8); imshow(encQR2.*255); axis on; title("Encrypted QR Image(Step 3)");

%----  STEGANOGRAPHY  ---------------------------------------------------------
    
SI = coverResized; %stego image
SI(:,:,2) = bitset(SI(:,:,2),1,bitget(DQR,1));
SI(:,:,3) = bitset(SI(:,:,3),1,bitget(encQR2,1));

figure;
    subplot(1,2,1); imshow(coverResized); axis on; title("Original Image (Cover)");
    subplot(1,2,2); imshow(SI); axis on; title("Stego Image");

    
%----  REVERSE STEGANOGRAPHY  ---------------------------------------------------------


decoy_message = bitget(SI(:,:,2),1);
rec_message = bitget(SI(:,:,3),1);

%---- DECRYPTION ----------------------------------------------------------------------

figure;
    subplot(2,3,1);imshow(SI);axis on; title("Stego Image");
    subplot(2,3,2);imshow(decoy_message.*255);axis on; title("Decoy message");
    subplot(2,3,3);imshow(rec_message.*255);axis on; title("Recovered message");
   decQR2 = bitxor(rec_message,KEY1); 
    subplot(2,3,4); imshow(decQR2.*255); axis on; title("Decryption Process(Step 1)");
   decQR2 = bitxor(decQR2,KEY2);      
    subplot(2,3,5); imshow(decQR2.*255); axis on; title("Decryption Process(Step 2)");
   decQR2 = bitxor(decQR2,KEY3);      
    subplot(2,3,6); imshow(decQR2.*255); axis on; title("Decrypted QR Image");

% figure;
% subplot(1,2,1);
% imshow(recoveredQRS);
% axis on; title(" QR code");
% subplot(1,2,2);
% imshow(recoveredMessage);
% axis on; title("message");

% figure;
% subplot(2,5,1);
% imshow(coverResized);
% axis on; title("Resized Cover");
% subplot(2,5,2);
% imshow(coverResizedGray);
% axis on; title("Resized Cover (Grey)");
% subplot(2,5,3);
% imshow(ranImage.*255);
% axis on; title("KEY");
% subplot(2,5,4);
% imshow(qr_code);
% axis on; title("QR Code");
% subplot(2,5,5);
% imshow(encryptedQR.*255);
% axis on; title("Encrpyted QR Code");
% subplot(2,5,6);
% imshow(stego);
% axis on; title("Stego");
% subplot(2,5,7);
% imshow(stegoGray);
% axis on; title("Stego (Grey)");
% subplot(2,5,8);
% imshow(recoveredQR.*255);
% axis on; title("Recovered Message");
% subplot(2,5,9);
% imshow(ranImage.*255);
% axis on; title("KEY");
% subplot(2,5,10);
% imshow(recoveredQRS);
% axis on; title("Decrypted QR Code");
% % ---------------------------------
%encryption

