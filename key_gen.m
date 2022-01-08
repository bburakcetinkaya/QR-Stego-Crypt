function key = key_gen(time, password, s)

epoch = time;
epoch = milliseconds(datetime('now') - datetime(1970,1,1));

s(1) = 512;
s(2) = 512;
iter1 = max(ceil(log10(abs(epoch))),1);

epochTempArr = zeros(1,iter1);

for i = 1:iter1
    epochtemp = epoch/(10^(iter1-i));
    epochtemp = floor(epochtemp);
    epochTempArr(i) = mod(epochtemp,10); 
    
    for j=(i)*8:-1:((i-1)*8)+1
        epochbin(j) = mod(epochTempArr(i),2);
        epochTempArr(i) = epochTempArr(i)./2;
        epochTempArr(i) = floor(epochTempArr(i));
    end
end
epochbin = uint8(epochbin);

epochKey = zeros(s(1),s(2));
for i = 1:s(1)
    for j = 1:s(2)
        if (i+j) < size(epochbin,2)
         epochKey(i,j) = epochbin(i+j); 

        else
            break;
        end
    end
end

epochKey = circshift(epochKey,[111 360]);
% epochKey = randperm(numel(epochKey));
% epochKey = reshape(epochKey,s);
epochKey = uint8(epochKey);

asciiPass = double(char('lşkfdslşkdfkşlsfdkşlfds65+565+6+56a+sdfwe+a5905 +9we 0*-wa/9s+adf5 +6'));

iter2 = size(asciiPass,2);
asciiTemp = zeros(1,iter2*3);
temp = asciiPass;

for i = 1:iter2
    for k = (i-1)*3+1:(i*3)
        temp(k) = asciiPass(i)/(10^mod(3-k,3)); %max 3 digits in ascii charachers
        temp(k) = floor(temp(k));
        asciiTemp(k) = mod(temp(k),10); 
    end  
end
for i= 1:(iter2*3)
             for j=(i*8):-1:((i-1)*8)+1
                passbin(j) = mod(asciiTemp(i),2);
                asciiTemp(i) = asciiTemp(i)./2;
                asciiTemp(i) = floor(asciiTemp(i));
             end
end
passKey = zeros(s(1),s(2));
for i = 1:s(1)
    for j = 1:s(2)
        if (i+j) < size(passbin,2)
         passKey(i,j) = passbin(i+j); 

        else
            break;
        end
    end
end

passKey = circshift(passKey,[125 250]);
% passKey = randperm(numel(passKey));
% passKey = reshape(passKey,s);
passKey= uint8(passKey);

key = bitxor(passKey,epochKey);
% key = randperm(numel(key));
% key = reshape(key,s);
key= uint8(key);







