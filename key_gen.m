function key = key_gen(input,s)

epoch = seconds(datetime('now') - datetime(1970,1,1));

epochbin = zeros(s(1),s(2));
epochtemp = epoch;
while epochtemp>=0
for i = 1:s(1)
    for j = 1:s(2)
            epochbin(i,j) = epoch/2^(i+j-2);
            epochtemp = epochtemp/10;
    end
end
end


inputmat = zeros(s(1),s(2));
inputbin = reshape(dec2bin(input, 8).'-'0',1,[]);

for i = 1:size(epochbin(1))
    for j = 1:size(epochbin(2))
       inputmat(i,j) = epochbin(i,j);
    end
end
% for i = 1:inputbin.length()
%     for j = 1:inputbin.width()
%        inputmat(i,j) = inputbin(i,j);
%     end
% end
%     
%     
% key = bitxor(epoch,input);







