classdef Reward
    
    % Generic reward object for an RL appliation
    
    properties       
        x                   % INT x-coordinate on grid
        y                   % INT y-coordinate on grid
        value               % FLOAT scalar
        type                % STRING      
    end
    
    methods
        
        function obj = Reward(type,value)           
            obj.type  = type;
            obj.value = value;           
        end
    
    end
end

