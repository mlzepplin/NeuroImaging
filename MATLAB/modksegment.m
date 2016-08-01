function img_segmented = modksegment(img_test,k)
 [kidx,C] = kmeans(img_test(:), k, 'start','uniform', 'emptyaction','singleton');
 clustermeans = accumarray(kidx, img_test(:),[], @mean);
 [sortedmeans, sortidx] = sort(clustermeans); 
 kidxmapped = sortidx(kidx);
 dim = size(kidxmapped);
 %minimum_intensity = min(kidxmapped);
 %|| (kidxmapped(z,1)==(k-1))
 for z=1:dim(:,1);
     if (kidxmapped(z,1)== k)  
        kidxmapped(z,1)=1;
     else
        kidxmapped(z,1)=0;
     end
 end
 img_segmented = reshape(kidxmapped, size(img_test));
end