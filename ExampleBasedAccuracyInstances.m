function [ accuracy ] = ExampleBasedAccuracyInstances( Ypred, YTruth )
%P_ACCURACY Jaccard Index for a set of instances 
%           often simply called multi-label 'accuracy'. Multi-label only.

    N = size(YTruth, 1);
    accuracy = 0;
    for i = 1 : N
        accuracy = accuracy + ExampleBasedAccuracyInstance(Ypred(i, :), YTruth(i, :));
    end
    
    accuracy = accuracy / N;
end

