function message = decode_qr(qr_img)

import com.google.zxing.qrcode.QRCodeReader;
import com.google.zxing.client.j2se.BufferedImageLuminanceSource;
import com.google.zxing.BinaryBitmap;
import com.google.zxing.common.HybridBinarizer;
import com.google.zxing.Result;


javaimg = im2java2d(qr_img);
source = BufferedImageLuminanceSource(javaimg);
bitmap = BinaryBitmap(HybridBinarizer(source));
qr_reader = QRCodeReader;
try 
    result = qr_reader.decode(bitmap);
    %parsedResult = ResultParser.parseResult(result);
    message = char(result.getText());
catch 
    message = []        
end

clear source;
clear jimg;
clear bitmap;
