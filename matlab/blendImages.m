function [mosaicR,mosaicG,mosaicB] = ...
    blendImages(baseImage,baseMap,tileImage,tileSize) 
% 
%  [mosaicR,mosaicG,mosaicB] ...
%        = blendImages(baseImage,baseMap,tileImage,tileSize) 
% 
% AUTHOR:
% 
% 
% 
% 
% 

%  DEBUGGING
%  baseImage = 

rowPositions  = 1:tileSize(1):size(baseImage,1);
colPositions  = 1:tileSize(2):size(baseImage,2);

for r = rowPositions
  for c =colPositions

    imgB = baseImage(r:r+tileSize(1)-1,c:c+tileSize(2)-1);
    mpB = baseMap(imgB(:),1:3);

    meanBase = mean(mpB);
    normBase = mpB - ones(size(mpB,1),1)*meanBase;
    covBase = normBase'*normBase;
    [u s v] = svd(covBase);

    % This is the linear transformation that converts the base
    % image distribution to align with the axes
    m1 = pinv(sqrt(s))*u';

    % We expect the tile images to be black and white,
    % one-dimensional, not color three d.  For now.
    % 
    imgT = tileImage(r:r+tileSize(1)-1,c:c+tileSize(2)-1);
    mpT = [imgT(:),imgT(:),imgT(:)];
    meanTile = mean(mpT);
    normTile = mpT - ones(size(mpB,1),1)*meanTile;
    covTile = normTile'*normTile;
    [u,s,v] = svd(covTile);

    % This is the linear transformation that converts the tile
    % image distribution to align with the axes
    m2 = pinv(sqrt(s))*u';

    % Old code
    % x = zeros(3,3); 
    % x(1,1) = 1 / sqrt(s(1,1));
    % m2 = x*u';
    %
    
    % transform imgT into new color indices
    s_img = pinv(m1)*m2*normTile';
    s_img = s_img + meanBase'*ones(1,size(s_img,2));

    % clipping s_img values
    s_img(find(s_img<0.0)) = zeros(size(find(s_img<0.0)));
    s_img(find(s_img>1.0)) = ones(size(find(s_img>1.0)));

    % copying new small image to new big image
    mosaicR(r:r+tileSize(1)-1,c:c+tileSize(2)-1) = ...
	reshape(s_img(1,:),tileSize(1),tileSize(2));
    mosaicG(r:r+tileSize(1)-1,c:c+tileSize(2)-1) = ...
	reshape(s_img(2,:),tileSize(1),tileSize(2));
    mosaicB(r:r+tileSize(1)-1,c:c+tileSize(2)-1) = ...
	reshape(s_img(3,:),tileSize(1),tileSize(2));

    % fprintf('[%3.0f, %3.0f]\n',r,c);
  end;
end;

return;
