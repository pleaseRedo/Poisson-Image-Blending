
source='birds.jpg';
target='sky.jpg';


I1 = imread(source);        
I2 = imread(target);        
%src = rgb2gray(I1);
src = im2double(rgb2gray(I1));
tgt = im2double(rgb2gray(I2));
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
cropedI1 = src .* masked;
subplot(3,2,3)
imshow(uint8(cropedI1*255));
title('Cropped');

targetLocation = [10 150];
[num_row,num_col] = find(masked == 1);   
height = max(num_row) - min(num_row);                     
width = max(num_col) - min(num_col);
tgt_mask = zeros(size(tgt));
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

result = ImportingGradients(src, masked,tgt,tgt_mask,targetLocation);
subplot(3,2,6)
imshow(result);
title('Result');


% Displaying the final output
%result = Eq2Implementation(src, masked);
%subplot(2,2,4)
%imshow(result);
%title('Result');
imwrite(result, 'resultT2.jpg');
