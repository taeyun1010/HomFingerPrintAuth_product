function encryptedBits = homEncrypt(plaintext)
%HOMENCRYPT homomorphically encrypt given integer
%   returns

bits = de2bi(plaintext);
        

bitcount = 1;

for bit = bits
    [a,b,var] = encMat(bit);
    
    encryptedBits{bitcount,1}=a;
    encryptedBits{bitcount,2}=b;
    encryptedBits{bitcount,3}=var;
    
    %             file{1,fp_number}=namefile;
    bitcount = bitcount + 1;
end

end

