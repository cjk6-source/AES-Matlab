%% Mods a number by the AES polynomial x^8+x^4+x^3+x+1
function A = modP(x)
AES_POLYNOMIAL_DEC = 283; % converted the AES polynomial to a decimal to do calculations
result = x;
bin = dec2bin(result);
while length(bin) >= 9   % 9 is the size of the AES Polynomial
    diff = length(bin) - 9;
    result = bitxor(result, bitshift(AES_POLYNOMIAL_DEC, diff));
    bin = dec2bin(result);
end
A = result;
end