% Rahmaan Lodhia
% ECE 6560
% Final Project Chan-Vese Algorithm
% contourLength.m

function len = contourLength(c)
% Take a contour matrix defined at level 0 and compute its total length

currentIndex = 1;
len = 0;

while currentIndex < length(c)
    if c(1,currentIndex) == 0
        for i = (currentIndex+1):(currentIndex+c(2,currentIndex)-1)
            len = len + sqrt((c(1,i)-c(1,i+1)).^2 + (c(2,i)-c(2,i+1)).^2);
        end
        currentIndex = i+1;
    end
    
    currentIndex = currentIndex + 1;
end


end