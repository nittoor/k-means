function J=Question5_2(inputData,K,numIterations)
startingVector = getRandomStartPoints(inputData,K);
[centroids,J]=applyKmeansClustering(startingVector,inputData,K,numIterations);
plotOnGraph(inputData,centroids);
end

function plotOnGraph(inputData,centroids)
    [numRows,numCols]=size(inputData);
    [clusters,numCols]=size(centroids);
    cmap = hsv(clusters);
    markers = {'o','+','*','.','x'};
    figure 
    hold on
    for i=1:numRows
        clusterId = getClosestCluster(inputData(i,2:3),centroids,clusters);
        plot(inputData(i,2),inputData(i,3),'Color',cmap(clusterId,:),'Marker',markers{1,clusterId});
    end
    hold off
end

function [meanVector,J]=applyKmeansClustering(startingVector,inputData,numClusters,numIterations)
    iterate = true;
    iterCount=1;
    J = zeros(1,numIterations);
    if (numIterations~=0)
        iterate =false;
    end
    [numRows,numCols]=size(inputData);
    meanVector= startingVector;
    while ((iterate) ||(~iterate && (iterCount<=numIterations)))
        startingVector=meanVector;
        sumVector = zeros(numClusters,2);
        countVector = zeros(1,numClusters);
        for i=1:numRows
            clusterId=getClosestCluster(inputData(i,2:3),startingVector,numClusters);  
            sumVector(clusterId,:)=sumVector(clusterId,:) + inputData(i,2:3);
            countVector(1,clusterId) = countVector(1,clusterId) +1;
             if (numIterations~=0)
                J(1,iterCount) = J(1,iterCount) + getSquareError(inputData(i,2:3),startingVector(clusterId,:));
             end
        end
        
        %% find the new centroid
        for k=1:numClusters
            if (countVector(k)~=0)
                meanVector(k,1:2)=sumVector(k,1:2)/countVector(1,k);
            end
        end
        
        %%calculate J
        
        
        if (eq(meanVector,startingVector))
            if (iterate)
                break;
            end
        end
        iterCount=iterCount+1;
    end
end

function [squareError]=getSquareError (inputPoint,meanPoint)
    squareError=(((inputPoint(1,1)-meanPoint(1,1))^2)+ ((inputPoint(1,2)-meanPoint(1,2))^2));
end 

function id=getClosestCluster(point,meanVector,numClusters)
    maxDistance = 1000;
    id = 0;
    for k=1:numClusters
        distance = (meanVector(k,1)-point(1,1))^2 + (meanVector(k,2)-point(1,2))^2;
        if (distance < maxDistance)
            maxDistance = distance ;
            id = k;
        end
    end
end

function [startingPoints]=getRandomStartPoints(inputData,numClusters)
    [numRows,numCols]=size(inputData);
    x = floor((numRows).*rand(numClusters,1) + 1);
    for k=1:numClusters
            startingPoints(k,1:2)= inputData(x(k,1),2:3);
    end
end