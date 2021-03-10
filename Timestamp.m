classdef Timestamp < handle
    % Timestamp    
    properties
        time_stamp;
    end
    
    methods
        function obj = Timestamp(time_stamp)
            if nargin > 0
                obj.time_stamp = time_stamp;
            else
                obj.time_stamp = 0;
            end
        end
        
        function time_stamp = get_time_stamp(obj)
            time_stamp = obj.time_stamp;
        end
        
        function [] = increase(obj)
            obj.time_stamp = obj.time_stamp + 1;
        end
        
        function [] = set_time_stamp(obj, time_stamp)
            obj.time_stamp = time_stamp;
        end       
    end    
end
