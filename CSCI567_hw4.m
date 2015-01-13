function CSCI567_hw4()
% %%Question 5.2 a
 DGaussian=csvread('2DGaussian.csv',1);
Question5_2(DGaussian,2,0);
Question5_2(DGaussian,3,0);
Question5_2(DGaussian,5,0);

% %Question 5.2 b
Iterations = 50;
J = zeros(5,Iterations);
for loopIter=1:5
    J(loopIter,:)=Question5_2(DGaussian,4,Iterations);
end
    figure
    cmap = {'r','g','b','k','m'};
    hold on
    x=1:1:50;
    for i=1:5
        plot(x,J(i,:),'Color',cmap{1,i});
         legendInfo{i} = [strcat('Round ',num2str(i))];
    end
    title('K = 4 ');
    xlabel('Iteration');
    ylabel('Distortion Measure');
    legend(legendInfo);
    hold off
% 
hw4=imread('hw4.jpg');
%%imshow(hw4)

%%Question 5.3
Question5_3(hw4,3);
Question5_3(hw4,8);
Question5_3(hw4,15);
end 