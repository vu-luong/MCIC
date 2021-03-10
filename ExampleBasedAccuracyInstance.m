function [ accuracy ] = ExampleBasedAccuracyInstance( ypred, ytruth )
%P_ACCURACY Jaccard Index for one instance 
%           often simply called multi-label 'accuracy'. Multi-label only.

    L = length(ytruth);
    set_union = 0;
    set_inter = 0;
    
    for j = 1 : L
        if (ytruth(j) == 1 || ypred(j) == 1)
            set_union = set_union + 1;
        end
        if (ytruth(j) == 1 && ypred(j) == 1)
            set_inter = set_inter + 1;
        end
    end

    % = intersection / union; (or, if both sets are empty, then = 1.)
    if (set_union > 0)
        accuracy = set_inter / set_union;
    else
        accuracy = 1;
    end
end

