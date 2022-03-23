classdef QLearning
    
    % A Q-learning reinforcement learning algorithm
    
    properties
        
        type                % text string ('Q-learning' etc)
        trainAgent          % BOOL true if training is on
        gamma               % discount of future rewards
        alpha               % weight of error term
        epsilon             % probability of exploration
        epsilonDecay        % rate at which exploration decreases
        qTable              % quality table Q(numStates, numActions) 
        
    end % properties
    
    methods
        
        function obj = QLearning(lengthGrid,epsilon,epsilonDecay,alpha,gamma,trainAgent) % constructor            
            obj.epsilon = epsilon;
            obj.epsilonDecay = epsilonDecay;
            obj.alpha = alpha;
            obj.gamma = gamma;           
            obj = initQtable(obj,lengthGrid);  
            obj.type = 'QLearning';
            obj.trainAgent = trainAgent;
        end
        
        function obj = reset(obj,epsilon)
            obj.epsilon = epsilon;
        end
        
        function obj = initQtable(obj,lengthGrid)           
           numCells = 2*lengthGrid - 1;
           numEntries = numCells^4;
           obj.qTable{numEntries} = [];     % init cell array memory
           for i = 1:numEntries
               obj.qTable{i} = -4 * rand(4,1); % init Q-value
           end
           obj.qTable = reshape(obj.qTable,numCells,numCells,numCells,numCells);
        end
      
        function [obj, agent] = policy(obj, actPurpose, agent)
            switch(actPurpose)
                case 'movement'
                    
                    if rand(1) > obj.epsilon                 
                        [~, agent.action] = max(obj.qTable{agent.observation(1),agent.observation(2),agent.observation(3),agent.observation(4)});                       
                        % DEBUG[~, agent.action] = max(obj.qTable{agent.observation(1),agent.observation(2)});
                        agent.choice = obj.act2choice(agent.action);
                    else
                        agent.action = randi(4,1);
                        agent.choice = obj.act2choice(agent.action);
                    end

                case 'updateQ'
                    
            end % switch
        end % chooseAction
        
        function choice = act2choice(~,act)
            if act == 1
                choice = 'up';
            elseif act == 2
                choice = 'down';
            elseif act == 3
                choice = 'left';
            elseif act == 4
                choice = 'right';
            end
        end
        
    end % methods
    
end % class

