function key = key_gen(input)

epoch = seconds(datetime('now') - datetime(1970,1,1));
epochtemp = epoch;
epochbin = zeros(800,800);
while epochtemp > 0 
    for i = 1:800
        for j = 1:800
            epochbin(i,j) = epochtemp/2^(i+j-2);
        end
    end
end

inputmat = zeros(800,800);
inputbin = reshape(dec2bin(input, 8).'-'0',1,[]);
    
key = bitxor(epoch,input);
