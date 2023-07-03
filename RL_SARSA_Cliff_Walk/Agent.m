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
        newAction
        rewardHistory
        iterationReward
        episodeReward           
        choice                  % choice of movement direction (left, right, down up)
        
    end
    
    methods
        
        function obj = Agent(type,learningAlgorithm,numEpisodes,location)  % constructor    
            obj.type = type;
            obj.learningAlgorithm = learningAlgorithm;
            obj.iterationReward = 0;
            obj.episodeReward = 0;
            obj.rewardHistory = zeros(numEpisodes,1);
            obj.x = location(2);
            obj.y = location(1);
        end % constructor
        
        function obj = observe(obj,food,lengthGrid,obs)
            % Agent observes how many cells it is away from the positive
            % and negative reward cells. Returns both distances in its
            % obseration or newObs property. 
            foodDiff  = [obj.x - food.x, obj.y - food.y];            
            cliffVertDist = 8 - obj.y;
            switch(obj.x)
                case 1
                    cliffHorizDist = -1;
                case {2,3,4,5,6,7}
                    cliffHorizDist = 0;
                case 8
                    cliffHorizDist = 1;
            end            
            enemyDiff = [cliffHorizDist, cliffVertDist];                       
            switch(obs)
                case 'currentObs'
                    obj.observation = [foodDiff, enemyDiff] + lengthGrid; 
                case 'newObs'
                    obj.newObs = [foodDiff, enemyDiff] + lengthGrid; 
            end
        end 
        
        function obj = reset(obj)
            % Places agent back at the starting cell after each iteration.
            obj.x = 1;                      
            obj.y = 8;                    
            obj.observation = [];                    
            obj.iterationReward = 0;
            obj.episodeReward = 0;
        end    
    end
end

