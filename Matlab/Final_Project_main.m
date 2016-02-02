% Rahmaan Lodhia
% ECE 6560
% Final Project Chan-Vese Algorithm
% Main Run File

% Set parameters to use for Chan-Vese calculation
% Desired nxn size of sample
n = 300;

%Set to 1 if noise is desired in image
addNoise = 0;

% Load and scale image and add noise if applicable
filename = 'Images/cameraman.png';
I = imread(filename);
scaleI = imresize(I, [n, n]);
if addNoise == 1
    scaleI = imnoise(scaleI, 'gaussian');
    f0 = double(scaleI)./max(max(double(scaleI)));
else
    f0 = double(scaleI)./max(max(double(scaleI)));
end


% Creates a grid of circle contours depending on k
% For this project, only 1 circle was created as the level-set
[Y,X] = meshgrid(1:n,1:n);
k = 1; %number of circles
r = .1*n/k;
phi0 = zeros(n,n)+Inf;
for i=1:n
    for j=1:n
        c = ([i j]-1)*(n/k)+(n/k)*.5;
        phi0 = min( phi0, sqrt( (X-c(1)).^2 + (Y-c(2)).^2 ) - r );
    end
end

% % Plot original contour
figure
imshow(scaleI); colormap(gray); hold on
title('Contour at Level-Set 0 at Iteration = 0');
contour(phi0, [0 0], 'r');
hold off

% Create original segment plot
figure
segment = zeros(n,n);
segment(phi0 > 0) = 1;
segmentI = mat2gray(segment);
imshow(segmentI)
title('Segmented Image at Iteration = 0');


% Set time parameters
deltaT = 0.2;
maxT = 0.8;

% Set scaling parameters for energy terms
lambda1 = 1.0;
lambda2 = 1.0;
mu = 0.5;
nu = 0.0;

% Compute segmentation with Chan_Vese
[phi, niter, u, v, E] = chan_vese(f0, phi0, deltaT, maxT, lambda1, lambda2, mu, nu);

% Plot final curvature result
figure
imshow(scaleI); colormap(gray); hold on
title(sprintf('Contour at Level-Set 0 at Iteration = %d', niter));
contour(phi, [0 0], 'r');
hold off

% Create final segment plot
figure
segment = zeros(n,n);
segment(phi > 0) = 1;
segmentI = mat2gray(segment);
imshow(segmentI)
title(sprintf('Segmented Image at Iteration = %d', niter));

% Plot Energy vs. Iteration Curve
figure
plot(1:niter,E);
xlabel('Number of Iterations')
ylabel('Energy')
title('Energy vs Iteration')