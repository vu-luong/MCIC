function [] = Classification(X, Y, filename, output_dir)
    %% Init hyper-parameters
    delta = 0.1;
    K = 3;
    lambda = 0.25;
    processing_speed = 100;
    epsilon = 0.495;
    
    %% Init variables
    timestamp = 0;                  % Use to keep track current time
    current_timestamp = Timestamp();
    timestamp_view = TimestampView(current_timestamp); % Read-only view of the current time stamp
    
    [n, p] = size(X);       % n: #instances; p: #features
    [~, L] = size(Y);
    
    predictY = zeros(n - 1, L);
    outputF = zeros(n - 1, L);
    num_of_updates = 0;
    time = 0;                % Use to keep track the running time of this task
    
    %%
    beta_mu = 2;
    tp = round((1 / lambda) * log((beta_mu) / (beta_mu - 1))) + 1;
    xsi2 = 2^(-lambda * tp) - 1;
    P = MicroClusterList(); 
    O = MicroClusterList();

    num_of_pcluster = [];
    
    %%
    %--------------------------------------------------------------------------
    % BEGIN of the main algorithm
    %--------------------------------------------------------------------------
    tic
    cur_total_label = 0;
    mark_label = zeros(1, L);
    h = 5;
    t_instances = 0;
    
    for t = 1 : n
        x = X(t, :);
        y = Y(t, :);
        
        if (mod(t, 100) == 0)
            fprintf('#instace = %d\n', t);
        end
        
        if rem(t, processing_speed) == 0 % rem ~ mod
            timestamp = timestamp + 1;
            current_timestamp.set_time_stamp(timestamp);
        end

        %% Predict
        if (t > 1)
            [predictY(t - 1, :), outputF(t - 1, :)] = CustomPrediction(x, P, O, L, h, K);
        end

        %% Update

        % Update h
        t_instances = t_instances + 1;
        mark_label = or(mark_label, y);
        Lt = sum(mark_label);
        cur_total_label = cur_total_label + sum(y);
        zt = cur_total_label/t_instances;
        dt = zt / Lt;

        eps = sqrt( log(1 / delta) / (2 * t_instances));
        val = dt - h / Lt;

        if (val > eps || val < -eps)
            h = round(zt);
            cur_total_label = 0;
            mark_label = zeros(1, L);
            t_instances = 0;
        end

        update_yes = 0;

        %%% merging(x)
        % Try to merge x into cP
        merged = false;
        
        if (P.num_of_micro_clusters() > 0)
            cP = P.nearest_cluster(x);
            cP_copy = copy(cP);
            cP_copy.insert(x, y, t);
            if (cP_copy.get_radius() <= epsilon)
                cP.insert(x, y, t);
                merged = true;
                update_yes = 1;
            end
        end

        if (merged == false) && (O.num_of_micro_clusters() > 0)
            % Try to merge x into the nearest o-micro-cluster
            cO = O.nearest_cluster(x);
            cO_copy = copy(cO);
            cO_copy.insert(x, y, t);
            cO_save = copy(cO);

            if (cO_copy.get_radius() <= epsilon)  
                cO.insert(x, y, t);
                merged = true;
                
                % o-cluster turn into p-cluster
                if (cO.get_weight() > beta_mu)   
                    O.remove(cO);          
                    P.add(cO_copy);
                end
                update_yes = 1;
            end                
        end
        if (merged == false)
            % Create a new o-micro-cluster by x and insert it to O
            o_micro_cluster = MicroCluster(x, y, timestamp, lambda, timestamp_view, t);
            O.add(o_micro_cluster);
            update_yes = 1;
        end
        % Periodic cluster removal    
        if rem(timestamp, tp) == 0
            removed = P.periodic_removal_of_p_micro_clusters(beta_mu); 
            if removed == 1
                update_yes = 1;
            end


            removed = O.periodic_removal_of_o_micro_clusters(xsi2, tp, timestamp, lambda);
            if removed == 1
                update_yes = 1;
            end

        end
        num_of_updates = num_of_updates + update_yes;
        num_of_pcluster(end + 1) = P.num_of_micro_clusters();
        
    end
    %--------------------------------------------------------------------------
    % END of the main algorithm
    %--------------------------------------------------------------------------

    %%
    time = time + toc;

    disp(size(predictY));
    disp(size(Y));

    ExampleBasedAccuracy = ExampleBasedAccuracyInstances(predictY, Y(2:end,:));
    ExampleBasedF1 = ExampleBasedF1Instances(predictY, Y(2:end, :));

    macF1 = MacroF1(predictY, Y(2:end, :));
    micF1 = MicroF1(predictY, Y(2:end, :));

    AvePre = Averageprecision(outputF, Y(2:end,:));
    RankLoss = RankingLoss(outputF, Y(2:end,:));

    fprintf([filename '\n']);
    
    fout = fopen([output_dir filename '.txt'], 'wt');

    fprintf('Example Based Accuracy = %f\n', ExampleBasedAccuracy);
    fprintf('Example Based F1 = %f\n', ExampleBasedF1);
    fprintf('Macro F1 = %f\n', macF1);
    fprintf('Micro F1 = %f\n', micF1);

    fprintf('Ranking Loss = %f\n', RankLoss);
    fprintf('Average Precision = %f\n', AvePre);
    
    fprintf(fout, 'EBF1, EBAcc, MicF1, MacF1, AvePrecision, RankLoss\n');
    fprintf(fout, '%f,%f,%f,%f,%f,%f\n', ExampleBasedF1, ExampleBasedAccuracy,...
        micF1, macF1, AvePre, RankLoss);
    
    fclose(fout);
end


