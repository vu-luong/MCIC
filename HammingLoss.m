function res=HammingLoss(Pre_Labels, test_target)
% Computing the hamming loss
% Pre_Labels: the predicted labels of the classifier, if the ith instance belong to the jth class, 
%   Pre_Labels(i, j)=1, otherwise Pre_Labels(i, j) = 0
% test_target: the actual labels of the test instances, if the ith instance belong to the jth class, 
%   test_target(i, j)=1, otherwise test_target(i, j) = 0

%   Convert to right format
    Pre_Labels(Pre_Labels == 0) = -1;
    Pre_Labels = Pre_Labels';
    
    test_target(test_target == 0) = -1;
    test_target = test_target';
%------------

    [num_class,num_instance]=size(Pre_Labels);
    miss_pairs=sum(sum(Pre_Labels~=test_target));
    res=miss_pairs/(num_class*num_instance);