%% XORS two numbers together (Must be used for large numbers; MATLAB xors does not work for large numbers)
function A = xors(a, b)
len = length(a);
i = 1;
str = ' ';
%% Goes through each byte of the two strings, xors them, and appends the result to the final string
while i <= len-1
    byteA = a(i:i+1);
    a_dec = hex2dec(byteA);
    byteB = b(i:i+1);
    b_dec = hex2dec(byteB);
    xorbyte = bitxor(a_dec, b_dec);
    xorbyte = decimal2hex(xorbyte);
    i = i+2;
    str = strcat(str, xorbyte);
end
A = str;
end