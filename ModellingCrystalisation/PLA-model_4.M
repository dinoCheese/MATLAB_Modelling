arraySize = 80; %size of the array (n x n) array. 
finished = 0; %variable to check whether the array has been filled, for termination
rateOfNucleation = 10; %amount of nucleus's  
probNucleation = zeros(arraySize); %the probability of nucleation. 
probNucleation(1:arraySize, 1:arraySize) = rateOfNucleation/(arraySize*arraySize);  
growthRate = 1;


 %array to contain coordinates of the nuclei as well as the radius. 
X = zeros(arraySize, arraySize); %the array where the nucleation will be displayed.  
nCount = 0; %count for the amount of nuclei
t = 0; %the total iterations 


%movie stuff
fig=figure(1);
winsize = get(fig,'Position');
winsize(1:2) = [0 0];
%set(fig,'NextPlot','replacechildren','WindowButtonMotionFcn', @mouseMove);
set(fig,'NextPlot','replacechildren');
cumSum = zeros(arraySize/2, 1); 
N = []; 
but = 1; 


%temperature stuff
B = 0.99; %coefficient of heat transfer
reps = 10; %control speed of heat flow
Z = 0.65; %zeldovich whatsit
Bc = 1; %transport coefficieint
Nx = 1; %number available sites
G = 0.1; %activation energy
%k = 1.3806488*10^(-23); %boltzmann constant
k = 0.6*(10^(-3)); %a better boltzmann constant


maxTemp = 400;
minTemp = 220;


heatArray = zeros(arraySize+2, arraySize+2, 3);
heatArray(2:arraySize+1, 2:arraySize+1, 2) = 0.2;


for i = 1:arraySize+2
   heatArray(i,arraySize+2,2) = 0.4;
   heatArray(i,1,2) = 0.4;
end



for j = 1:arraySize+2
  heatArray(1,j,2) = 0.4;
   heatArray(arraySize+2,j,2) = 0.4;
end


tmp = heatArray;



while ~(finished) %terminate when finished
    %only go to this step if there are actually nuclei. 
       
       
       for i = 1:arraySize
           for j = 1:arraySize     
               if(~X(i, j)) % if the cell is not occupied.                  
                                  
                %prob = Z*Bc*Nx*exp( -G \ (k * ( heatArray(i+1, j+1, 2)*(maxTemp-minTemp) + minTemp )) );
                 prob = 0.000015;                 
                   if (rand < prob) 
                       prob;
                       N = [N; [i,j,1]]; 
                       nCount = nCount + 1; 
                   end
                   
                   if (nCount > 0)
                       %creates a vector containing the different distances to the nuclei and that point, if there are no nucleus, the distance is INF. 
                       
                       %periodic boundary
                       %distToNucleus = sqrt(min(i - N(:, 1), arraySize - (i - N(:, 1))).^2 + min(j - N(:, 2), arraySize - (j - N(:, 2))).^2); 
                       
                       %stupid rhombuses
                       %distToNucleus = abs(i - N(:, 1)) + abs(j - N(:, 2));
                       
                       %circles with no boundary
                       distToNucleus = sqrt((i - N(:, 1)).^2 + (j - N(:, 2)).^2);
                       
                       boolDist = distToNucleus < N(:, 3); %creates a boolean vector, 1s appear if the distance from that point to a nucleus is smaller then the radius of the nucleus. 
                       k = find(boolDist==1, 1 ); %finds the index of the first one in the boolean vector (this applies a kind of bias in the selection)
                       
                       if (~isempty(k)) %check that the k index is actually a number. 
                           X(i, j) = (k/nCount)*64; %set it to the values of the index, divided by the total amount of nucleus, and mapped so that it ranges over all the colors of the rainbow. 
                       end
                       
                   end
               end
           end
       end 
       
       if(nCount) 
           %N(:, 3) = N(:, 3) + 1; %increases the size of the nuclei by one. (inf + 1 = inf) 
           for L = 1:nCount
               %will make growthRate a function of: heatArray(N(L, 1)+1, N(L, 2)+1)) 
               %ie. i, j indices of nucleus (+1 to correspond to heat array)
               N(L, 3) = N(L, 3) + growthRate; 
           end
       end
       t = t+1; %increment the time step
       cumSum(t) = 1 - sum(sum(~X))/(arraySize*arraySize); %array showing the fractional area increase over time steps 
   
       if (cumSum(t) == 1) 
           finished = 1; 
       end        
     
       subplot(2, 2, [1:2]); 
       plot(cumSum, 'b--o'); 
       subplot(2, 2, 3);
       map = colormap(bone);
       imshow(X, map);
       subplot(2,2,4);
       imshow(heatArray(2:arraySize+1, 2:arraySize+1, 1:3));
       mov(:,t)=getframe(fig); 
       
       %update temperatures
       for k = 1:reps
         for i = 2:arraySize+1
           for j = 2:arraySize+1
               total = 0.18*(heatArray(i,j+1, 2) + heatArray(i,j-1, 2) + heatArray(i+1,j,2) + heatArray(i-1,j,2) - 4*heatArray(i,j,2));  
               total = total + 0.07*(heatArray(i-1,j-1, 2) + heatArray(i+1,j-1, 2) + heatArray(i-1,j+1,2) + heatArray(i+1,j+1,2) - 4*heatArray(i,j,2));
               tmp(i,j,2) = heatArray(i,j,2) + B*total;         
           end
         end
        heatArray=tmp;
        heatArray(:,:,2);
        
       end
   
end


movie2avi(mov, 'crystalsandthat.avi');
