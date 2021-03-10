function [ f1 ] = ExampleBasedF1Instance( ypred, ytruth )

    L = length(ytruth);
    tp = 0;
    fp = 0;
    fn = 0;
    
    for j = 1 : L
        if (ytruth(j) == 1 && ypred(j) == 1)
            tp = tp + 1;
        end
        if (ytruth(j) == 0 && ypred(j) == 1)
            fp = fp + 1;
        end
        if (ytruth(j) == 1 && ypred(j) == 0)
            fn = fn + 1;
        end
    end
    
    f1 = CalFMeasure(tp, fp, fn, 1);

end

