# extendTrainingSet
Perl script that implements the symbol transformations in the training sets using the proposed encodings

USAGE : -i <input training file> -o <output training file> -e <encoding> -t <past Observations> -i trainSet.seq -o trainSetExt.seq -e 2 -t 1

Encoding Groups
(1) An Encoding with 40 (20 x 2) symbols depending on whether the previous residue is hydrophobic (A, F, H, I, L, M, V, W, Y) or non-hydrophobic (C, D, E, G, K, N, P, Q, R, S, T). (Encoding 1).
(2) An Encoding with 80 (20 x 4) symbols depending on whether the previous residue is: Hydrophobic–Aromatic (F, H, Y, W), Hydrophobic–non-Aromatic (A, I, L, M, V, G), non-Hydrophobic–Charged (D, E, K, R), non-Hydrophobic–Polar (C, N, P, Q, S, T). (Encoding 2).
(3) An Encoding with 160 (20 x 8) symbols depending on whether the previous residue is: Hydrophobic–Small (A, G), Polar–Special (P, C), Polar–OH (S, T), Polar–NH (N, Q), Charged–Negative (D, E), Charged–Positive (K, R), Hydrophobic– Huge (I, L, M, V) and Hydrophobic–Aromatic (F, H, Y, W). (Encoding 3).
(4) An Encoding with 400 (20 x 20) symbols that takes into account all possible dipeptide combinations. (Encoding 4).
