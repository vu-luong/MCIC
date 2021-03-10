function [ macro_f1 ] = MacroF1( Ypred, YTruth )

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

    macro_f1 = 0;
    for j = 1 : L
        f1 = CalFMeasure(truePositives(j), falsePositives(j), falseNegatives(j), 1);
        macro_f1 = macro_f1 + f1;
    end
    
    macro_f1 = macro_f1 / L;
    
end

