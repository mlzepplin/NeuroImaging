load('\\Mac\Home\Desktop\patient_1\original_1.mat');
load('\\Mac\Home\Desktop\patient_1\tumor_mask_1.mat');

load('\\Mac\Home\Desktop\patient_5\tumor_mask_5.mat');
load('\\Mac\Home\Desktop\patient_5\original_5.mat');

load('\\Mac\Home\Desktop\patient_6\tumor_mask_6.mat');
load('\\Mac\Home\Desktop\patient_6\original_6.mat');

for i=1:36;
    figure(i);imagesc(original_6(:,:,i));
    figure(100+i);imagesc(tumor_mask_6(:,:,i));
end
