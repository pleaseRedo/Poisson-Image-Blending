
source='birds.jpg';


I1 = imread(source);        
%src = rgb2gray(I1);
src = im2double(rgb2gray(I1));
fig= figure();
set(fig, 'Position', [400, 300, 800,600]);
% User select region
subplot(2,2,1)
imshow(src);
[masked, u, v] = roipoly(src);  
%masked = roipoly(I1); %% This line would suppress the title of 'Source image'
title('Source Image');

% Displaying the masked image
subplot(2,2,2)
imshow((masked));
title('Mask');

% Displaying the cropped region
cropedI1 = src .* masked;
subplot(2,2,3)
imshow(uint8(cropedI1*255));
title('Cropped');

% Displaying the final output
result = Eq2Implementation(src, masked);
subplot(2,2,4);
imshow(result);
title('Result');
imwrite(result, 'resultT1_2.jpg');
%When selecting region with smooth area, the result does not show
% strong gradient(color changes) in that area.