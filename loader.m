clear;
clc;

addpath('data');

file_list = {'ENRON-F'};

num_of_files = numel(file_list);
output_dir = 'result/';

if(~exist(output_dir,'dir'))
    mkdir(output_dir);
end

for i = 1 : num_of_files
    filename = file_list{i};
    fprintf('%s\n', filename);
    try
        load([filename '.mat']);
    catch
        fprintf('Could not load %s \n', filename);
    end
    
    X = D(:, L + 1: end); % All features of dataset
    Y = D(:, 1: L);     % Label set of dataset

    Classification(X, Y, filename, output_dir);
    
    fclose all;
end
