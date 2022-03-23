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
        
        function obj = addPlayer(obj,player)      

            obj.numPlayers = obj.numPlayers + 1;
            if ~isempty(player.x)
                obj.occupiedCells(obj.numPlayers,:) = [player.y,player.x]; 
            end
                        
            % update the grid
            if isequal(player.type,'enemy')
                obj.grid(player.y,player.x) = 1; 
            elseif isequal(player.type,'food')
                obj.grid(player.y,player.x) = 2; 
            elseif isequal(player.type,'player')
                obj.grid(player.y,player.x) = 3; 
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

