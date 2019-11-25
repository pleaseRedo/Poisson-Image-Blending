
target='fruits.jpg';
sourcemask='fruitsMask.jpg';


I1 = imread(sourcemask);    
I1(I1>0) = 1;
I1 = logical(I1);
I2 = imread(target);        
II = rgb2gray(I2);

%src_mask = im2double((I1));
% tgt = im2double((I2));
% tgt_mask = rgb2gray(tgt);
fig= figure();
set(fig, 'Position', [400, 300, 800,600]);
% User select region
subplot(2,2,1)
imshow(I2);
%[masked, u, v] = roipoly(src);  
%masked = roipoly(I1); %% This line would suppress the title of 'Source image'
title('Source Image');

% Displaying the masked image
subplot(2,2,2)
imshow((I1));
title('Image Mask');


src_mask = I1;
[num_row,num_col] = find(src_mask == 1);   
height = max(num_row) - min(num_row);                     
width = max(num_col) - min(num_col);
%tgt_mask = zeros(size(tgt));

% Displaying the cropped region for target image

src_R = double(I2(:, :, 1));
src_G = double(I2(:, :, 2));
src_B = double(I2(:, :, 3));


%OFFSET
[r,c] = find(src_mask == 1); % Get index for mask

result = zeros(size(I2));
% localColorChanges(src, masked,tgt,tgt_mask,targetLocation)
% src_mask(src_mask>0) = 1;
% src_mask = logical(src_mask);
rchannel = localColorChanges(src_R, src_mask,src_R,II,[min(r) min(c)]);
gchannel = localColorChanges(src_G, src_mask,src_G,II,[min(r) min(c)]);
bchannel = localColorChanges(src_B, src_mask,src_B,II,[min(r) min(c)]);



result = zeros(size(bchannel,1), size(bchannel,2), 3);
result(:, :, 1) = rchannel;
result(:, :, 2) = gchannel;
result(:, :, 3) = bchannel;
%result = ImportingGradients(src, masked,tgt,tgt_mask,targetLocation);
subplot(2,2,3)
imshow(uint8(result));
title('Result');



imwrite(uint8(result), 'resultT5.jpg');
