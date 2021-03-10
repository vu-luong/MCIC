classdef MicroClusterList < handle % A `handle` is a reference to an object.
    % List of micro-clusters
    
    properties 
        MC_list;
    end
    
    properties (Constant)
      INF = 1e15;
   end
    
    methods
        function obj = MicroClusterList()
            obj.MC_list = cell(1,0);
        end
        
        function num_of_MCs = num_of_micro_clusters(obj)
            num_of_MCs = numel(obj.MC_list);
        end
        
        function [] = add(obj, micro_cluster)
            obj.MC_list{end + 1} = micro_cluster;
        end
        
        function [] = remove(obj, element)
            obj.MC_list(([obj.MC_list{:}] == element)) = [];
        end
        
        function [removed] = periodic_removal_of_p_micro_clusters(obj, threshold)
            num_of_MCs = numel(obj.MC_list);     
            removed = 0;

            for i = num_of_MCs : -1 : 1
                if isempty(obj.MC_list{i})  % Ignore those MC which have been already removed.
                    continue;
                end
                wo = obj.MC_list{i}.get_weight();
                
                if wo < threshold
                    % Delete p cluster
                    obj.MC_list(i) = [];
                    removed = 1;
                end
            end
        end
        
        function [removed] = periodic_removal_of_o_micro_clusters(obj, xsi2, tp, timestamp, lambda)
            num_of_MCs = numel(obj.MC_list);
            removed = 0;
            for i = num_of_MCs : - 1 : 1
                if isempty(obj.MC_list{i})
                    continue;
                end
                cO = obj.MC_list{i};
                t0 = cO.get_creation_time();
                xsi1 = 2^(-lambda * (timestamp - t0 + tp)) - 1;
                xsi = xsi1 / xsi2;
                if cO.get_weight() < xsi
%                     fprintf('delete o cluster\n');
                    obj.MC_list(i) = [];   
                    removed = 1;
                end
            end
        end
        
        function [CK] = weighted_k_nearest_cluster(obj, point, K)
            % Check if list is empty first before using this method!
            num_of_micro_clusters = numel(obj.MC_list);
            list_of_MC = obj.MC_list;
            distances = zeros(1, num_of_micro_clusters);
            
            for i = 1 : num_of_micro_clusters
                MC = list_of_MC{i};
                if isempty(MC)
                    distances(i) = MicroClusterList.INF;
                    continue;
                end
                
                dist = sqrt(sum((point - MC.get_center()).^2));
                distances(i) = dist*MC.get_weight();
            end
            
            [B, I] = sort(distances);
            NCK = min(K, num_of_micro_clusters);
            CK = cell(1, NCK);
            for i = 1 : NCK
                CK{i} = list_of_MC{I(i)};
            end
        end
        
        
        function [CK] = k_nearest_cluster(obj, point, K)
            % Check if list is empty first before using this method!
            num_of_micro_clusters = numel(obj.MC_list);
            list_of_MC = obj.MC_list;
            distances = zeros(1, num_of_micro_clusters);
            
            for i = 1 : num_of_micro_clusters
                MC = list_of_MC{i};
                if isempty(MC)
                    distances(i) = MicroClusterList.INF;
                    continue;
                end
                
                dist = sqrt(sum((point - MC.get_center()).^2));
                distances(i) = dist;
            end
            
            [B, I] = sort(distances);
            NCK = min(K, num_of_micro_clusters);
            CK = cell(1, NCK);
            for i = 1 : NCK
                CK{i} = list_of_MC{I(i)};
            end
        end
        
        function [mean_dist] = k_nearest_cluster_label(obj, point, K, label)
            % Check if list is empty first before using this method!
            num_of_micro_clusters = numel(obj.MC_list);
            list_of_MC = obj.MC_list;
            cnt = 0;
            distances = [];
            for i = 1 : num_of_micro_clusters
                MC = list_of_MC{i};
                if (isempty(MC) || MC.label_count(label) <= 0)
                    continue;
                end
                
                dist = sqrt(sum((point - MC.get_center()).^2));
                cnt = cnt + 1;
                distances(cnt) = dist * MC.get_weight();
            end
            
            [~, I] = sort(distances);
            NCK = min(K, cnt);
            if (NCK == 0)
                mean_dist = obj.INF;
                return;
            end
            sum_dist = 0;
            for i = 1 : NCK
                sum_dist = sum_dist + distances(I(i));
            end
            mean_dist = sum_dist / NCK;
        end
        
        function [nearest_MC, min_dist] = nearest_cluster(obj, point)
            % Check if list is empty first before using this method!
            num_of_micro_clusters = numel(obj.MC_list);
            list_of_MC = obj.MC_list;
            min_dist = 0;
            nearest_MC = [];
            for i = 1 : num_of_micro_clusters
                MC = list_of_MC{i};
                if isempty(MC)
                    continue;
                end
                if isempty(nearest_MC)
                    nearest_MC = MC;
                    min_dist = sqrt(sum((point - MC.get_center()).^2)) - MC.get_radius(); 
                end
                dist = sqrt(sum((point - MC.get_center()).^2)) - MC.get_radius();
                if dist < min_dist
                    min_dist = dist;
                    nearest_MC = MC;
                end
            end
        end
    end    
end
