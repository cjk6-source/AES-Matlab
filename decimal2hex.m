%% Converts a decimal to a hex number and pads with 0 if necessary
function A = decimal2hex(x)
x = dec2hex(x);
while length(x) < 2
    x = strcat('0', x);
end
A = x;
end