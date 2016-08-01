clc();

load('\\Mac\Home\Desktop\patient_6\tumor_mask_6.mat');
load('\\Mac\Home\Desktop\patient_6\original_6.mat');

pick = [4,6,8,10,12,14,16,18,20,22];
%init training data to null
y_train_full =[];
training_input =zeros(7,(10*144*144));
h = fspecial('average', [5 5]);

%num =base;
%k represents which training image to take
for k=1:10;
    
 %img_train = original_img_all(:,:,pick(1,k));
 img_train = filter2(h, original_img_all(:,:,pick(1,k)));    
  

 %init dimensions
 numrows = size(img_train,1);
 numcolumns = size(img_train,2);

 %segmet the image
 img_train_segmented = modksegment(img_train,2);

 %segmented image with image's original texture
 img_train_textured = img_train.*img_train_segmented;
 
 max_int = max(img_train_textured(:));
 
img_train_textured = (img_train_textured/max_int);

 %getting features from glcm (the first four features)
 
 vec_glcm = getfeatures(img_train_textured);
 disp(k);
 vec_glcm'

 
 
 %calc input matrix for training
 
 %NOTE the indexing is column wise, because when the marked output mask image is vectorised
 %it will follow column first ordering to vectorise 
 
 
 for j=1:numcolumns;
     for i=1:numrows;
         %extending the features to include intensity and position
         vec_train = [vec_glcm;img_train_textured(i,j);i;j];
         
         %updating the training input with current feature vector
         %NOTE in our neural network every column represents a pixel's
         %feture vector and training vector is grown with each column
         training_input(:,(k-1)*numrows*numcolumns + (j-1)*numrows + i) = vec_train;
     end
 end
 %this image's pixel's training vectors added to training input

 %now appending the marked tumor mask pixels 
 y_train = tumor_mask(:,:,pick(1,k));
 
 %NOTE the vectorisation is column first basis
 y_train = y_train(:);
 
 %appending to y_train_full this image's output set
 y_train_full = [y_train_full;y_train];
 
 %as taking alternate images for training

 
end

y_train_full = y_train_full';

disp('data populated , training started');
%neural network with logistic regression
net = newpr(training_input, y_train_full, 2);
net.divideFcn = '';
net.trainParam.epochs=200;
%training
net = init(net);
[net,tr] = train( net, training_input, y_train_full);
disp('training done');

%TRAINING DONE ------------------- 
 
%predicting 
disp('prediction started');
error_all=[];
test = [5,7,9,11,13,15,17,19,21];
for m=1:9;
 img_test = filter2(h, original_img_all(:,:,test(1,m))); 
 %img_test = original_img_all(:,:,test(1,m));
 
 %segmenting
 img_test_segmented = modksegment(img_test,2);
 
 %texture
 img_test = img_test.*img_test_segmented;
 max_int = max(img_test(:));
 img_test = (img_test/max_int);
 
 figure(100+test(1,m));imagesc(original_img_all(:,:,test(1,m)));
 figure(200+test(1,m));imagesc(img_test);
 figure(300+test(1,m));imagesc(tumor_mask(:,:,test(1,m)));

 test_vec = getfeatures(img_test);
 disp(m);
 test_vec_glcm = test_vec'

 for i=1:numrows;
   for j=1:numcolumns;
     test_vec_extended = [test_vec;img_test(i,j);i;j];
     %disp('updated test_vec');
     %size(test_vec)
     prediction = sim(net, test_vec_extended);
     if prediction >= 0.9
      img_test(i,j)= 1;
     else 
      img_test(i,j) = 0;
     end 
   end
 end
 figure(400+test(1,m));imagesc(img_test);
 disp(test(1,m));
 %error = geterror(tumor_mask(:,:,test(1,m)),img_test)
 err = geterror(tumor_mask(:,:,test(1,m)),img_test);
 error_all(1,m)=err;
 
end
error_all
total_error = sum(error_all(:))
avg_error = total_error/9
