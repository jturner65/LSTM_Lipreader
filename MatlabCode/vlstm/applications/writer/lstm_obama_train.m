addpath core/
addpath utils/
addpath optimization/
addpath data/all_training/

clearvars -global config;
global config mem;
gpuDevice(1);

lstm_writer_configure();
lstm_init_v52();

count = 0;
cost_avg = 0;
epoc = 0;
points_seen = 0;
display_points = 1000;
save_points = 1000;

test = load('all_testing.mat');
test_samples = test.test_s;
test_labels = test.test_l;

fprintf('%s\n', datestr(now, 'dd-mm-yyyy HH:MM:SS FFF'));
for p = 1:1000
    %disp(p);
    for m = 1:4
        disp('m------------');
        disp(m);
        temp_mat = load(strcat('old_all_training_', num2str(m),'.mat'));
        sample_seq = temp_mat.samples; %temp_mat.imgSmallMat(1:1600, 1:4000);
        %sample_seq = reshape(sample_seq, 1600, 25, 160);
        num_of_seq = size(sample_seq, 3);
        
        label_seq = temp_mat.labels; %zeros(10, 25, 160);
%         for k = 1:160
%            r = mod(k, 10) + 1;
%            label_seq(r , :, k) = 1; 
%         end
        sample_seq = config.NEW_MEM(sample_seq);
        label_seq = config.NEW_MEM(label_seq);
        
        perm = randperm(size(sample_seq, 3));
        sample_seq = sample_seq(:,:,perm);
        label_seq = label_seq(:,:,perm);  
        
        
        for i = 1:size(sample_seq, 3)/config.batch_size 
            fprintf('\n%d .. %d', i, points_seen);
            points_seen = points_seen + config.batch_size;
            
            start_idx = (i-1) * config.batch_size + 1;
            end_idx = i * config.batch_size;
            in = sample_seq(:,:,start_idx:end_idx);
            label = label_seq(:,:,start_idx:end_idx);
% %             disp('----------------------');
% %             disp(size(in));
% %             disp(size(label));
            lstm_core_v52(in, label);
            
            if(cost_avg == 0)
                cost_avg = config.cost{1};
            else
                cost_avg = (cost_avg + config.cost{1}) / 2;
            end
            
            eta = config.learning_rate / (1 + points_seen*config.decay);
            adagrad_update(eta);
            
            % display point
            if(mod(points_seen, display_points) == 0)
                count = count + 1;
                fprintf('%d -----count-------', count);
            end
            
            % save point
            if(mod(points_seen, save_points) == 0)
                fprintf('\n%s', datestr(now, 'dd-mm-yyyy HH:MM:SS FFF'));
                epoc = epoc + 1;
                
                %***********************************************************************************                
                correct_num = 0;                
                train_correct_num = 0;
                for ii = 1:size(test_samples, 3)/config.batch_size
                    start_idx = config.batch_size * (ii-1) + 1;
                    end_idx = start_idx + config.batch_size - 1;

                    val_sample = test_samples(:,:,start_idx:end_idx);
                    val_label = test_labels(:,:,start_idx:end_idx);                    

                    lstm_core_v52(val_sample, 1);
                    
                    [value, estimated_labels] = max(mem.net_out(:,end,:));
                    [value, true_labels] = max(val_label(:,end,:));
%                     disp('-------------------------------');
%                     disp(estimated_label);
%                     disp('-------------------------------');

                    correct_num = correct_num + length(find(estimated_labels == true_labels));

                    val_sample = sample_seq(:,:,start_idx:end_idx);
                    val_label = label_seq(:,:,start_idx:end_idx);
                    
                    
                    lstm_core_v52(val_sample, 1);

                    for k=1:50
                        xx = sum(val_label(:,:,k), 2);             
                        [val true_label] = max(xx);
                        
                        xx = sum(mem.net_out(:,:,k), 2);             
                        [val estimated_label] = max(xx);
                        %fprintf('\nk==> %d, true_label: %d, estimated_label: %d\n', k, true_label, estimated_label);                       
                    end                    
                    [value, estimated_labels] = max(mem.net_out(:,end,:));
                    [value, true_labels] = max(val_label(:,end,:));
                    train_correct_num = train_correct_num + length(find(estimated_labels == true_labels));
                end
                
                acc = correct_num / size(test_samples, 3);
                train_acc = train_correct_num / size(test_samples, 3);
                fprintf('\nepoc %d, training avg cost: %f, acc: %.2f%%d', epoc, cost_avg, train_acc*100);
                
                %***********************************************************************************
                
                fprintf('\nepoc %d, training avg cost: %f\n', epoc, cost_avg);
                
                %lstm_writer_val();
                save_weights(strcat('results/writer/epoc', num2str(epoc), '.mat'));         
                cost_avg = 0;
            end
        end
    end
end
