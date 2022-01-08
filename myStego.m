close all; clc;

javaaddpath('.\core.jar');
javaaddpath('.\javase.jar');
%----  COVER  ---------------------------------------------------

cover = imread("Lenna.png");
% coverResized = imresize(cover , [800 800]);
% coverResizedGray= rgb2gray(coverResized); 
% figure; 
%     subplot(1,2,1); imshow(cover);  axis on; title("Original Image");
%     subplot(1,2,2); imshow(coverResized); axis on; title("Resized Original Image");
%     subplot(1,3,3);imshow(coverResizedGray);axis on;title("Gray Original Image");

%----  QR CODES  ---------------------------------------------------

% qr1 = encode_qr('www.google.com', [size(cover,1) size(cover,2)]);  qr1 = uint8(qr1);  %  birinci qr
% qr2 = encode_qr('SECRET MESSAGE', [size(cover,1) size(cover,2)]);  qr2 = uint8(qr2);  % ikinci qr 

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
time = milliseconds(datetime('now') - datetime(1970,1,1));
password1 =  ['Sed ut perspiciatis, unde omnis iste natus error sit voluptatem accusantium' ... 
             'doloremque laudantium, totam rem aperiam eaque ipsa, quae ab illo inventore'...
             'veritatis et quasi architecto beatae vitae dicta sunt, explicabo. Nemo enim '...
             'ipsam voluptatem, quia voluptas sit, aspernatur aut odit aut fugit, sed quia'...
             'consequuntur magni dolores eos, qui ratione voluptatem sequi nesciunt, neque '...
             'porro quisquam est, qui dolorem ipsum, quia dolor sit amet consectetur adipisci[ng]'...
             'velit, sed quia non numquam [do] eius modi tempora inci[di]dunt, ut labore et dolore'...
             'magnam aliquam quaerat voluptatem.'];
password2 = ['Ut enim ad minima veniam, quis nostrum[d] exercitationem ullam corporis suscipit' ...
             'laboriosam, nisi ut aliquid ex ea commodi consequatur? [D]Quis autem vel eum iure' ...
             'reprehenderit, qui in ea voluptate velit esse, quam nihil molestiae consequatur, '...
             'vel illum, qui dolorem eum fugiat, quo voluptas nulla pariatur? [33] At vero eos '...
             'et accusamus et iusto odio dignissimos ducimus, qui blanditiis praesentium voluptatum'...
             'deleniti atque corrupti, quos dolores et quas molestias excepturi sint, obcaecati'...
             'cupiditate non provident, similique sunt in culpa, qui officia deserunt mollitia animi,'...
             'id est laborum et dolorum fuga. '];
password3 = ['Et harum quidem rerum facilis est et expedita distinctio. Nam libero tempore, cum soluta'...
             'nobis est eligendi optio, cumque nihil impedit, quo minus id, quod maxime placeat, facere'...
             'possimus, omnis voluptas assumenda est, omnis dolor repellendus. Temporibus autem quibusdam'...
             'et aut officiis debitis aut rerum necessitatibus saepe eveniet, ut et voluptates repudiandae'...
             'sint et molestiae non recusandae. Itaque earum rerum hic tenetur a sapiente delectus, ut aut'...
             'reiciendis voluptatibus maiores alias consequatur aut perferendis doloribus asperiores repellat.'];

keys.KEY1 = key_gen(time, password1, [size(cover(1)) size(cover(2))]);
keys.KEY2 = key_gen(time, password2, [size(cover(1)) size(cover(2))]);
keys.KEY3 = key_gen(time, password3, [size(cover(1)) size(cover(2))]);

keys.KEY1  = uint8(rand(size(cover,1), size(cover,2))); subplot(2,4,2); imshow(keys.KEY1.*255); axis on; title("KEY1");
keys.KEY2 = uint8(rand(size(cover,1), size(cover,2)));  subplot(2,4,3); imshow(keys.KEY2.*255); axis on; title("KEY2");
keys.KEY3 = uint8(rand(size(cover,1), size(cover,2)));  subplot(2,4,4); imshow(keys.KEY3.*255); axis on; title("KEY3");

MASTERKEY = uint8(rand(size(cover,1), size(cover,2))); subplot(2,4,5); imshow(MASTERKEY.*255); axis on; title("MASTER KEY");

encQR2 = bitxor(qr2b,keys.KEY1);   subplot(2,4,6); imshow(encQR2.*255); axis on; title("Encrypted QR Image(Step 1)");
encQR2 = bitxor(encQR2,keys.KEY2); subplot(2,4,7); imshow(encQR2.*255); axis on; title("Encrypted QR Image(Step 2)");
encQR2 = bitxor(encQR2,keys.KEY3); subplot(2,4,8); imshow(encQR2.*255); axis on; title("Encrypted QR Image(Step 3)");

enckeys = key_crypt_ops(keys,MASTERKEY);

% enckeys.KEY1 = bitxor(MASTERKEY,KEY1);
% enckeys.KEY2 = bitxor(MASTERKEY,KEY2);
% enckeys.KEY3 = bitxor(MASTERKEY,KEY3);

%----  STEGANOGRAPHY  ---------------------------------------------------------
    
SI = cover; %stego image
SI(:,:,2) = bitset(SI(:,:,2),1,bitget(DQR,1));
SI(:,:,3) = bitset(SI(:,:,3),1,bitget(encQR2,1));

figure;
    subplot(1,2,1); imshow(cover); axis on; title("Original Image (Cover)");
    subplot(1,2,2); imshow(SI); axis on; title("Stego Image");

    
%----  REVERSE STEGANOGRAPHY  ---------------------------------------------------------


decoy_message = bitget(SI(:,:,2),1);
rec_message = bitget(SI(:,:,3),1);

%---- DECRYPTION ----------------------------------------------------------------------
% key decryption
deckeys = key_crypt_ops(enckeys,MASTERKEY);

figure;
    subplot(2,3,1);imshow(SI);axis on; title("Stego Image");
    subplot(2,3,2);imshow(decoy_message.*255);axis on; title("Decoy message");
    subplot(2,3,3);imshow(rec_message.*255);axis on; title("Recovered message");
   decQR2 = bitxor(rec_message,deckeys.KEY1); 
    subplot(2,3,4); imshow(decQR2.*255); axis on; title("Decryption Process(Step 1)");
   decQR2 = bitxor(decQR2,deckeys.KEY2);      
    subplot(2,3,5); imshow(decQR2.*255); axis on; title("Decryption Process(Step 2)");
   decQR2 = bitxor(decQR2,deckeys.KEY3);      
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


