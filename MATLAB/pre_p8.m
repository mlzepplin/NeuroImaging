clc();
load('\\Mac\Home\Desktop\patient_p8\tumor-mask-8.mat');
load('\\Mac\Home\Desktop\patient_p8\normal_mask.mat');
load('\\Mac\Home\Desktop\patient_p8\original-img.mat');

%pick = [19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,46,47,48,49,50,51,52,53,54,55];
%init training data to null
load('\\Mac\Home\Desktop\patient_1\original_1.mat');
load('\\Mac\Home\Desktop\patient_1\tumor_mask_1.mat');



h = fspecial('average', [3 3]);
f = cell(20,1);

%num =base;
%k represents which training image to take
for k=12:31;
    
 %img_train = original_img_all(:,:,pick(1,k));
 img_train = filter2(h, original_1(:,:,k));    
  

 %init dimensions
 numrows = size(img_train,1);
 numcolumns = size(img_train,2);

 %segmet the image
 img_train_segmented = modksegment(img_train,2);

 
 %segmented image with image's original texture
 img_train_textured = img_train.*img_train_segmented;
 
 

  f{k} = strcat('p1_', num2str(k));
  f{k} = strcat(f{k},'.jpg');
 imwrite(img_train_textured,f{k});
 figure(400+k);imagesc(original_1(:,:,k));
 figure(k);imagesc(img_train_textured);
 
end
