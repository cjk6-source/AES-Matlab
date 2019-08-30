%% Multiplies two numbers together mod the AES polynomial
function A = multiply(x, y)
x = upper(x);
y = upper(y);
product = 0;
dec = hex2dec(x);
bin = hexToBinaryVector(y);
bin = fliplr(bin);
length2 = length(bin);
for i = 1:length2 % loops through and multiplies based on the way we learned in class
    if bin(i) == 1
        product = bitxor(product, bitshift(dec, i-1));
    end
end
product = modP(product); % mods the result by the AES polynomial
product_hex = decimal2hex(product);
A = product_hex;