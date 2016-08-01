function stats_vec = getvoxelfeatures(glcm,x,y)
    %glcm = graycomatrix(img_x,'NumLevels',32);
    %window size taken to be 5*5
     dimension = size(glcm,1);
 
    if (x>=3) && (x<=dimension-2) && (y>=3) && (y<=dimension-2) 
        temp = glcm(x-2:x+2,y-2:y+2); 
        stats_struct = graycoprops(temp);
        stats_vec = [stats_struct.Contrast;stats_struct.Correlation;stats_struct.Energy;stats_struct.Homogeneity];
    else 
        stats_vec = [0;0;0;0];
    end
end