function acc = getaccuracy(mask_original,mask_predicted)
 acc=0;
 for i=1:144;
     for j=1:144;
         if mask_original(i,j) == mask_predicted(i,j)
             acc = acc+1;
         end
     end
 end
 
 acc = 100*(acc/(144*144));

end