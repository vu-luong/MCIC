function [ f1 ] = ExampleBasedF1Instances( Ypred, YTruth )

    N = size(YTruth, 1);
    f1 = 0;
    for i = 1 : N
        f1 = f1 + ExampleBasedF1Instance(Ypred(i, :), YTruth(i, :));
    end
    
    f1 = f1 / N;
end