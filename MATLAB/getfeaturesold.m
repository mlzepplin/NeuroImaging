function stats_vec = getfeaturesold(img_x)
    glcm = graycomatrix(img_x,'NumLevels',256);
    stats_struct = graycoprops(glcm);
    stats_vec = [stats_struct.Contrast;stats_struct.Correlation;stats_struct.Energy;stats_struct.Homogeneity];
end