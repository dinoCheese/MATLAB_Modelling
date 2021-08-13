arraySize = 400; %size of the array (n x n) array. 
finished = 0; %variable to check whether the array has been filled, for termination
probNucleation = 0.3; %the probability of nucleation. 


N = zeros((arraySize)/2, 3);  %array to contain coordinates of the nuclei as well as the radius. 
X = zeros(arraySize, arraySize); %the array where the nucleation will be displayed. 
N = 1./N; %changes the nuclei array from full zeros to INF values. 
nCount = 0; %count for the amount of nuclei
t = 0; %the total iterations 


%movie stuff
fig=figure(1);
winsize = get(fig,'Position');
winsize(1:2) = [0 0];
set(fig,'NextPlot','replacechildren');
cumSum = zeros(arraySize/2, 1); 


while ~(finished) %terminate when finished
   if (rand > probNucleation && nCount <= (arraySize)/2 ) %makes a new nucleus with radius 1, if the conditions are met. 
       
       nCount = nCount + 1; 
       N(nCount, 1:2) = randi(arraySize, [1, 2]); %x and y coordinates. 
       N(nCount, 3) = 1; %radius
   end
   if (nCount > 0 ) %only go to this step if there are actually nuclei. 
       for i = 1:arraySize
           for j = 1:arraySize     
               if(~X(i, j)) % if the cell is not occupied. 
                   distToNucleus = sqrt((i - N(:, 1)).^2 + (j - N(:, 2)).^2); %creates a vector containing the different distances to the nuclei and that point, if there are no nucleus, the distance is INF. 
                   boolDist = distToNucleus < N(:, 3); %creates a boolean vector, 1s appear if the distance from that point to a nucleus is smaller then the radius of the nucleus. 
                   k = find(boolDist==1, 1 ); %finds the index of the first one in the boolean vector (this applies a kind of bias in the selection)
                   if (~isempty(k)) %check that the k index is actually a number. 
                       X(i, j) = (k/nCount)*64; %set it to the values of the index, divided by the total amount of nucleus, and mapped so that it ranges over all the colors of the rainbow. 
                   end
               end
           end
       end 
   end
   
   
   if (sum(sum(~X)) == 0)  %if the array is full, then finished is true.
       finished = 1; 
   end
   
   
   
   N(:, 3) = N(:, 3) + 1; %increases the size of the nuclei by one. (inf + 1 = inf) 
   t = t+1; %increment the time step
   cumSum(t) = 1 - sum(sum(~X))/(arraySize*arraySize); %array showing the fractional area increase over time steps 
    
   subplot(1, 2, 1); 
   plot(cumSum, 'b--o'); 
   subplot(1, 2, 2);
   map = colormap(bone);
   imshow(X, map);
   mov(:,t)=getframe(fig); 
end


%movie2avi(mov, 'hirescrystal2.avi');


