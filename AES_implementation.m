% Christian Kang
% MATH 4175 Cryptography
clear
clc
format compact
%% INPUT SECTION
mode = input('Press 1 for encryption:\nPress 2 for decryption:\n');
if mode == 1 % Encryption
    plaintext = input('Please input the plaintext: such as ''01a2feba...''\n');
    plaintext = upper(plaintext);
else         % Decryption
    ciphertext = input('Please input the ciphertext: such as ''8e3873e0...''\n');
    ciphertext = upper(ciphertext);
end
key = input('Please input the initial key: such as ''a21efca7...''\n');
key = upper(key);
type = input('Press 1 for ECB\nPress 2 for CBC\n');
disp('Calculating...');
len = length(key);
expanded_key = keyExpansion(key);
%% ENCRYPTION
if mode == 1 
    col_matrix = ['2' '3' '1' '1'; '1' '2' '3' '1'; '1' '1' '2' '3'; '3' '1' '1' '2'];
    ciphertext = ' ';
    if len == 32 %128-bit
        while mod(length(plaintext), 32) ~= 0 % Pads the plaintext with zeros if needed
            plaintext = strcat(plaintext, '0');
        end
        cbc = '00000000000000000000000000000000';
        while length(plaintext) >= 32 % Loops through all blocks of plaintext
            begin = 1;
            last = 32;
            p_block = plaintext(1:32);
            if type == 2 % CBC Mode
                p_block = xors(p_block, cbc);
            end
            round_key = expanded_key(begin:last);
            result = xors(p_block, round_key);
            %fprintf('Plaintext Block: %s\n', lower(p_block));
            %fprintf('Round Key: %s\n', lower(round_key));
            %fprintf('Result: %s\n', lower(result));
            plaintext = plaintext(last + 1:end);
            for i = 1:10
                %% Sub Bytes
                result = (sBox(result, 1));
                result = result{1};
                %fprintf('Sub-Bytes: %s\n', lower(result));
                %% Shift Rows
                row1 = [result(1:2),result(9:10),result(17:18),result(25:26)];
                row2 = [result(3:4),result(11:12),result(19:20),result(27:28)];
                row3 = [result(5:6),result(13:14),result(21:22),result(29:30)];
                row4 = [result(7:8),result(15:16),result(23:24),result(31:32)];
                m = [row1; row2; row3; row4];
                c = zeros(4,4);
                for row = 1:4
                    for col = 1:4
                        c(row, col) = hex2dec(m(row, 2*col-1:2*col));
                    end
                end
                c(2,:) = circshift(c(2,:), -1);
                c(3,:) = circshift(c(3,:), -2);
                c(4,:) = circshift(c(4,:), -3);
                %fprintf('Shift Rows: ');
                %for col = 1:4
                %    for row = 1:4
                %        %fprintf(lower(decimal2hex(c(row,col))));
                %    end
                %end
                %fprintf('\n');
                %% Mix Columns
                if i ~= 10
                    m = c;
                    for row = 1:4
                        for col = 1:4
                            q = '00';
                            for k = 1:4
                                q = xors(q, multiply(col_matrix(row,k),decimal2hex(c(k,col))));
                            end
                            m(row, col) = hex2dec(q);
                        end
                    end
                    result = ' ';
                    for col = 1:4
                        for row = 1:4
                            result = strcat(result, decimal2hex(m(row,col)));
                        end
                    end
                    %fprintf('Mix Columns: %s\n', lower(result));
                else
                    result = ' ';
                    for col = 1:4
                        for row = 1:4
                            result = strcat(result, decimal2hex(c(row,col)));
                        end
                    end
                end
                %% Add Round Key
                if type == 1 % ECB Mode
                    begin = last + 1;
                    last = last + 32;
                    round_key = expanded_key(begin:last);
                    result = xors(result, round_key);
                    %fprintf('Round Key: %s\n', lower(result));
                elseif type == 2 % CBC Mode
                    begin = last + 1;
                    last = last + 32;
                    round_key = expanded_key(begin:last);
                    result = xors(result, round_key);
                    %fprintf('Round Key: %s\n', lower(result));
                end
            end
            cbc = result;
            ciphertext = strcat(ciphertext, result);
        end
    elseif len == 48 % 192-bit
        while mod(length(plaintext), 32) ~= 0 % Pads the plaintext with zeros if necessary
            plaintext = strcat(plaintext, '0');
        end
        cbc = '000000000000000000000000000000000000000000000000';
        while length(plaintext) >= 32 % Loops through all blocks of plaintext
            begin = 1;
            last = 32;
            p_block = plaintext(1:32);
            if type == 2 % CBC Mode
                p_block = xors(p_block, cbc);
            end
            round_key = expanded_key(begin:last);
            result = xors(p_block, round_key);
            %fprintf('Plaintext Block: %s\n', lower(p_block));
            %fprintf('Round Key: %s\n', lower(round_key));
            %fprintf('Result: %s\n', lower(result));
            plaintext = plaintext(last + 1:end);
            for i = 1:12
                %% Sub Bytes
                result = (sBox(result, 1));
                result = result{1};
                %fprintf('Sub-Bytes: %s\n', lower(result));
                %% Shift Rows
                row1 = [result(1:2),result(9:10),result(17:18),result(25:26)];
                row2 = [result(3:4),result(11:12),result(19:20),result(27:28)];
                row3 = [result(5:6),result(13:14),result(21:22),result(29:30)];
                row4 = [result(7:8),result(15:16),result(23:24),result(31:32)];
                m = [row1; row2; row3; row4];
                c = zeros(4,4);
                for row = 1:4
                    for col = 1:4
                        c(row, col) = hex2dec(m(row, 2*col-1:2*col));
                    end
                end
                c(2,:) = circshift(c(2,:), -1);
                c(3,:) = circshift(c(3,:), -2);
                c(4,:) = circshift(c(4,:), -3);
                %fprintf('Shift Rows: ');
                %for col = 1:4
                %    for row = 1:4
                %        %fprintf(lower(decimal2hex(c(row,col))));
                %    end
                %end
                %fprintf('\n');
                %% Mix Columns
                if i ~= 12
                    m = c;
                    for row = 1:4
                        for col = 1:4
                            q = '00';
                            for k = 1:4
                                q = xors(q, multiply(col_matrix(row,k),decimal2hex(c(k,col))));
                            end
                            m(row, col) = hex2dec(q);
                        end
                    end
                    result = ' ';
                    for col = 1:4
                        for row = 1:4
                            result = strcat(result, decimal2hex(m(row,col)));
                        end
                    end
                    %fprintf('Mix Columns: %s\n', lower(result));
                else
                    result = ' ';
                    for col = 1:4
                        for row = 1:4
                            result = strcat(result, decimal2hex(c(row,col)));
                        end
                    end
                end
                %% Add Round Key
                if type == 1 % ECB Mode
                    begin = last + 1;
                    last = last + 32;
                    round_key = expanded_key(begin:last);
                    result = xors(result, round_key);
                    %fprintf('Round Key: %s\n', lower(result));
                elseif type == 2 % CBC Mode
                    begin = last + 1;
                    last = last + 32;
                    round_key = expanded_key(begin:last);
                    result = xors(result, round_key);
                    %fprintf('Round Key: %s\n', lower(result));
                end
            end
            cbc = result;
            ciphertext = strcat(ciphertext, result);
        end
    elseif len == 64 % 256-bit
        while mod(length(plaintext), 32) ~= 0 % Pads the plaintext with zeros if necessary
            plaintext = strcat(plaintext, '0');
        end
        cbc = '000000000000000000000000000000000000000000000000';
        while length(plaintext) >= 32 % Loops through all blocks of plaintext
            begin = 1;
            last = 32;
            p_block = plaintext(1:32);
            if type == 2
                p_block = xors(p_block, cbc);
            end
            round_key = expanded_key(begin:last);
            result = xors(p_block, round_key);
            %fprintf('Plaintext Block: %s\n', lower(p_block));
            %fprintf('Round Key: %s\n', lower(round_key));
            %fprintf('Result: %s\n', lower(result));
            plaintext = plaintext(last + 1:end);
            for i = 1:14
                %% Sub Bytes
                result = (sBox(result, 1));
                result = result{1};
                %fprintf('Sub-Bytes: %s\n', lower(result));
                %% Shift Rows
                row1 = [result(1:2),result(9:10),result(17:18),result(25:26)];
                row2 = [result(3:4),result(11:12),result(19:20),result(27:28)];
                row3 = [result(5:6),result(13:14),result(21:22),result(29:30)];
                row4 = [result(7:8),result(15:16),result(23:24),result(31:32)];
                m = [row1; row2; row3; row4];
                c = zeros(4,4);
                for row = 1:4
                    for col = 1:4
                        c(row, col) = hex2dec(m(row, 2*col-1:2*col));
                    end
                end
                c(2,:) = circshift(c(2,:), -1);
                c(3,:) = circshift(c(3,:), -2);
                c(4,:) = circshift(c(4,:), -3);
                %fprintf('Shift Rows: ');
                %for col = 1:4
                %    for row = 1:4
                %        %fprintf(lower(decimal2hex(c(row,col))));
                %    end
                %end
                %fprintf('\n');
                %% Mix Columns
                if i ~= 14
                    m = c;
                    for row = 1:4
                        for col = 1:4
                            q = '00';
                            for k = 1:4
                                q = xors(q, multiply(col_matrix(row,k),decimal2hex(c(k,col))));
                            end
                            m(row, col) = hex2dec(q);
                        end
                    end
                    result = ' ';
                    for col = 1:4
                        for row = 1:4
                            result = strcat(result, decimal2hex(m(row,col)));
                        end
                    end
                    %fprintf('Mix Columns: %s\n', lower(result));
                else
                    result = ' ';
                    for col = 1:4
                        for row = 1:4
                            result = strcat(result, decimal2hex(c(row,col)));
                        end
                    end
                end
                %% Add Round Key
                if type == 1 % ECB Mode
                    begin = last + 1;
                    last = last + 32;
                    round_key = expanded_key(begin:last);
                    result = xors(result, round_key);
                    %fprintf('Round Key: %s\n', lower(result));
                elseif type == 2 % CBC Mode
                    begin = last + 1;
                    last = last + 32;
                    round_key = expanded_key(begin:last);
                    result = xors(result, round_key);
                    %fprintf('Round Key: %s\n', lower(result));
                end
            end
            cbc = result;
            ciphertext = strcat(ciphertext, result);
        end
    else
        disp('Wrong Key Length.');
    end
    fprintf('Ciphertext: %s\n', lower(ciphertext));
else %% DECRYPTION
    col_matrix = ['0E' '0B' '0D' '09'; '09' '0E' '0B' '0D'; '0D' '09' '0E' '0B'; '0B' '0D' '09' '0E'];
    plaintext = ' ';
    if len == 32 % 128-bit
        cbc = '00000000000000000000000000000000';
        while length(ciphertext) >= 32 % Loops through all blocks of ciphertext
            %% Add Round Key
            begin = length(expanded_key) - 31;
            last = length(expanded_key);
            round_key = expanded_key(begin:last);
            c_block = ciphertext(1:32);
            result = xors(round_key, c_block);
            ciphertext = ciphertext(33:end);
            %fprintf('Ciphertext: %s\n', lower(c_block));
            %fprintf('Round Key 9: %s\n', lower(result));
            %% Invert Shift Rows
            row1 = [result(1:2),result(9:10),result(17:18),result(25:26)];
            row2 = [result(3:4),result(11:12),result(19:20),result(27:28)];
            row3 = [result(5:6),result(13:14),result(21:22),result(29:30)];
            row4 = [result(7:8),result(15:16),result(23:24),result(31:32)];
            m = [row1; row2; row3; row4];
            c = zeros(4,4);
            for row = 1:4
                for col = 1:4
                    c(row, col) = hex2dec(m(row, 2*col-1:2*col));
                end
            end
            c(2,:) = circshift(c(2,:), 1);
            c(3,:) = circshift(c(3,:), 2);
            c(4,:) = circshift(c(4,:), 3);
            result = ' ';
            for col = 1:4
                for row = 1:4
                    result = strcat(result, decimal2hex(c(row,col)));
                end
            end
            %fprintf('Invert Shift Rows: %s\n', result);
            %% Invert Sub Bytes
            result = ' ';
            for col = 1:4
                for row = 1:4
                    result = strcat(result, decimal2hex(c(row,col)));
                end
            end
            result = sBox(result, 2);
            result = result{1};
            %fprintf('Invert Sub Bytes: %s\n', result);
            for i = 1:9
                %% Add Round Key
                last = begin - 1;
                begin = begin - 32;
                round_key = expanded_key(begin:last);
                %fprintf('Round Key: %s\n', round_key);
                result = xors(round_key, result);
                %fprintf('Add Round Key: %s\n', result);
                %% Invert Mix Columns
                row1 = [result(1:2),result(9:10),result(17:18),result(25:26)];
                row2 = [result(3:4),result(11:12),result(19:20),result(27:28)];
                row3 = [result(5:6),result(13:14),result(21:22),result(29:30)];
                row4 = [result(7:8),result(15:16),result(23:24),result(31:32)];
                m = [row1; row2; row3; row4];
                c = zeros(4,4);
                for row = 1:4
                    for col = 1:4
                        c(row, col) = hex2dec(m(row, 2*col-1:2*col));
                    end
                end
                m = c;
                for row = 1:4
                    for col = 1:4
                        q = '00';
                        for k = 1:4
                            q = xors(q, multiply(col_matrix(row,k*2-1:k*2),decimal2hex(c(k,col))));
                        end
                        m(row, col) = hex2dec(q);
                    end
                end
                result = ' ';
                for col = 1:4
                    for row = 1:4
                        result = strcat(result, decimal2hex(m(row,col)));
                    end
                end
                %fprintf('Invert Mix Columns: %s\n', lower(result));
                %% Invert Shift Rows
                m(2,:) = circshift(m(2,:), 1);
                m(3,:) = circshift(m(3,:), 2);
                m(4,:) = circshift(m(4,:), 3);
                %% Invert Sub Bytes
                result = ' ';
                for col = 1:4
                    for row = 1:4
                        result = strcat(result, decimal2hex(m(row,col)));
                    end
                end
                result = sBox(result, 2);
                result = result{1};
                %fprintf('Invert Sub Bytes: %s\n', result);
            end
            %% Add Round Key
            round_key = expanded_key(1:32);
            result = xors(result, round_key);
            if type == 2 % CBC Mode
                result = xors(result, cbc);
                cbc = c_block;
            end
            %fprintf('Add Round Key FINAL: %s\n', result);
            plaintext = strcat(plaintext, result);
        end
    elseif len == 48 % 192-bit
        cbc = '000000000000000000000000000000000000000000000000';
        while length(ciphertext) >= 32 % Loops through all blocks of ciphertext
            %% Add Round Key
            begin = length(expanded_key) - 31;
            last = length(expanded_key);
            round_key = expanded_key(begin:last);
            c_block = ciphertext(1:32);
            result = xors(round_key, c_block);
            ciphertext = ciphertext(33:end);
            %fprintf('Ciphertext: %s\n', lower(c_block));
            %fprintf('Round Key 9: %s\n', lower(result));
            %% Invert Shift Rows
            row1 = [result(1:2),result(9:10),result(17:18),result(25:26)];
            row2 = [result(3:4),result(11:12),result(19:20),result(27:28)];
            row3 = [result(5:6),result(13:14),result(21:22),result(29:30)];
            row4 = [result(7:8),result(15:16),result(23:24),result(31:32)];
            m = [row1; row2; row3; row4];
            c = zeros(4,4);
            for row = 1:4
                for col = 1:4
                    c(row, col) = hex2dec(m(row, 2*col-1:2*col));
                end
            end
            c(2,:) = circshift(c(2,:), 1);
            c(3,:) = circshift(c(3,:), 2);
            c(4,:) = circshift(c(4,:), 3);
            result = ' ';
            for col = 1:4
                for row = 1:4
                    result = strcat(result, decimal2hex(c(row,col)));
                end
            end
            %fprintf('Invert Shift Rows: %s\n', result);
            %% Invert Sub Bytes
            result = ' ';
            for col = 1:4
                for row = 1:4
                    result = strcat(result, decimal2hex(c(row,col)));
                end
            end
            result = sBox(result, 2);
            result = result{1};
            %fprintf('Invert Sub Bytes: %s\n', result);
            for i = 1:11
                %% Add Round Key
                last = begin - 1;
                begin = begin - 32;
                round_key = expanded_key(begin:last);
                %fprintf('Round Key: %s\n', round_key);
                result = xors(round_key, result);
                %fprintf('Add Round Key: %s\n', result);
                %% Invert Mix Columns
                row1 = [result(1:2),result(9:10),result(17:18),result(25:26)];
                row2 = [result(3:4),result(11:12),result(19:20),result(27:28)];
                row3 = [result(5:6),result(13:14),result(21:22),result(29:30)];
                row4 = [result(7:8),result(15:16),result(23:24),result(31:32)];
                m = [row1; row2; row3; row4];
                c = zeros(4,4);
                for row = 1:4
                    for col = 1:4
                        c(row, col) = hex2dec(m(row, 2*col-1:2*col));
                    end
                end
                m = c;
                for row = 1:4
                    for col = 1:4
                        q = '00';
                        for k = 1:4
                            q = xors(q, multiply(col_matrix(row,k*2-1:k*2),decimal2hex(c(k,col))));
                        end
                        m(row, col) = hex2dec(q);
                    end
                end
                result = ' ';
                for col = 1:4
                    for row = 1:4
                        result = strcat(result, decimal2hex(m(row,col)));
                    end
                end
                %fprintf('Invert Mix Columns: %s\n', lower(result));
                %% Invert Shift Rows
                m(2,:) = circshift(m(2,:), 1);
                m(3,:) = circshift(m(3,:), 2);
                m(4,:) = circshift(m(4,:), 3);
                %% Invert Sub Bytes
                result = ' ';
                for col = 1:4
                    for row = 1:4
                        result = strcat(result, decimal2hex(m(row,col)));
                    end
                end
                result = sBox(result, 2);
                result = result{1};
                %fprintf('Invert Sub Bytes: %s\n', result);
            end
            %% Add Round Key
            round_key = expanded_key(1:32);
            result = xors(result, round_key);
            if type == 2 % CBC Mode
                result = xors(result, cbc);
                cbc = c_block;
            end
            %fprintf('Add Round Key FINAL: %s\n', result);
            plaintext = strcat(plaintext, result);
        end
    elseif len == 64 % 256-bit
        cbc = '0000000000000000000000000000000000000000000000000000000000000000';
        while length(ciphertext) >= 32 % Loops through all blocks of ciphertext
            %% Add Round Key
            begin = length(expanded_key) - 31;
            last = length(expanded_key);
            round_key = expanded_key(begin:last);
            c_block = ciphertext(1:32);
            result = xors(round_key, c_block);
            ciphertext = ciphertext(33:end);
            %fprintf('Ciphertext: %s\n', lower(c_block));
            %fprintf('Round Key 9: %s\n', lower(result));
            %% Invert Shift Rows
            row1 = [result(1:2),result(9:10),result(17:18),result(25:26)];
            row2 = [result(3:4),result(11:12),result(19:20),result(27:28)];
            row3 = [result(5:6),result(13:14),result(21:22),result(29:30)];
            row4 = [result(7:8),result(15:16),result(23:24),result(31:32)];
            m = [row1; row2; row3; row4];
            c = zeros(4,4);
            for row = 1:4
                for col = 1:4
                    c(row, col) = hex2dec(m(row, 2*col-1:2*col));
                end
            end
            c(2,:) = circshift(c(2,:), 1);
            c(3,:) = circshift(c(3,:), 2);
            c(4,:) = circshift(c(4,:), 3);
            result = ' ';
            for col = 1:4
                for row = 1:4
                    result = strcat(result, decimal2hex(c(row,col)));
                end
            end
            %fprintf('Invert Shift Rows: %s\n', result);
            %% Invert Sub Bytes
            result = ' ';
            for col = 1:4
                for row = 1:4
                    result = strcat(result, decimal2hex(c(row,col)));
                end
            end
            result = sBox(result, 2);
            result = result{1};
            %fprintf('Invert Sub Bytes: %s\n', result);
            for i = 1:13
                %% Add Round Key
                last = begin - 1;
                begin = begin - 32;
                round_key = expanded_key(begin:last);
                %fprintf('Round Key: %s\n', round_key);
                result = xors(round_key, result);
                %fprintf('Add Round Key: %s\n', result);
                %% Invert Mix Columns
                row1 = [result(1:2),result(9:10),result(17:18),result(25:26)];
                row2 = [result(3:4),result(11:12),result(19:20),result(27:28)];
                row3 = [result(5:6),result(13:14),result(21:22),result(29:30)];
                row4 = [result(7:8),result(15:16),result(23:24),result(31:32)];
                m = [row1; row2; row3; row4];
                c = zeros(4,4);
                for row = 1:4
                    for col = 1:4
                        c(row, col) = hex2dec(m(row, 2*col-1:2*col));
                    end
                end
                m = c;
                for row = 1:4
                    for col = 1:4
                        q = '00';
                        for k = 1:4
                            q = xors(q, multiply(col_matrix(row,k*2-1:k*2),decimal2hex(c(k,col))));
                        end
                        m(row, col) = hex2dec(q);
                    end
                end
                result = ' ';
                for col = 1:4
                    for row = 1:4
                        result = strcat(result, decimal2hex(m(row,col)));
                    end
                end
                %fprintf('Invert Mix Columns: %s\n', lower(result));
                %% Invert Shift Rows
                m(2,:) = circshift(m(2,:), 1);
                m(3,:) = circshift(m(3,:), 2);
                m(4,:) = circshift(m(4,:), 3);
                %% Invert Sub Bytes
                result = ' ';
                for col = 1:4
                    for row = 1:4
                        result = strcat(result, decimal2hex(m(row,col)));
                    end
                end
                result = sBox(result, 2);
                result = result{1};
                %fprintf('Invert Sub Bytes: %s\n', result);
            end
            %% Add Round Key
            round_key = expanded_key(1:32);
            result = xors(result, round_key);
            if type == 2
                result = xors(result, cbc);
                cbc = c_block;
            end
            %fprintf('Add Round Key: %s\n', result);
            plaintext = strcat(plaintext, result);
        end
    else
        disp('Wrong Key Length.');
    end
    fprintf('Plaintext: %s\n', lower(plaintext));
end