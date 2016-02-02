% Rahmaan Lodhia
% ECE 6560
% Final Project Chan-Vese Algorithm
% upwindEntropyNorm.m

function norm = upwindEntropyNorm(phi, sign)
% Calculate the norm of the gradient of the level set using the upwind
% entropy scheme
% deltaX and deltaY are both equal to 1

% Calculate forward and backward derivatives
DxF = phi([2:end 1],:,:)-phi;
DxB = phi - phi([end 1:end-1],:,:);
DyF = phi(:,[2:end 1],:)-phi;
DyB = phi - phi(:,[end 1:end-1],:);

% Depending on input sign, use the specified entropy scheme
if sign == 1
    norm = (sum(sum((max(DxF,eps)).^2 + (min(DxB,eps)).^2 + (max(DyF,eps)).^2 + (min(DyB,eps)).^2))).^(1/2);
elseif sign == -1
    norm = (sum(sum((min(DxF,eps)).^2 + (max(DxB,eps)).^2 + (min(DyF,eps)).^2 + (max(DyB,eps)).^2))).^(1/2);
end

end