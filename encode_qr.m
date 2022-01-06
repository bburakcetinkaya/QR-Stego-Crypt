function qr = encode_qr(message, s)

import com.google.zxing.qrcode.QRCodeWriter;
import com.google.zxing.BarcodeFormat;

qr_writer = QRCodeWriter;

message = qr_writer.encode(message, BarcodeFormat.QR_CODE, s(2), s(1));


qr = zeros(message.height, message.width);
for i=1:message.height
    for j=1:message.width
        qr(i,j) = message.get(j-1,i-1);
    end
end

clear qr_writer;
clear M_java;

qr = logical(qr);
qr = uint8(qr);

for i=1:size(qr,1)
    for j= 1:size(qr,2)
        if qr(i,j) == 0 
           qr(i,j) = 255;
        end
        if qr(i,j) ==1
           qr(i,j) = 0;
        end
    end
end

imwrite(qr,'test_qr.jpg','JPG');





