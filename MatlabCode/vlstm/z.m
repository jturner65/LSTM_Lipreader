a = load('all_training_examples.mat');
disp(size(a));
samples = a.A;
labels = a.B;

disp(size(samples));
disp(size(labels));
disp('--------------------------');
disp(labels(:,:,700));