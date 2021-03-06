clc();


%{
for i=18:44
    figure(100+i);imagesc(tumor_mask(:,:,i));
    figure(200+i);imagesc(normal_mask.img(:,:,i));
    figure(i);imagesc(original_img_all(:,:,i));
end
%}

%base = 19;
%limit = 43;
%init training data to null
y_train_full =[];
training_input =zeros(18,(51*144*144));
original_all = zeros(144,144,51);
tumor_all = zeros(144,144,51);
test_img_all = zeros(144,144,51);
test_tumor_all = zeros(144,144,51);

%filter for mean smoothing
h = fspecial('average', [5 5]);

%patient 8

load('\\Mac\Home\Desktop\patient_p8\tumor-mask-8.mat');
load('\\Mac\Home\Desktop\patient_p8\original-img.mat');

pick_8 = [19,21,23,25,27,29,31,33,35,37,39,41,43,47,49,51,53,55];
for z=1:18;
    %applying mean smoothing and adding to array
    img_smooth = filter2(h, original_img_all(:,:,pick_8(1,z)));    
    original_all(:,:,z) = img_smooth;
    tumor_all(:,:,z) = tumor_mask(:,:,pick_8(1,z));
end

test_8 = [20,22,24,26,28,30,32,34,36,38,40,42,46,48,50,52,54];
for w=1:17;
    img_smooth = filter2(h, original_img_all(:,:,test_8(1,w)));    
    test_img_all(:,:,w) = img_smooth;
    test_tumor_all(:,:,w)=tumor_mask(:,:,test_8(1,w));
end


%patient 1

load('\\Mac\Home\Desktop\patient_1\original_1.mat');
load('\\Mac\Home\Desktop\patient_1\tumor_mask_1.mat');
m=13;
for z=19:28;
    img_smooth = filter2(h,original_1(:,:,m));
    original_all(:,:,z) = img_smooth;
    tumor_all(:,:,z) = tumor_mask_1(:,:,m);
    m=m+2;
end
m=12;
for w=18:27;
    img_smooth = filter2(h,original_1(:,:,m));
    test_img_all(:,:,w) = img_smooth;
    test_tumor_all(:,:,w) = tumor_mask_1(:,:,m);
    m=m+2;
end


%patient 5

load('\\Mac\Home\Desktop\patient_5\tumor_mask_5.mat');
load('\\Mac\Home\Desktop\patient_5\original_5.mat');
m=7;
for z=29:42;
   img_smooth = filter2(h,original_1(:,:,m));
   original_all(:,:,z) = img_smooth;
   tumor_all(:,:,z) = tumor_mask_1(:,:,m);
   m=m+2;
end
m=6;
for w=28:41;
   img_smooth = filter2(h,original_1(:,:,m));
   test_img_all(:,:,w) = img_smooth;
   test_tumor_all(:,:,w) = tumor_mask_1(:,:,m);
   m=m+2;
end
    
%patient 6

load('\\Mac\Home\Desktop\patient_6\tumor_mask_6.mat');
load('\\Mac\Home\Desktop\patient_6\original_6.mat');
m=5;
for z=43:51;
    img_smooth = filter2(h,original_img_all(:,:,m));
   original_all(:,:,z) = img_smooth;
   tumor_all(:,:,z) = tumor_mask(:,:,m);
   m=m+2;
end
m=4;
for w=42:51;
    img_smooth = filter2(h,original_img_all(:,:,m));
   test_img_all(:,:,w) = img_smooth;
   test_tumor_all(:,:,w) = tumor_mask(:,:,m);
   m=m+2;
end

%num =base;
%k represents which training image to take
num_train = size(original_all,3);

for k=1:num_train;
    
    
 img_train = original_all(:,:,k);

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
 y_train = tumor_all(:,:,k);
 
 %NOTE the vectorisation is column first basis
 y_train = y_train(:);
 
 %appending to y_train_full this image's output set
 y_train_full = [y_train_full;y_train];
 
 %one training image populated

 
end

% DATA ACCUMULATION STAGE

y_train_full = y_train_full';

disp('data populated , training started');
%neural network with logistic regression
net = newpr(training_input, y_train_full, 12);
net.divideFcn = '';
net.trainParam.epochs=100;
%training
net = init(net);
[net,tr] = train( net, training_input, y_train_full);
disp('training done');

%TRAINING DONE ------------------- 
 
%predicting 




%-------------------
num_test = size(test_img_all,3);

disp('prediction started');
error_all = zeros(1,num_test);

for m=1:num_test;
 img_test = test_img_all(:,:,m);
 
 %segmenting
 img_test = modksegment(img_test,2);
 
 %texture
 img_test = img_test.*test_img_all(:,:,m);
 max_int = max(img_test(:));
 img_test = (img_test/max_int);
 
 %figure(100+m);imagesc(test_img_all(:,:,m));
 %figure(200+m);imagesc(img_test);
 %figure(300+m);imagesc(test_tumor_all(:,:,m));

 test_vec = getfeatures(img_test);
 

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
 figure(m);imagesc(img_test);
 disp(m);
 err = geterror(test_tumor_all(:,:,m),img_test)
 error_all(1,m)=err;
 
end

error_all
total_error = sum(error_all(:))
avg_error = total_error/num_test