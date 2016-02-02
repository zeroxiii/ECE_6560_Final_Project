% Rahmaan Lodhia
% ECE 6560
% Final Project Chan-Vese Algorithm
% curvature.m

function K = curvature(phi)
% Approximate curvature using central difference scheme
% deltaX and deltaY are both equal to 1

Phi_x = ( phi([2:end 1],:,:)-phi([end 1:end-1],:,:) )./2;
Phi_y = ( phi(:,[2:end 1],:)-phi(:,[end 1:end-1],:) )./2;
Phi_xy = ( Phi_x(:,[2:end 1],:)-Phi_x(:,[end 1:end-1],:) )./2;
Phi_xx = ( phi([2:end 1],:,:)- 2.*phi + phi([end 1:end-1],:,:) )./ 1;
Phi_yy = ( phi(:,[2:end 1],:)- 2.*phi + phi(:,[end 1:end-1],:) )./ 1;

% Calculate K with partial derivaties
% For the denominator, eps is used to avoid NaN results
K = -(Phi_xx.*(Phi_y.^2) - 2.*Phi_x.*Phi_y.*Phi_xy + Phi_yy.*(Phi_x.^2))./(max(eps, ((Phi_x.^2)+(Phi_y.^2))));

end