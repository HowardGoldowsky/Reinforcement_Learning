function plotRewardHistory(performanceTelem,WINSIZE)    

    figure;
    
    plot((1:length(performanceTelem)),movmean(performanceTelem,WINSIZE),'b-','LineWidth',1);
    %plot((1:length(performanceTelem)),performanceTelem,'b-','LineWidth',1);
    xlabel('\bf Episode Number');
    ylabel('\bf Number of Steps');
    title('\bf Cart-pole Steps vs. Trial Number');

end