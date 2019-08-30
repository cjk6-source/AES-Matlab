%% Does the key expansion core
function A = keyExpansionCore(x, y)
%% Rotate left
first_byte = x(1:2);
last_3_bytes = x(3:end);
shifted_bytes = strcat(last_3_bytes,first_byte);
byte1 = shifted_bytes(1:2);
byte2 = shifted_bytes(3:4);
byte3 = shifted_bytes(5:6);
byte4 = shifted_bytes(7:8);
s_result = strcat(byte4, byte3, byte2, byte1);
%% S-Box
s_result = sBox(s_result, 1);
s_result_dec = hex2dec(s_result);
%% Round Constant
rconn_result = decimal2hex(bitxor(s_result_dec, y));
while length(rconn_result) < 8 % pads with zeros until it has length 8
    rconn_result = strcat('0', rconn_result);
end
revByte1 = rconn_result(7:8);
revByte2 = rconn_result(5:6);
revByte3 = rconn_result(3:4);
revByte4 = rconn_result(1:2);
final = strcat(revByte1, revByte2, revByte3, revByte4);
A = final;
end