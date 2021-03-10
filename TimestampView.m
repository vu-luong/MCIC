classdef TimestampView < handle
    % Read-only view of the time stamp
        
    properties (Access = private)
        time_stamp;
    end
    
    methods
        function obj = TimestampView(time_stamp)
            obj.time_stamp = time_stamp;
        end
        
        function time_stamp = get_time_stamp(obj)
            time_stamp = obj.time_stamp.get_time_stamp();
        end
    end    
end

