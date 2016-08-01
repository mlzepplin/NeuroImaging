function img_segmented = modksegmentold(img_test,k)
 [kidx,C] = kmeans(img_test(:), k, 'start','uniform', 'emptyaction','singleton');
 clustermeans = accumarray(kidx, img_test(kidx),[], @mean);
 [sortedmeans, sortidx] = sort(clustermeans); 
 kidxmapped = sortidx(kidx);
 dim = size(kidxmapped);
 count_min = 0;
 count_max = 0;
 minimum_intensity = min(kidxmapped);
 for z=1:dim(:,1);
     if kidxmapped(z,1)== minimum_intensity
         count_min = count_min + 1;
     else
         count_max = count_max + 1;
     end
 end
 
 if count_min>count_max
     for z=1:dim(:,1);
      if kidxmapped(z,1)== minimum_intensity
         kidxmapped(z,1)= 0;
      else
         kidxmapped(z,1)= 1;
      end
     end
 else 
     for z=1:dim(:,1);
      if kidxmapped(z,1)== minimum_intensity
         kidxmapped(z,1)= 1;
      else
         kidxmapped(z,1)= 0;
      end
     end
 end
 img_segmented = reshape(kidxmapped, size(img_test));
end