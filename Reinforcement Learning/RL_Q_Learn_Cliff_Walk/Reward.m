classdef Reward
    
    % Generic reward object for an RL appliation
    
    properties       
        x                   % INT x-coordinate on grid
        y                   % INT y-coordinate on grid
        value               % FLOAT scalar
        type                % STRING      
    end
    
    methods
        
        function obj = Reward(type,value,varargin)
            
            if nargin==3
                location = varargin{1};
                obj.x = location(1);
                obj.y = location(2);
            else
                obj.x = [];
                obj.y = [];
            end
                
            obj.type  = type;
            obj.value = value;    
            
        end
    
    end
end

