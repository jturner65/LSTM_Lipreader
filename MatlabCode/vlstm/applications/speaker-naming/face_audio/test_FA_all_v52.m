addpath core/
addpath optimization/
addpath results/
addpath utils/
addpath data/

clearvars -global config;
global config mem;
gpuDevice(1);

load('results/speaker-naming/face_audio/pre-train.mat');
config = model;
lstm_init_v52();
config.weights = model.weights;
config.data_mean = model.data_mean;
config.one_over_data_std = model.one_over_data_std;


load('data/speaker-naming/raw_full/test/5classes/1');
% test_samples = test_samples(:,:,1:2000);
% test_labels = test_labels(:,1:2000);
test_labels = reshape(test_labels, size(test_labels,1), 1, size(test_labels,2));
test_labels = repmat(test_labels, [1 size(test_samples,2) 1]);
test_samples = config.NEW_MEM(test_samples);
test_labels = config.NEW_MEM(test_labels);
test_samples = bsxfun(@times, bsxfun(@minus, test_samples, config.data_mean), config.one_over_data_std);

load('data/speaker-naming/raw_full/test/5classes/6');
% outlier_test_samples = outlier_test_samples(:,:,1:2000);
% outlier_test_labels = outlier_test_labels(1:5,1:2000);
outlier_test_labels = reshape(outlier_test_labels, size(outlier_test_labels,1), 1, size(outlier_test_labels,2));
outlier_test_labels = repmat(outlier_test_labels, [1 size(outlier_test_samples,2) 1]);
outlier_test_samples = config.NEW_MEM(outlier_test_samples);
outlier_test_labels = config.NEW_MEM(outlier_test_labels);
outlier_test_samples = bsxfun(@times, bsxfun(@minus, outlier_test_samples, config.data_mean), config.one_over_data_std);


outlier_currect_num = 0;
outlier_thres = 10;
% outlier rejection acc
for ii = 1:size(outlier_test_samples, 3)/config.batch_size
    if(mod(ii*config.batch_size, 10000) == 0)
        fprintf('%d ', ii);
    end
    
    start_idx = config.batch_size * (ii-1) + 1;
    end_idx = start_idx + config.batch_size - 1;
    
    val_sample = outlier_test_samples(:,:,start_idx:end_idx);
    
    lstm_core_v52(val_sample, 1);
    
    [vv1, pos1] = max(mem.net_out(:,25:end,:,1));
    [vv2, pos2] = max(mem.net_out(:,25:end,:,2));
    tt = sum((pos1 == pos2));
    tt = reshape(tt, 1, config.batch_size);                    
    estimated_labels = zeros(1, config.batch_size);
    estimated_labels(tt < outlier_thres) = -1;                    
    true_labels = zeros(1, config.batch_size);
    true_labels = true_labels - 1;
    outlier_currect_num = outlier_currect_num + length(find(estimated_labels == true_labels));
end

outlier_acc = outlier_currect_num / size(test_samples, 3);
fprintf('\noutlier_acc: %.2f%%\n', outlier_acc*100);

correct_num = 0;
% test acc
for ii = 1:size(test_samples, 3)/config.batch_size
    if(mod(ii*config.batch_size, 10000) == 0)
        fprintf('%d ', ii);
    end
    start_idx = config.batch_size * (ii-1) + 1;
    end_idx = start_idx + config.batch_size - 1;
    
    val_sample = test_samples(:,:,start_idx:end_idx);
    val_label = test_labels(:,:,start_idx:end_idx);
    
    lstm_core_v52(val_sample, 1);
    
    [value, estimated_labels] = max(mem.net_out(:,end,:,1)+mem.net_out(:,end,:,2));
    [vv1, pos1] = max(mem.net_out(:,25:end,:,1));
    [vv2, pos2] = max(mem.net_out(:,25:end,:,2));
    tt = sum((pos1 == pos2));                    
    estimated_labels(tt < outlier_thres) = -1;
    [value, true_labels] = max(val_label(:,end,:));
    correct_num = correct_num + length(find(estimated_labels == true_labels));
    
end

acc = correct_num / size(test_samples, 3);
fprintf('\nval_acc: %.2f%%\n', acc*100);



