addpath data/trainingData/

s1=[];
s2=[];
s3=[];
s4=[];
l1=[];
l2=[];
l3=[];
l4=[];

files = dir('data/trainingData/*.mat');
count = 1;
split = 0;
for file = files'
    count = 1;
    temp_mat = load(file.name);
    disp(file.name);
    
    sample = temp_mat.trainRes;
    label = temp_mat.classRes;
    start_idx = size(sample, 3) - 10;
    end_idx = size(sample, 3);
    
    while (count+4) < end_idx
        s1 = cat(3, s1, sample(:, :, count));
        l1 = cat(3, l1, label(:, :, count)); 
        count=count+1;
        s2 = cat(3, s2, sample(:, :, count));
        l2 = cat(3, l2, label(:, :, count)); 
        count=count+1;
        s3 = cat(3, s3, sample(:, :, count));
        l3 = cat(3, l3, label(:, :, count)); 
        count=count+1;
        s4 = cat(3, s4, sample(:, :, count));
        l4 = cat(3, l4, label(:, :, count)); 
        count=count+1;
    end  
    
    
end
samples=s1;
labels=l1;
save(strcat('all_training_1.mat'), 'samples', 'labels', '-v7.3');
samples=s2;
labels=l2;
save(strcat('all_training_2.mat'), 'samples', 'labels', '-v7.3');
samples=s3;
labels=l3;
save(strcat('all_training_3.mat'), 'samples', 'labels', '-v7.3');
samples=s4;
labels=l4;
save(strcat('all_training_4.mat'), 'samples', 'labels', '-v7.3');














