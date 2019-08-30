%% Does the key expansion based on the notes from class
function A = keyExpansion(x)
len = length(x);
expanded_key = x;
rconn = 0;
%% 128-bit mode
if len == 32
    while length(expanded_key) < 352
        for j = 1:4
            temp1 = expanded_key(length(expanded_key) - 7:end);
            if j == 1
                round_constant = 2^rconn;
                round_constant = modP(round_constant);
                temp1 = keyExpansionCore(temp1, round_constant);
                rconn = rconn + 1;
            end
            temp2 = expanded_key(length(expanded_key) - 31:end);
            temp2 = temp2(1:8);
            dec1 = hex2dec(temp1);
            dec2 = hex2dec(temp2);
            result = bitxor(dec1, dec2);
            hex_result = decimal2hex(result);
            while length(hex_result) < 8
                hex_result = strcat('0', hex_result);
            end
            expanded_key = strcat(expanded_key, hex_result);
        end
    end
    diff = length(expanded_key) - 352;
    expanded_key = expanded_key(1:end-diff);
%% 192-bit mode
elseif len == 48
    while length(expanded_key) < 416
        for j = 1:6
            temp1 = expanded_key(length(expanded_key) - 7:end);
            if j == 1
                round_constant = 2^rconn;
                round_constant = modP(round_constant);
                temp1 = keyExpansionCore(temp1, round_constant);
                rconn = rconn + 1;
            end
            temp2 = expanded_key(length(expanded_key) - 47:end);
            temp2 = temp2(1:8);
            dec1 = hex2dec(temp1);
            dec2 = hex2dec(temp2);
            result = bitxor(dec1, dec2);
            hex_result = decimal2hex(result);
            while length(hex_result) < 8
                hex_result = strcat('0', hex_result);
            end
            expanded_key = strcat(expanded_key, hex_result);
        end
    end
    diff = length(expanded_key) - 416;
    expanded_key = expanded_key(1:end-diff);
%% 256-bit mode
elseif len == 64
    while length(expanded_key) < 480
        for j = 1:8
            temp1 = expanded_key(length(expanded_key) - 7:end);
            if j == 1
                round_constant = 2^rconn;
                round_constant = modP(round_constant);
                temp1 = keyExpansionCore(temp1, round_constant);
                rconn = rconn + 1;
            end
            if j == 5
                temp1 = sBox(temp1, 1);
            end
            temp2 = expanded_key(length(expanded_key) - 63:end);
            temp2 = temp2(1:8);
            dec1 = hex2dec(temp1);
            dec2 = hex2dec(temp2);
            result = bitxor(dec1, dec2);
            hex_result = decimal2hex(result);
            while length(hex_result) < 8
                hex_result = strcat('0', hex_result);
            end
            expanded_key = strcat(expanded_key, hex_result);
        end
    end
    diff = length(expanded_key) - 480;
    expanded_key = expanded_key(1:end-diff);
else
    disp('Incorrect Key Size. Key Expansion Unsuccessful.');
end
A = expanded_key;
end