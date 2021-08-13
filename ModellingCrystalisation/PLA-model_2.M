arraySize  = 500; 
timeSteps  = 100; 
amountOfN = 10; 


X = zeros(arraySize); 
N = randi(arraySize, [amountOfN, 2]); 
%storage = zeros(size(X,1)*size(X,2), 4); 
%storageCount = 1; 
changeCount = 0; 
nEmpty = zeros(amountOfN, 1); 


fig=figure(1);
winsize = get(fig,'Position');
winsize(1:2) = [0 0];
set(fig,'NextPlot','replacechildren');
%mov=moviein(length(t),fig,winsize);


for t = 1:timeSteps 
   for k = 1:amountOfN
      if (nEmpty(k) == 1)
          continue;
      end
      
      changeCount = 0; 
       for i = N(k, 1) - t:N(k, 1) + t
         if (i < 1 || i > arraySize) 
             continue; 
         end


         for j = N(k, 2) - t:N(k, 2) + t 
             if (j < 1 || j > arraySize) 
               continue; 
             end
           
          % if isempty(find(storage(:, 3) == (arraySize*(i-1) + j), 1))
          if (X(i, j) == 0)
               if (pdist([i, j; N(k, 1), N(k, 2)], 'euclidean') < t)
                   %storage(storageCount, :) = [i, j, arraySize*(i-1) + j, k]; 
                   %storageCount = storageCount + 1; 
                   X(i, j) = k; 
                   changeCount = changeCount + 1; 
               end
            end   
           end
       end
       
       if (changeCount == 0)
           nEmpty(k) = 1; 
       end 
       
   end
   map = colormap(jet); 
   
   imshow(X, map);
   mov(:,t)=getframe(fig); 
   disp(t); 
end
