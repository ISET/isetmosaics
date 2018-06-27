function imgMosaic = blendImages(baseImage,tileImage,tileSize)
% Combine the color of base with the tiles
%
% Syntax
%  imgMosaic = blendImages(baseImage,tileImage,tileSize)
%
% Description
%   This code equates the tile mean with the base image mean, and it
%   sets the color direction of the black and white tile to the first
%   principal component of the color of the base image.
%
%
% BW, 2018
%
% See also
%   CreateSubImages

%% For each part of the tile image
rowPositions  = 1:tileSize(1):size(baseImage,1);
colPositions  = 1:tileSize(2):size(baseImage,2);

% Adjust the baseImage and tileImage to be between 0 and 1
baseImage = ieScale(double(baseImage),0,1);
tileImage = ieScale(double(tileImage),0,1);
% vcNewGraphWin; imshow(baseImage);
% vcNewGraphWin; imshow(tileImage); 

imgMosaic = zeros(size(baseImage));

%% Place and scale

for r = rowPositions
    for c =colPositions
        
        % Get a section of the base image
        imgB = baseImage(r:r+tileSize(1)-1,c:c+tileSize(2)-1,:);
        imgB = RGB2XWFormat(imgB);
        % Find the mean value
        meanBase = mean(imgB);
        
        % Subtract out the mean and calculate the first principla component
        % of the variation in the base image.  We will adjust the tile
        % image to have the same mean and vary in this direction.
        normBase = double(imgB) - meanBase;
        covBase = normBase'*normBase;
        [u, ~, ~] = svd(covBase);
        
        % We expect the tile images to be black and white,
        % one-dimensional, not color three d.  For now.
        imgT = tileImage(r:r+tileSize(1)-1,c:c+tileSize(2)-1);
        mpT = RGB2XWFormat(imgT); 
        meanTile = mean(mpT);
        normTile = double(mpT) - meanTile;
        
        % transform imgT into new color indices
        s_img = u(:,1)*normTile';
        s_img = s_img + meanBase';
        s_img = XW2RGBFormat(s_img',tileSize(1),tileSize(2));

        % clipping s_img values
        s_img = ieClip(s_img,0,1);
        % vcNewGraphWin; imshow(s_img); 
        
        % copying new small image to new big image
        imgMosaic(r:r+tileSize(1)-1,c:c+tileSize(2)-1,:) = s_img;
        % fprintf('[%3.0f, %3.0f]\n',r,c);
    end
end

end

%%