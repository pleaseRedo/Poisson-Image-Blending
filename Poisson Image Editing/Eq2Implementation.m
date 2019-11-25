function result = Eq2Implementation(src, masked)

% For debugging use
[num_row_src ,num_col_src] = size(src);
[num_row_msk ,num_col_msk] = size(masked);

src = double(src);
num_omg = size(find(masked == 1),1);
B = zeros(num_omg,1);  

% The number of non-zero elements is num_omg * 5
% Under the most exteam case, centre pixels with its neighbours are all 0s
% So maximum num_omg*5 non-zero elements in our sparse matrix.
A = sparse(num_omg, num_omg, num_omg * 5,num_omg,num_omg); 
V_pq = 0; % For task 1, it is always 0.

mask = double(masked);



paddedmsk = padarray(masked, [1,1]) ;
temp = zeros([num_row_src ,num_col_src]);
n = 0;
for i = 1:num_row_src
    for j = 1:num_col_src
        if mask(i, j) > 0            
               
            n = n + 1;
            if mask(i,j-1) == 1
                temp(i,j-1) = - 1;
                %n = n + 1;
                
            else
                % at boundary

                B(n) = B(n) + src(i, j-1);
               
            end        

            if mask(i-1,j) == 1
                temp(i-1,j) = - 1;
                %n = n + 1;
                
            else
                % at boundary

                B(n) = B(n) + src(i-1, j);
            end  

            if mask(i,j+1) == 1
                temp(i,j+1) = - 1;
            else
                % at boundary
                B(n) = B(n) +src(i, j+1);
            end          

            if mask(i+1,j) == 1
                temp(i+1,j) = - 1;                 
            else
                % at boundary
                B(n) = B(n) +src(i+1, j);
            end  
            B(n) = B(n) + V_pq;  
        end
                        
    end
       
end

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
%AA = zeros(num_omg,num_omg);
% for i = 1:num_row_src
%     for j = 1:num_col_src
%         if temp(i,j) == -1;
%             rowwise = rowwise + 1;          
%             A(rowwise,columnwise(i,j)) = temp(i,j);
%             A(rowwise,rowwise) = 4;  
%         end
%           
%     end
%     
% end

%A = zeros(num_omg,num_omg);

for i = 1:num_row_src
    for j = 1:num_col_src
        if mask(i, j) > 0            
               
            rowwise = rowwise + 1;
            if mask(i,j-1) == 1
                A(rowwise, columnwise(i,j-1)) = -1;
            end        

            if mask(i-1,j) == 1
                A(rowwise, columnwise(i-1,j)) = -1;

            end  

            if mask(i,j+1) == 1
                A(rowwise, columnwise(i,j+1)) = -1;
            end          
            if mask(i+1,j) == 1
                A(rowwise, columnwise(i+1,j)) = -1;                
            end  
            A(rowwise,rowwise) = 4;
        end
                        
    end
       
end

X = A\B;

result = src;

count=0;
% Mapping from 1d to 2d to get the result img back;
for i = 1:num_row_src
    for j = 1:num_col_src
        if mask(i, j) >0
            count = count + 1;
            result(i, j) = X(count);
        end
    end
end