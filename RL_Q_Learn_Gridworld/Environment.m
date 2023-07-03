classdef Environment
    
    % Environment class for a GridWorld application
    
    properties
        
        agent               % autonomous player in the GridWorld
        numEpisodes         % number of episodes
        numIterations       % number of iterations per episode
        maxStepsPerEpisode  % max allowed steps per episode
        lengthGrid          % length of side 
        numPlayers          % number of objects in the grid world
        occupiedCells       % [numPlayers x 2] objects occupy these cells
        grid                % grid where action takes place
        
    end % properties
    
    methods
 
        function obj = Environment(lengthGrid,numEpisodes,numIterations)  % constructor            
            obj.lengthGrid = lengthGrid;
            obj.numEpisodes = numEpisodes;
            obj.numPlayers = 0;
            obj.grid = zeros(lengthGrid); 
            obj.numIterations = numIterations;
        end % constructor
        
        function [obj, player] = addPlayer(obj,player)      
%   DEBUG          flag = true;                                    % avoids two players occupying the same cell in the grid
%             while flag
%                 x = randi(obj.lengthGrid,1);
%                 y = randi(obj.lengthGrid,1); 
%                 flag = false;   
%                 for i = 1:obj.numPlayers
%                     if x == obj.occupiedCells(i,2) && y == obj.occupiedCells(i,1)
%                         flag = true;
%                     end
%                 end
%             end
            

            switch player.type % DEBUG
                case 'player'
                    x = 2; y = 3;
                case 'food'
                    x = 1; y = 1;
                case 'enemy'
                    x = 4; y = 4;
                
            end
            obj.numPlayers = obj.numPlayers + 1;
            obj.occupiedCells(obj.numPlayers,:) = [y,x]; 
            player.x = x;
            player.y = y; 
            
            
            % update the grid
            if isequal(player.type,'enemy')
                obj.grid(y,x) = 1; 
            elseif isequal(player.type,'food')
                obj.grid(y,x) = 2; 
            elseif isequal(player.type,'player')
                obj.grid(y,x) = 3; 
            end
        end % addPlayer
        
        function [obj,agent] = cleanWorld(obj,agent)          
            obj.grid = zeros(obj.lengthGrid);   
            obj.occupiedCells = zeros(obj.numPlayers,2); 
            obj.numPlayers = 0;  
            agent = agent.reset;
        end % cleanWorld
        
    end % methods
end % class

