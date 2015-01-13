function [outputImage]=Question5_3(inputImage,numClusters)
%imshow(inputImage)
%inputImage
rgbColorSpace = plotPointsToRGBColorSpace(inputImage);
meanVector = applyKMeansClustering(inputImage,rgbColorSpace,numClusters,10);
outputImage = transformImage(inputImage,meanVector );
figure,imshow(outputImage);
end

%%transform input image to output image using mean vector
function [outputImage] = transformImage(inputImage,meanVector )
outputImage=inputImage;
%meanVector
index =0;
errorCorrection = ones(1,3);
[height,width,dim]=size(inputImage);
    for x=1:width
        for y=1:height
            outputImage(y,x,1:3) = meanVector(getClosestClusterRGBOP(inputImage(y,x,1),inputImage(y,x,2),inputImage(y,x,3),meanVector),1:3)-errorCorrection(1,1:3);
%             index  = getClosestClusterRGBOP(inputImage(y,x,1),inputImage(y,x,2),inputImage(y,x,3),meanVector);
%             outputImage(y,x,1) = meanVector(index,2)-1;
%             outputImage(y,x,2) = meanVector(index,3)-1;
%             outputImage(y,x,3) = meanVector(index,1)-1;
        end
    end
end

%% apply kmeans on colorspace data
function [meanVector]=applyKMeansClustering (inputImage,colorSpace,numClusters,iterations)
    
    
    %% set staring points at equal distances
    startingPoints=getStartingPoints(numClusters,inputImage);
    
    %% array to store avaerage values for each cluster
    meanVector = double(startingPoints);
    clusterId =0 ;
    
    %% for given iterations
    for (iter =1 : iterations)
        %meanVector
        sumVector = zeros(numClusters,3);
        countVector = zeros(1,numClusters);
        startingPoints=meanVector;
        %% for each point find nearest centroid
        for r=1:256
            for g=1:256
                for b=1:256
                    if (colorSpace(r,g,b)~=0)
                       clusterId=getClosestClusterRGBOP(r,g,b,startingPoints);
                       sumVector(clusterId,1:3)= sumVector(clusterId,1:3)+ [r,g,b]*colorSpace(r,g,b);
                       countVector(1,clusterId)= countVector(1,clusterId)+ colorSpace(r,g,b);
                    end
                end
            end
        end
        
        %% find the new centroid
        for k=1:numClusters
            if (countVector(k)~=0)
                meanVector(k,1:3)=sumVector(k,1:3)/countVector(1,k);
            end
        end
%         %meanVector
%         if (isequal(round(meanVector),round(startingPoints)))
%             break;
%         end
    end
end

function [startingPoints]=getStartingPoints(numClusters,inputImage)
    
    [height,width,dim]=size(inputImage);
    x = floor((width).*rand(numClusters,1) + 1);
    y = floor((height).*rand(numClusters,1) + 1);
    for k=1:numClusters
            startingPoints(k,1:3)= inputImage(y(k,1),x(k,1),1:3);
    end
%     
%% set staring points at equal distances
%     white = [256,256,256];
%     black = [1,1,1];
%     startingPoints=zeros(numClusters,3);
%     startingPoints(1,1:3)=black;
%     startingPoints(numClusters,1:3)=white;
%     if (numClusters > 2)
%         for k=2:numClusters-1
%             startingPoints(k,1:3)= (k-1)*white/(numClusters-1);
%         end
%     end
end

function index=getClosestClusterRGBOP(red,green,blue,startingPoints)
    [numClusters,dims]=size(startingPoints);
    %startingPoints
    max = 10000;
    index =0;
    for k=1:numClusters
%         R2 = (startingPoints(k,1)-double(red))^2;
%         G2 = (startingPoints(k,2)-double(green))^2;
%         B2 = (startingPoints(k,3)-double(blue))^2;
%         meanSq = sqrt(R2 + G2 + B2);
%         if (meanSq < max)
%             index = k;
%             max = meanSq ;
%         end
        if (abs(startingPoints(k,1)-double(red))+abs(startingPoints(k,2)-double(green))+abs(startingPoints(k,3)-double(blue)) < max)
            index = k;
            max = abs(startingPoints(k,1)-double(red))+abs(startingPoints(k,2)-double(green))+abs(startingPoints(k,3)-double(blue)) ;
        end
    end
end

function index=getClosestClusterRGB(red,green,blue,startingPoints)
    %[red,green,blue]
    [numClusters,dims]=size(startingPoints);
    max = 1000;
    index =0;
    for k=1:numClusters
        if ((abs(startingPoints(k,1)-red) + abs(startingPoints(k,2)-blue) + abs(startingPoints(k,3)-green)) < max)
            index = k;
            max = (abs(startingPoints(k,1)-red) + abs(startingPoints(k,2)-blue) + abs(startingPoints(k,3)-green)) ;
        end
    end
end

function [colorSpace]=plotPointsToRGBColorSpace(inputImage)
    colorSpace = zeros(256,256,256);
    [height,width,dim]=size(inputImage);
    for x=1:width
        for y=1:height
                colorSpace(inputImage(y,x,1)+1,inputImage(y,x,2)+1,inputImage(y,x,3)+1)=colorSpace(inputImage(y,x,1)+1,inputImage(y,x,2)+1,inputImage(y,x,3)+1)+1;
        end
    end
end