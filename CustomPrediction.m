function [ predictY, outputF ] = CustomPrediction(x, P_MC, O_MC, L, h, K)
    
    if (P_MC.num_of_micro_clusters() > 0)
        CK = P_MC.k_nearest_cluster(x, K);
    else 
        if (O_MC.num_of_micro_clusters() > 0) 
            CK = O_MC.k_nearest_cluster(x, K);
        else
            fprintf('Not 1st instance & no o-cluster & no p-cluster\n');
        end
    end
    
    numerator = zeros(1, L);
    denominator = 0;
    for i = 1 : numel(CK)
        P = CK{i}.get_P();
        w = CK{i}.get_weight();
        
        numerator = numerator + P * w;
        denominator = denominator + w;
    end

    outputF = numerator / denominator;
    [~, I] = sort(outputF, 'descend');

    predictY = zeros(1, L);
    for i = 1 : h
        predictY(I(i)) = 1;
    end
    
end

