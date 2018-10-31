function [output] = reduceintegerbits(inputinteger,nb_bits)
% represents given inputinteger using nb_bits of bits
% returns the value of integer that is represented by having nb_bits of
% inputinteger
bits = de2bi(inputinteger);


if length(bits) > nb_bits
    reducedbits = bits(1:nb_bits);
else
    reducedbits = bits;
end

output = bi2de(reducedbits);

end

