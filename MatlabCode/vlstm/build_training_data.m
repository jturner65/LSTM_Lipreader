addpath data/trainingData/

samples = [];
labels = [];
test_s = [];
test_l = [];

files = dir('data/trainingData/*.mat');
count = 1;
split = 0;
for file = files'
    temp_mat = load(file.name);
    disp(file.name);
    
    sample = temp_mat.trainRes;
    label = temp_mat.classRes;
    start_idx = size(sample, 3) - 10;
    end_idx = size(sample, 3);
    
    test_s = cat(3, test_s, sample(:, :, start_idx : end_idx));
    test_l = cat(3, test_l, label(:, :, start_idx : end_idx));
    sample = sample(:, :, 1: start_idx-1);
    label = label(:, :, 1: start_idx-1);
    
    disp('----------------------------------------------');
    samples = cat(3, samples, sample);
    disp(size(sample));
    disp(size(samples));
    disp('----------------------------------------------');
    disp('----------------------------------------------');
    labels = cat(3, labels, label);
    disp(size(label));
    disp(size(labels));
    disp('----------------------------------------------');
    disp('----------------------------------------------');
    if(mod(count, 8) == 0)
        split = split+1;
        save(strcat('all_training_', num2str(split),'.mat'), 'samples', 'labels', '-v7.3');
        %save(strcat('all_labels', num2str(split),'.mat'), 'labels', '-v7.3');
        samples = [];
        labels = [];
    end
    count = count + 1;
    
end

save(strcat('all_testing_', num2str(split),'.mat'), 'test_s', 'test_l', '-v7.3');