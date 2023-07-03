classdef Agent
    
    properties
        
        x                       % INT x-coordinate on grid
        y                       % INT y-coordinate on grid
        ID                      % INT agent ID 
        type                    % STRING text string
        learningAlgorithm       % LEARNING OBJECT 
        observation             % observation parameters 
        newObs 
        action
        rewardHistory
        iterationReward
        episodeReward           
        choice                  % choice of movement direction (left, right, down up)
        
    end
    
    methods
        
        function obj = Agent(type,learningAlgorithm,numEpisodes)  % constructor    
            obj.type = type;
            obj.learningAlgorithm = learningAlgorithm;
            obj.iterationReward = 0;
            obj.episodeReward = 0;
            obj.rewardHistory = zeros(numEpisodes,1);
        end % constructor
        
        function obj = observe(obj,food,enemy,lengthGrid,obs)
            foodDiff  = [obj.x - food.x, obj.y - food.y];
            enemyDiff = [obj.x - enemy.x, obj.y - enemy.y];
            switch(obs)
                case 'currentObs'
                    obj.observation = [foodDiff, enemyDiff] + lengthGrid; 
                case 'newObs'
                    obj.newObs = [foodDiff, enemyDiff] + lengthGrid; 
            end
        end 
        
        function obj = reset(obj)
            obj.x = [];                      
            obj.y = [];                    
            obj.observation = [];                    
            obj.iterationReward = 0;
            obj.episodeReward = 0;
        end    
    end
end

