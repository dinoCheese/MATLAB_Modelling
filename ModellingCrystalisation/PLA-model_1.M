arraySize = 300;
timeSteps = 70;
numSites = 10;


X = zeros(arraySize); %array to hold everything


storeX = zeros(numSites, size(X,1)*size(X,2)); %array for x-value storage
storeY = zeros(numSites, size(X,1)*size(X,2)); %array for y-value storage
countX = zeros(numSites, 1); %vector to store x counts
countY = zeros(numSites, 1); %vector to store y counts
siteColors = zeros(1, numSites); % vector to hold colors representing different nucleation sites



for bubbaGumpShrimp = 1 : numSites
   siteColors(1, bubbaGumpShrimp) = (1/numSites)*bubbaGumpShrimp;
end


for necrotizingFasciitis = 1 : numSites
   X(randi([1, arraySize]), randi([1, arraySize])) = siteColors(1, necrotizingFasciitis);
end


% movie stuf, might not be used
fig=figure(1);
winsize = get(fig,'Position');
winsize(1:2) = [0 0];
set(fig,'NextPlot','replacechildren');
mov=moviein(length(timeSteps),fig,winsize);



for t = 1 : timeSteps


   for k = 1: numSites
       countX(k) = 1;
       countY(k) = 1; 
   end


for m = 1:numSites    
   for i = 1: size(X,1)
       for j = 1: size(X,2)        
         
         if X(i,j) == siteColors(1, m)
           
            if i < size(X,1)
              storeX(m, countX(m, 1)) = i+1;
              countX(m, 1) = countX(m, 1) + 1;
              storeY(m, countY(m, 1)) = j;
              countY(m, 1) = countY(m, 1) + 1;               
            end
           
            if i > 1
              storeX(m, countX(m, 1)) = i-1;
              countX(m, 1) = countX(m, 1) + 1;
              storeY(m, countY(m, 1)) = j;
              countY(m, 1) = countY(m, 1) + 1;        
            end
           
            if j < size(X,2)
              storeX(m, countX(m, 1)) = i;
              countX(m, 1) = countX(m, 1) + 1;
              storeY(m, countY(m, 1)) = j+1;
              countY(m, 1) = countY(m, 1) + 1;                 
            end
           
            if j > 1
              storeX(m, countX(m, 1)) = i;
              countX(m, 1) = countX(m, 1) + 1;
              storeY(m, countY(m, 1)) = j-1;
              countY(m, 1) = countY(m, 1) + 1;   
            end
           
         end
         
       end
   end
end


for m = 1 : numSites
  
   for x = 1 : size(storeX , 2) %update the matrix
       
       if storeX(m, x) ~= 0 
           if storeY(m, x) ~= 0            
            
              if X(storeX(m, x),storeY(m, x)) == 0
                 X(storeX(m, x),storeY(m, x)) = siteColors(m);
              end
            
           end
       end
     
   end
      
end   
   
imshow(X);  
mov(:,t)=getframe(fig); 
   
end
X;
