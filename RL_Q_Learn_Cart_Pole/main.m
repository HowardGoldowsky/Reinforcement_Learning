function main()

    % Initializations
    clear all                                                                                                         %#ok<CLALL> % clear persistent variables
    MAX_EPISODES = 50000;
    WINSIZE = 100;                                                                                              % moving average window size
    performanceTelem = nan(1,MAX_EPISODES);
    failures = 0;
    %qTable = zeros(20,20,30,30,2);                                                                        % x, x_dot, theta, theta_dot, action
    %qTable = zeros(6,6,12,12,2);                                                                        % x, x_dot, theta, theta_dot, action
    %qTable = zeros(5,5,11,11,2);                                                                        % x, x_dot, theta, theta_dot, action
    qTable = zeros(4,4,8,8,2);                                                                        % x, x_dot, theta, theta_dot, action
    maxVal = [2.4, .5, deg2rad(12), deg2rad(50)];                                                    % [meters, m/s, rad, rad/s]
    minVal = [-2.4, -.5, -deg2rad(12), -deg2rad(50)];                                              % [meters, m/s, rad, rad/s]
    state = [];                                                                                                       % struct with fields x, x_dot, theta, theta_dot
    epsilon = .95; %1;                                                                                                   % probability of random action
    epsilonDec = 0.99;
    ALPHA = 0.8;                                                                                                  % learning rate 
    GAMMA = 0.95;                                                                                                % discount factor for future reinf 

    FALLPENALTY = -1;
    STANDREWARD = 0;
    
    while (failures < MAX_EPISODES)   
        
        steps = 0;
        state = resetState(state);                                                                                 % sets all variables to zero
        done = false;                                                                                                  % end of episode = true
        discreteState = discretize(maxVal, minVal, qTable, state);                                  % discretize state into bins
        prevDiscreteState = discreteState;                                                                    % prepares for new iteration

        while ~done                                                                                                    % check for failure / complete iteration
                
            steps = steps + 1;                                                                                       % increment steps         
            action = selectAction(qTable, prevDiscreteState, epsilon);                               % action = {1,2} = push {left, right}
            [state, done] = takeAction(action, state);                                                       % apply action to the cart-pole
            discreteState = discretize(maxVal, minVal, qTable, state);                               % discretize state into bins
            [maxQ_val, ~] = max(qTable(discreteState(1),discreteState(2),discreteState(3),discreteState(4),:));
            
            if ~done
                reinf = STANDREWARD;
            else
                reinf = FALLPENALTY;
            end
            
            % Update Q-table
            qTable(prevDiscreteState(1),prevDiscreteState(2),prevDiscreteState(3),prevDiscreteState(4),action)  = ...
                qTable(prevDiscreteState(1),prevDiscreteState(2),prevDiscreteState(3),prevDiscreteState(4),action) + ...
                ALPHA * (reinf + GAMMA * maxQ_val - qTable(prevDiscreteState(1),prevDiscreteState(2),prevDiscreteState(3),prevDiscreteState(4),action));
            
            prevDiscreteState = discreteState;                                                                    % prepares for new iteration
        
        end % while ~done 
       
        failures = failures + 1;
        performanceTelem(failures) = steps;                                                            % record num steps for this iteration
        epsilon = epsilon * epsilonDec;                                                                     % exploration rate update
        
        if (mod(failures,100)==0)
             disp(failures)
             meanSteps = movmean(performanceTelem(1:failures),WINSIZE);
             if (meanSteps(end) >= 195)
                break;
             end
        end
        
       
      
    end % while 
    
    plotRewardHistory(performanceTelem,WINSIZE);

end % function