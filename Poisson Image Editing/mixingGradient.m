function result = mixingGradient(src, masked,tgt,tgt_mask,targetLocation)

% For debugging use
%masked = srcMask;

%%%%%%%%%%%%%
% src = src_B;
% tgt = tgt_B;



%%%%%%%%%%%%%%
[num_row_src ,num_col_src] = size(src);
[num_row_msk ,num_col_msk] = size(masked);
[num_row_tgt ,num_col_tgt] = size(tgt);
%src = double(src);
%tgt = double(tgt);
num_omg = size(find(masked == 1),1);
B = zeros(num_omg,1);  
[r,c] = find(masked == 1); % Get index for mask
% The number of non-zero elements is num_omg * 5
% Under the most exteam case, centre pixels with its neighbours are all 0s
% So maximum num_omg*5 non-zero elements in our sparse matrix.
A = sparse(num_omg, num_omg, num_omg * 5); 
V_pq = 0; % For task 1, it is always 0.

mask = double(masked);
laplacian_filter = [0 1 0; 1 -4 1; 0 1 0]; % Crate the laplacian filter for conv
gradient_src = conv2(src, -laplacian_filter, 'same');
%paddedmsk = padarray(masked, [1,1]) ;
temp = zeros([num_row_src ,num_col_src]);
n = 0;
% for i = 1:num_row_src
%     for j = 1:num_col_src
%         if mask(i, j) > 0            
%             V_pq = gradient_src(i,j);
%             n = n + 1;
%             if mask(i,j-1) == 1
%                 temp(i,j-1) = - 1;
%                 %n = n + 1;
%                 
%             else
%                 % at boundary
%                 B(n) = B(n) + tgt(i+targetLocation(1)-min(r), j-1+targetLocation(2)-min(c));
%                 
%             end        
% 
%             if mask(i-1,j) == 1
%                 temp(i-1,j) = - 1;
%                 %n = n + 1;
%                 
%             else
%                 % at boundary
% 
%                 B(n) = B(n) + tgt(i-1+targetLocation(1)-min(r), j+targetLocation(2)-min(c));
%             end  
% 
%             if mask(i,j+1) == 1
%                 temp(i,j+1) = - 1;
%             else
%                 % at boundary
%                 B(n) = B(n) +tgt(i+targetLocation(1)-min(r), j+1+targetLocation(2)-min(c));
%             end          
% 
%             if mask(i+1,j) == 1
%                 temp(i+1,j) = - 1;                 
%             else
%                 % at boundary
%                 B(n) = B(n) +tgt(i+1+targetLocation(1)-min(r), j+targetLocation(2)-min(c));
%             end  
%             
%             %To compute the V_pq for mixing gradient we need to find the
%             %derivatives: Following the equation(12):
%             f_star =tgt(i+targetLocation(1)-min(r), j+targetLocation(2)-min(c)) - tgt(i+targetLocation(1)-min(r), j-1+targetLocation(2)-min(c));
%             g      = src(i,j) - src(i,j-1);
%             if abs(f_star) > abs(g)
%                 V_pq = V_pq + f_star;
%             else
%                 V_pq = V_pq + g;
%             end
%             f_star =tgt(i+targetLocation(1)-min(r), j+targetLocation(2)-min(c)) - tgt(i-1+targetLocation(1)-min(r), j+targetLocation(2)-min(c));
%             g      = src(i,j) - src(i-1,j);
%             if abs(f_star) > abs(g)
%                 V_pq = V_pq + f_star;
%             else
%                 V_pq = V_pq + g;
%             end
%             f_star =tgt(i+targetLocation(1)-min(r), j+targetLocation(2)-min(c)) - tgt(i+targetLocation(1)-min(r), j+1+targetLocation(2)-min(c));
%             g      = src(i,j) - src(i,j+1);
%             if abs(f_star) > abs(g)            
%                 V_pq = V_pq + g;
%             else
%                 V_pq = V_pq + g;
%             end
%             f_star =tgt(i+targetLocation(1)-min(r), j+targetLocation(2)-min(c)) - tgt(i+1+targetLocation(1)-min(r), j+targetLocation(2)-min(c));
%             g      = src(i,j) - src(i+1,j);            
%             if abs(f_star) > abs(g) 
%                 V_pq = V_pq + g;
%             else
%                 V_pq = V_pq + g;
%             end
% 
%             B(n) = B(n) + V_pq;  
%         end
%                         
%     end
%        
% end

columnwise = zeros(num_row_msk, num_col_msk);
count = 0;
for i = 1:num_row_msk
    for j = 1:num_col_msk
        if masked(i, j) >0
           count = count + 1;          
           columnwise(i, j) = count;        
        end
    end
end

rowwise = 0;


% for i = 1:num_row_src
%     for j = 1:num_col_src
%         if mask(i, j) > 0            
%                
%             rowwise = rowwise + 1;
%             if mask(i,j-1) == 1
%                 A(rowwise, columnwise(i,j-1)) = -1;
%             end        
% 
%             if mask(i-1,j) == 1
%                 A(rowwise, columnwise(i-1,j)) = -1;
% 
%             end  
% 
%             if mask(i,j+1) == 1
%                 A(rowwise, columnwise(i,j+1)) = -1;
%             end          
%             if mask(i+1,j) == 1
%                 A(rowwise, columnwise(i+1,j)) = -1;                
%             end  
%             A(rowwise,rowwise) = 4;
%         end
%                         
%     end
%        
% end


for i = 1:num_row_src
    for j = 1:num_col_src
        if mask(i, j) > 0            
            x = i+targetLocation(1)-min(r);
            y = j+targetLocation(2)-min(c);
            n = n + 1;
            if mask(i-1,j) > 0
                %temp(i,j-1) = - 1;
                temp = columnwise(i-1,j);
                A(n,temp) = -1;
                %n = n + 1;
                
            else
                % at boundary
                B(n) = B(n) + tgt(x-1, y);
                
            end        

            if mask(i+1,j) > 0
                temp = columnwise(i+1,j);
                %n = n + 1;
                A(n,temp) = -1;
            else
                % at boundary

                B(n) = B(n) + tgt(x+1, y);
            end  

            if mask(i,j-1) > 0
                temp = columnwise(i,j-1);
                A(n,temp) = -1;
            else
                % at boundary
                B(n) = B(n) + tgt(x, y-1);
            end          

            if mask(i,j+1) > 0
                temp = columnwise(i,j+1);  
                A(n,temp) = -1;
            else
                % at boundary
                B(n) = B(n) + tgt(x, y+1);
            end  
            A(n,n)=4;
            
            %To compute the V_pq for mixing gradient we need to find the
            %derivatives: Following the equation(12):
            f_star1 = tgt(x, y) - tgt(x-1, y);
            g1      = src(i,j) - src(i-1,j);
            f_star2 = tgt(x, y) - tgt(x+1, y);
            g2      = src(i,j) - src(i+1,j);
            f_star3 = tgt(x, y) - tgt(x, y-1);
            g3      = src(i,j) - src(i,j-1);
            f_star4 = tgt(x, y) - tgt(x, y+1);
            g4      = src(i,j) - src(i,j+1);  
            V_pq = 0;
            if abs(f_star1) > abs(g1)
                V_pq = V_pq + f_star1;
            else
                V_pq = V_pq + g1;
            end

            if abs(f_star2) > abs(g2)
                V_pq = V_pq + f_star2;
            else
                V_pq = V_pq + g2;
            end

            if abs(f_star3) > abs(g3)            
                V_pq = V_pq + f_star3;
            else
                V_pq = V_pq + g3;
            end
          
            if abs(f_star4) > abs(g4) 
                V_pq = V_pq + f_star4;
            else
                V_pq = V_pq + g4;
            end

             B(n) = B(n) + V_pq;  
        end
                        
    end
       
end

X = A\B;

result = tgt;

count=0;
% Mapping from 1d to 2d to get the result img back;
for i = 1:num_row_tgt
    for j = 1:num_col_tgt
        if tgt_mask(i, j) >0
            count = count + 1;
            result(i, j) = X(count);
        end
    end
end
imshow(result)
end