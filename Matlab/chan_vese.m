% Rahmaan Lodhia
% ECE 6560
% Final Project Chan-Vese Algorithm
% chan_vese.m

function [phi, niter, u, v, E] = chan_vese(I, phi0, tau, maxT, lambda1, lambda2, mu, nu)
% Applies the Chan-Vese algorithm to the Image I with initial level-set phi

% Initialize variables
% Number of iterations
niter = round(maxT/tau);

% Initialize Energy vector
E = zeros(niter,1);

% Set initial levelset
phi = phi0;

for i = 1:niter
    % Find current values for u and v using fixed curve defined by current
    % phi
    
    % Average intensity inside contour
    u = sum(sum(I(phi < 0)))/length(I(phi < 0));
    
    % Average intensity outside contour
    v = sum(sum(I(phi > 0)))/length(I(phi > 0));
    
    % Calculate curvature value K
    K = curvature(phi);
        
    % Determine the phi at the next time step using the defined PDE
    phi = phi + tau.*lambda1.*((I-u).^2).*upwindEntropyNorm(phi,1) - tau.*lambda2.*((I-v).^2).*upwindEntropyNorm(phi,-1) - tau.*mu.*K + tau.*nu.*upwindEntropyNorm(phi,1);

    % Calculate energy in current level-set
    intesnityInside = (I-u).^2;
    intensityOutside = (I-v).^2;
    c = contourc(phi, [0 0]);
    E(i) = lambda1.*sum(sum(intesnityInside(phi < 0))) + lambda2.*sum(sum(intensityOutside(phi > 0))) + mu.*contourLength(c) + nu.*length(intesnityInside(phi < 0));
end

end