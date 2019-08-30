# AES-Matlab
A Matlab implementation of AES

This repo contains an implementation of AES that I created in Matlab. If you want to run the program, you must have all files in one directory and run the file AES_implementation.m with MATLAB. You will be prompted in the command window to choose between encryption or decryption, input the plaintext/ciphertext as a string such as ‘7bef29a.....’, input the initial key as a string such as ‘1523ade.....’, and choose between ECB or CBC mode. It may take a while to process depending on the size of the plaintext. If you want to have step-by-step output, you must uncomment all the fprintf calls.

While it is functional, it is also quite slow. This was for a project in my cryptography class at Virginia Tech. The concepts should all be there but I had to add a few extra functions due to the limitations of working with Matlab.
