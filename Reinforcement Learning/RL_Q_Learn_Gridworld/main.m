% Main program to run the GridWorld Q-learning algorithm

clc; clear all; close all;              % clear the command window, the workspace and close the figures

% Initialize Environment variables
trainAgent    = true;
lengthGrid    = 8;                  % length/width of the grid
numEpisodes   = 50000;              % number of episodes to train the agent
numIterations = 200;                % number of iterations per episode

% Initialize Display variables
showEvery     = 10000;              % wait these many episodes to display

% Initialize QLearning object variables
epsilon       = 0.7;                % probability of exploration
epsilonDecay  = 0.9999;             % rate at which exploration decreases (simulated annealing) 
alpha         = 0.2;                % weight of error term
gamma         = 0.9;                % discount of future rewards

% Instantiate reward objects
MOVE_PENALTY  = -1;   
ENEMY_PENALTY = -300;  
FOOD_REWARD   = 25;

food  = Reward('food',FOOD_REWARD);
enemy = Reward('enemy',ENEMY_PENALTY);
move  = Reward('move',MOVE_PENALTY);

% Instantiate sim objects
learningAlgorithm = QLearning(lengthGrid,epsilon,epsilonDecay,alpha,gamma,trainAgent);
agent = Agent('player',learningAlgorithm,numEpisodes);
gridWorld = Environment(lengthGrid,numEpisodes,numIterations);

% Train the agent
if (learningAlgorithm.trainAgent)
    for episode = 1:gridWorld.numEpisodes

        % Add players to the grid world. Set new initial locations on grid.
        % Initialize other parameters.
        [gridWorld, agent] = gridWorld.addPlayer(agent);
        [gridWorld, food]  = gridWorld.addPlayer(food);
        [gridWorld, enemy] = gridWorld.addPlayer(enemy); 

        for iteration = 1:gridWorld.numIterations

            % Indexing for the Q-table. The Q-table records quality values
            % as a function of state and actions. The indexing into the 
            % Q-table's cell array corresponds to the
            % relative x and y distances the agent is away from the food
            % and enemy, respectively. Inside each cell is a [4x1] vector 
            % that indexes into the agent's four choices of action/movement 
            % in each state, left, right, up, down. The fist index into the
            % cell array is the x-coordinate distance away from the food 
            % (-7 to -1 correspond to 7 to 1 units to the left of the food, 
            % 1 to 7 correspond to number of units to the right of the 
            % food, same for the enemy).
            % The "+ SIZE" makes everything positive; agent.observation is 
            % the x and y coordinate distance player is from food and 
            % enemy. An agent can be anywhere from -7 to +7 cells away from 
            % food or enemy.           
            agent = agent.observe(food,enemy,gridWorld.lengthGrid,'currentObs');           
            
            % Epsilon greedy policy to explore the environment. The
            % distance from the food and enemy determines which direction
            % (which action) the agent should move.    
            
            [learningAlgorithm, agent] = learningAlgorithm.policy('movement',agent);
            
            % Take the action by moving the agent on the grid; observe the 
            % reward, and observe the new state, S_prime. 
            
            [agent, gridWorld] = takeAction(agent,gridWorld);

            
            % Receive reward
            if agent.x == enemy.x && agent.y == enemy.y 
                agent.iterationReward = enemy.value;
            elseif agent.x == food.x && agent.y == food.y
                agent.iterationReward = food.value;
            else
                agent.iterationReward = move.value;
            end

            
%             if agent.x == food.x && agent.y == food.y DEBUG
%                 agent.iterationReward = food.value;
%             else
%                 agent.iterationReward = move.value;
%             end


            % Observe new state, S_prime, based on the action, for the Q-table update
            agent = agent.observe(food,enemy,gridWorld.lengthGrid,'newObs');  
            max_future_q =             max(learningAlgorithm.qTable{agent.newObs(1),agent.newObs(2),agent.newObs(3),agent.newObs(4)});             
            current_q = learningAlgorithm.qTable{agent.observation(1),agent.observation(2),agent.observation(3),agent.observation(4)}(agent.action); 
%             DEBUG max_future_q = max(learningAlgorithm.qTable{agent.newObs(1),agent.newObs(2)});
%             DEBUG current_q = learningAlgorithm.qTable{agent.observation(1),agent.observation(2)}(agent.action); 

 
            % new_q update!
            if agent.iterationReward == FOOD_REWARD
                new_q = FOOD_REWARD;
            else
                new_q = (1 - learningAlgorithm.alpha) * current_q + learningAlgorithm.alpha * (agent.iterationReward + learningAlgorithm.gamma * max_future_q);
            end
            
            learningAlgorithm.qTable{agent.observation(1),agent.observation(2),agent.observation(3),agent.observation(4)}(agent.action) = new_q;
            % DEBUG learningAlgorithm.qTable{agent.observation(1),agent.observation(2)}(agent.action) = new_q;
            
            agent.episodeReward = agent.episodeReward + agent.iterationReward;
            
            if agent.iterationReward == FOOD_REWARD || agent.iterationReward == ENEMY_PENALTY
                break
            end
            
            
            
        end % for iteration
        
        agent.rewardHistory(episode) = agent.rewardHistory(episode) + agent.episodeReward;
        learningAlgorithm.epsilon = learningAlgorithm.epsilon * learningAlgorithm.epsilonDecay;

        % Clean the environment
        [gridWorld,agent] = gridWorld.cleanWorld(agent); 

        if (mod(episode,1000)==0)
            disp(episode)
        end
        
    end % for episode
end % if (learningAlgorithm.trainAgent)


function [agent, environment] = takeAction(agent,environment)    
    previousX = agent.x;
    previousY = agent.y;
    [isValid, agent] = movePlayer(agent,environment.lengthGrid);
    choices_pool = {'left', 'right','down','up'}; % need to put this code into the called function. Too cumbersom here. 
    while(~isValid)
        agent.choice     = choices_pool{randi(4)};
        [isValid, agent] = movePlayer(agent,environment.lengthGrid);
    end

    % update the grid
    environment.grid(previousY,previousX) = 0; % delete previous location
    if isequal(agent.type,'enemy')  % draw current one
        environment.grid(agent.y,agent.x) = 1;
    elseif isequal(agent.type,'food')
        environment.grid(agent.y,agent.x) = 2;
    elseif isequal(agent.type,'player')
        environment.grid(agent.y,agent.x) = 3;
    end                     
end % takeAction


function [isValid, agent] = movePlayer(agent,lengthGrid)
    % Move the player. If the player hits the edge of the grid,
    % then set the movement inValid = false. The calling function
    % then calls this function again until inValid = true. 
    isValid = true;
    if isequal(agent.choice,'right')
        if agent.x + 1 <= lengthGrid
            agent.x = agent.x + 1;
        else
            isValid = false;
        end
    elseif isequal(agent.choice,'left')
        if agent.x - 1 > 0
            agent.x = agent.x - 1;
        else
            isValid = false;
        end
    elseif isequal(agent.choice,'down')
        if agent.y - 1 > 0
            agent.y = agent.y - 1;
        else
            isValid = false;
        end
    elseif isequal(agent.choice,'up')
        if agent.y + 1 <= lengthGrid
            agent.y = agent.y + 1;
        else
            isValid = false;
        end
    end
end % move
