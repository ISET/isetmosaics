function tileImage = ...
    placeTiles(tileImageList,tileSize,tileImageSize,method,arg1,arg2,arg3)
%
%AUTHOR: Hel-Or, Wandell
%DATE:   Nov. 1995
%
%ARGUMENTS
% tileImageList: matrix whose columns contain the tiles
% tileSize:     Size of the individual tiles.
% tileImageSize:  row, col size of the returned black and white image
% method:
% 
% RETURNS:
% tileImage:   black white image containing the positioned tiles

nTiles = size(tileImageList,2);

% create the tile image using the 't' method
% 
if (method == 't')

  rowPositions = 1:tileSize(1):tileImageSize(1);
  colPositions = 1:tileSize(2):tileImageSize(2);
  tileImage = zeros(tileImageSize);

  for r = rowPositions
    for c = colPositions
      whichTile = ceil(nTiles.*rand(1));   
      tileImage(r:(r+tileSize(1)-1),c:(c+tileSize(2)-1)) = ...
	  reshape(tileImageList(:,whichTile),tileSize(1),tileSize(2));
      fprintf('%3.0f',whichTile);
    end;
  end;

  fprintf('\n');

elseif (method == 'r')

  fprintf('Creating tile image using a random placement algorithm.\n');

  if (~exist('arg1')), tileDensity = 3; 
  else tileDensity = arg1;
  end

  if (~exist('arg2')), rseed = 1;
  else rseed = arg2;
  end

  rand('seed',rseed); 
  nTilePlaces = round( prod( tileImageSize ./ tileSize ) * tileDensity);
  tileImage = zeros(tileImageSize);

  for ii = 1:nTilePlaces
    r = max(1,round(rand(1)*(tileImageSize(1) - (tileSize(1)+1))));
    c = max(1,round(rand(1)*(tileImageSize(2) - (tileSize(2)+1))));
    whichTile = ceil(nTiles.*rand(1));   

    tileImage(r:(r+tileSize(1)-1),c:(c+tileSize(2)-1)) = ...
	reshape(tileImageList(:,whichTile),tileSize(1),tileSize(2));
    
    if (mod(ii,round(nTilePlaces/10)) == 0)
      fprintf('Percent done: %3.2f\n',100*ii/nTilePlaces);
    end

  end

else
  error('Unknown method');
end

return;
