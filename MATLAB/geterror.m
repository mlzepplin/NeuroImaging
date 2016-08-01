function err = geterror(original_mask,predicted_mask)
 err = 0;
 intersection=0;
 union=0;
 numrows = size(original_mask,1);
 numcolumns = size(original_mask,2);
 
 for i=1:numrows;
     for j=1:numcolumns;
       
       if original_mask(i,j)==1 || predicted_mask(i,j)==1  
         
           union = union +1;
           if original_mask(i,j)==1 && predicted_mask(i,j)==1
          
             intersection = intersection+1; 
           end
       end    
         
     end
 end
 err = 1-(intersection/union);
 
end