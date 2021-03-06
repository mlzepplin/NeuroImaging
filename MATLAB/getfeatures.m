function stats_vec = getfeatures(img_x)
 %glcm features
    offsets = [0 5; -5 5;-5 0;-5 -5];
    glcms = graycomatrix(img_x,'NumLevels',64,'Offset',offsets);
    avg_contrast=0;
    avg_correlation=0;
    avg_energy=0;
    avg_homogeneity=0;
    for i=1:4;
        %current offset's stats
        stats_struct = graycoprops(glcms(:,:,i));
        avg_contrast= avg_contrast + stats_struct.Contrast;
        avg_correlation= avg_correlation + stats_struct.Correlation;
        avg_energy = avg_energy + stats_struct.Energy;
        avg_homogeneity= avg_homogeneity + stats_struct.Homogeneity;
    end
    stats_glcm = [(avg_contrast/4);(avg_correlation/4);(avg_energy/4);(avg_homogeneity/4)];
    
  %grey level run length matrix
    glrlms = grayrlmatrix(img_x,'NumLevels',64);
    stats_glrlm = grayrlprops(glrlms);
    stats_glrlm = (1/4)*sum(stats_glrlm);
    
    stats_vec = [stats_glcm;stats_glrlm'];
    
end