function [Dscaled] = scaleDisp(D, maxDisp)

D = D - min(D(:));
D = D./max(D(:));
D = D.*maxDisp;

Dscaled = D;