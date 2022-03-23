classdef Display
    
    % Display class for GridWorld
    
    properties
        
        showEvery                   % display every n episodes
        hFig                        % figure handle
        
    end
    
    methods
   
        function obj = Display(showEvery) % constructor
              
            obj.showEvery = showEvery;
            obj.hFig = [];
                
        end
            
    end
end

