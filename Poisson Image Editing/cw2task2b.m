
%source='fonts.jpg';
%target='wall.jpg';

% source = 'timcook.jpg';
%target='steveJobs.jpg';
source='steveJobs.jpg';
target='apples.jpg';
%target='resultT41.jpg';



I1 = imread(source);        
I2 = imread(target);        
%src = rgb2gray(I1);
src = im2double((I1));
tgt = im2double((I2));
fig= figure();
set(fig, 'Position', [400, 300, 800,600]);
% User select region
subplot(3,2,1)
imshow(src);
[masked, u, v] = roipoly(src);  
%masked = roipoly(I1); %% This line would suppress the title of 'Source image'
title('Source Image');

% Displaying the masked image
subplot(3,2,2)
imshow((tgt));
title('Target Image');

% Displaying the cropped region
cropedI1 = src;
cropedI1(:,:,1) = src(:,:,1) .* masked;
cropedI1(:,:,2) = src(:,:,2) .* masked;
cropedI1(:,:,3) = src(:,:,3) .* masked;
subplot(3,2,3)
imshow(uint8(cropedI1*255));
title('Cropped');

%targetLocation = [300 300]; wall
targetLocation = [250 200]; %stevejobs 
%targetLocation = [130 230]; %timcook 
%targetLocation = [75 175]; %people


[num_row,num_col] = find(masked == 1);   
height = max(num_row) - min(num_row);                     
width = max(num_col) - min(num_col);
tgt_mask = zeros(size(tgt,1),size(tgt,2));
% Locating where the mask starts(row-wise)
flag = 0;
for i = 1:size(masked,1)
    for j = 1:size(masked,2)
        if masked(i,j) == 1
            mask_topmost = i;
            flag = 1;
            break;  
        end
    end
    if flag == 1; 
        break;
    end
end
% Locating where the mask starts(column-wise)
% Could just use min(num_col) and min(num_row)
mask_leftmost = 9999999;
for i = 1:size(masked,1)
    for j = 1:size(masked,2)
        if masked(i,j) == 1
            if j < mask_leftmost                
               mask_leftmost = j;              
            end             
        end
    end
    
end

% Now we can get the relative location of mask in target.     
count = 0;
for i = 1:height
    for j = 1:width
        if masked(mask_topmost+i-1,mask_leftmost+j-1) == 1
            count = count + 1;
            tgt_mask(i+targetLocation(1),j+targetLocation(2)) = 1;
        end
    end  
end
% Displaying the cropped region for target image
cropedI2 = tgt .* tgt_mask;
subplot(3,2,4)
imshow(uint8(cropedI2*255));
title('Cropped');


% Displaying mask

subplot(3,2,5)
imshow(masked);
title('Mask');

src_R = src(:, :, 1);
src_G = src(:, :, 2);
src_B = src(:, :, 3);
tgt_R = tgt(:, :, 1);
tgt_G = tgt(:, :, 2);
tgt_B = tgt(:, :, 3);


result = zeros(size(tgt));
result(:,:,1) = mixingGradient(src_R, masked,tgt_R,tgt_mask,targetLocation);
result(:,:,2) = mixingGradient(src_G, masked,tgt_G,tgt_mask,targetLocation);
result(:,:,3) = mixingGradient(src_B, masked,tgt_B,tgt_mask,targetLocation);

%result = ImportingGradients(src, masked,tgt,tgt_mask,targetLocation);
%subplot(3,2,6)
imshow(result);
title('Result');



imwrite(result, 'resultT2b.jpg');
