classdef MicroCluster < matlab.mixin.Copyable
    % Class definition of a micro-cluster (can be p-micro-cluster or
    % o-micro-cluster)
    
    properties
        last_edit_T = -1;           % What is this?
        creation_time_stamp = -1;  
        lambda;
        current_time_stamp;
        label_count = [];
        label_weight = [];
        instances = [];
        
        w;
        CF1;
        CF2;
        N; % Number of points in the cluster
        
% 	    LS; % Linear sum of all the points added to the cluster	 	 
% 	    SS; % Squared sum of all the points added to the cluster
    end
    
    methods
        function obj = MicroCluster(center, y, creation_time_stamp ...
                , lambda, current_time_stamp, t)
            obj.N = 1;
            obj.instances = [obj.instances t];
%             obj.LS = center;
%             obj.SS = center .^ 2;
            obj.creation_time_stamp = creation_time_stamp;
            obj.last_edit_T = creation_time_stamp;
            obj.lambda = lambda;
            obj.current_time_stamp = current_time_stamp;
            
            obj.w = 1;
            obj.CF1 = center;
            obj.CF2 = center .^ 2;
            
            % storage labels to micro cluster
            obj.label_count = sparse(y);
            obj.label_weight = sparse(y);
        end
        
        function [] = insert(obj, instance, y, t)
            obj.instances = [obj.instances t];
            obj.N = obj.N + 1;
            current_time = obj.current_time_stamp.get_time_stamp();
            dt = current_time - obj.last_edit_T;
            fading_factor = 2^(-dt * obj.lambda);
            
            obj.CF1 = fading_factor * obj.CF1 + instance;
            obj.CF2 = fading_factor * obj.CF2 + instance .^ 2;
            obj.w = fading_factor * obj.w + 1;
            obj.last_edit_T = current_time;
            
            % storage labels to micro cluster
            obj.label_count = obj.label_count + sparse(y);
            obj.label_weight = obj.label_weight * fading_factor + sparse(y);
        end
        
        function P = get_P(obj)
            P = obj.label_count / obj.N;
        end
        
        function lw = get_label_weight(obj) 
            lw = obj.label_weight;
        end
        
        function w = get_weight(obj)
            current_time = obj.current_time_stamp.get_time_stamp();
            dt = current_time - obj.last_edit_T;
            fading_factor = 2 ^(-dt * obj.lambda);
            
            w = fading_factor * obj.w ;
        end
        
        function last_edit_T = get_last_edit_T(obj)
            last_edit_T = obj.last_edit_T;
        end
        
        function creation_time_stamp = get_creation_time(obj)
            creation_time_stamp = obj.creation_time_stamp;
        end
        
        function center = get_center(obj)
            current_time = obj.current_time_stamp.get_time_stamp();
            dt = current_time - obj.last_edit_T;
            fading_factor = 2 ^(-dt * obj.lambda);
            
            center = fading_factor * (obj.CF1 ./ obj.w);
        end
        
        function radius = get_radius(obj)   
            current_time = obj.current_time_stamp.get_time_stamp();
            dt = current_time - obj.last_edit_T;
            fading_factor = 2 ^(-dt * obj.lambda);
            
            CF1_val = fading_factor * obj.CF1;
            CF2_val = fading_factor * obj.CF2;
            w_val = fading_factor * obj.w;
            
            % Method 1: Max 
            t = sqrt(CF2_val / w_val - (CF1_val / w_val).^2);
            radius = max(t(:));
        end     
        
    end    
end

