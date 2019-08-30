%% Finds and replaces hex values using the S-box table provided
function A = sBox(x, y)
x = upper(x);
len = length(x);
T = readtable('AES S-box.txt');
i = 1;
s = '';
if y == 1 % Encryption
    while i <= len-1
        byte = x(i: i+1);
        index = find(strcmp(byte,T{:,1}));
        s = strcat(s, T{index, 2});
        i = i+2;
    end
else      % Decryption
    while i <= len-1
        byte = x(i: i+1);
        index = find(strcmp(byte,T{:,2}));
        s = strcat(s, T{index, 1});
        i = i+2;
    end
end
A = s;
end