function [ micro_f1 ] = MicroF1( Ypred, YTruth )

    [N, L] = size(YTruth);
    truePositives = zeros(1, L);
    falseNegatives = zeros(1, L);
    falsePositives = zeros(1, L);
    trueNegatives = zeros(1, L);
    
    for i = 1 : N
        for j = 1 : L
            actual = YTruth(i, j);
            predicted = Ypred(i, j);
            
            if (actual == 1) 
                if (predicted == 1)
                    truePositives(j) = truePositives(j) + 1;
                else
                    falseNegatives(j) = falseNegatives(j) + 1;
                end
            else
                if (predicted == 1)
                    falsePositives(j) = falsePositives(j) + 1;
                else
                    trueNegatives(j) = trueNegatives(j) + 1;
                end
            end
        end
    end

    tp = 0;
    fp = 0;
    fn = 0;
    for j = 1 : L
        tp = tp + truePositives(j);
        fp = fp + falsePositives(j);
        fn = fn + falseNegatives(j);
    end
    
    micro_f1 = CalFMeasure(tp, fp, fn, 1);
end

