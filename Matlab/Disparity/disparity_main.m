% Load left and right images
I_1_RGB = imread('Images/tsukuba/scene1.row3.col5.ppm');
I_2_RGB = imread('Images/tsukuba/scene1.row3.col2.ppm');
I_1 = double(rgb2gray(I_1_RGB));
I_2 = double(rgb2gray(I_2_RGB));

%Determine min and max disparity values from ground truth
Ground_Truth = imread('Images/tsukuba/truedisp.row3.col3.pgm');
minDisp = double(min(min(Ground_Truth))/8);
maxDisp = double(max(max(Ground_Truth))/8);


[rows,cols] = size(I_1);

iterations = 300;

d = zeros(rows,cols,1);
%disp_map = d;

deltaX = 15;
deltaY = 15;
deltaT = 10;

startPoint = 19;
Ethresh = 0.01;

for t = 1:iterations
    for x = startPoint:(rows-startPoint)
        for y = startPoint:(cols-startPoint)
            I_diff = I_1(x,y) - I_2(x,min(cols, round(y+d(x,y,t))));
            if (I_diff)^2 < Ethresh
                d(x,y,t+deltaT) = d(x,y,t); 
            else
                d_xx = (d(x+deltaX,y,t) - 2*d(x,y,t) + d(x-deltaX,y,t))/(deltaX^2);
                d_yy = (d(x,y+deltaY,t) - 2*d(x,y,t) + d(x,y-deltaY,t))/(deltaY^2);
                d(x,y,t+deltaT) = d(x,y,t) + deltaT*(I_diff)*(I_2(x,min(cols, round(y+d(x,y,t))+deltaY)) - I_2(x,min(cols, round(y+d(x,y,t))-deltaY)))/(2*deltaY) + deltaT*(d_xx + d_yy);
%                 if d(x,y,t+deltaT) > maxDisp
%                     d(x,y,t+deltaT) = maxDisp;
%                 elseif d(x,y,t+deltaT) < minDisp
%                     d(x,y,t+deltaT) = minDisp;
%                 end
            end
        end
    end
    d(startPoint:(rows-startPoint),startPoint:(cols-startPoint),t+deltaT) = scaleDisp(d(startPoint:(rows-startPoint),startPoint:(cols-startPoint),t+deltaT),maxDisp);
end
% for t = 1:iterations
%     for x = startPoint:(rows-startPoint)
%         for y = startPoint:(cols-startPoint)
%             I_L = I_1(x,y);
%             if round(y+d(x,y)) < startPoint
%                 I_R = I_2(x,startPoint);
%                 I_RdY = I_2(x,startPoint+deltaY);
%             elseif round(y+d(x,y)) > (cols-startPoint)
%                 I_R = I_2(x,cols-startPoint);
%                 I_RdY = I_2(x,cols-startPoint+deltaY);
%             else
%                 I_R = I_2(x, round(y+d(x,y)));
%                 I_RdY = I_2(x,round(y+d(x,y))+deltaY);
%             end
%             d_xx = (d(x+deltaX,y) - 2*d(x,y) + d(x-deltaX,y))/(deltaX^2);
%             d_yy = (d(x,y+deltaY) - 2*d(x,y) + d(x,y-deltaY))/(deltaY^2);
%             disp_map(x,y) = d(x,y) + (I_L - I_R) * (I_RdY - I_R)/deltaY + d_xx + d_yy;
% %             if d(x,y) < 0
% %                 disp_map(x,y) = d(x,y) + (I_1(x,y) - I_2(x,max(round(y+d(x,y)),startPoint)))*((I_2(x,max(round(y+d(x,y)),startPoint)+deltaY)-I_2(x,max(round(y+d(x,y)), startPoint)-deltaY))/(2*deltaY)) + d_xx + d_yy;
% %             else
% %             disp_map(x,y) = d(x,y) + (I_1(x,y) - I_2(x,min(round(y+d(x,y)),cols-startPoint)))*((I_2(x,min(round(y+d(x,y)),cols-startPoint)+deltaY)-I_2(x,min(round(y+d(x,y)),cols-startPoint)))/(deltaY)) + d_xx + d_yy;
% %             if disp_map(x,y) < minDisp
% %                 disp_map(x,y) = minDisp;
% %             elseif disp_map(x,y) > maxDisp
% %                 disp_map(x,y) = maxDisp;
% %             end
%         end
%     end
%     d = disp_map;
% end

disp_map = d(:,:,iterations+deltaT);

imshow(8*disp_map,[])

error = sum(sum((8.*disp_map - double(Ground_Truth)).^2))
