function outImage = placeTiles(baseImageSize,tileImages,method,varargin)
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

%%
p = inputParser;

p.addRequired('tileImages',@(x)(ndims(x) == 3));
p.addRequired('method',@ischar);
p.addParameter('tileDensity',3,@isscalar);
p.addParameter('rseed',1,@isscalar);

p.parse(tileImages,method,varargin{:});

tileDensity = p.Results.tileDensity;
rseed = p.Results.rseed;

nTiles = size(tileImages,3);
[r,c,~] = size(tileImages);
tileImageSize = [r,c];

outImage = zeros(baseImageSize);

%%

% Create the tile image using the 't' method
if (method == 't')
    
    rowPositions = 1:tileImageSize(1):baseImageSize(1);
    colPositions = 1:tileImageSize(2):baseImageSize(2);
    
    for r = rowPositions
        for c = colPositions
            whichTile = ceil(nTiles .* rand(1));
            outImage(r:(r+tileImageSize(1)-1),c:(c+tileImageSize(2)-1)) = ...
                tileImages(:,:,whichTile);
            fprintf('%3.0f',whichTile);
        end
    end
    
    fprintf('\n');
    
elseif (method == 'r')
    % Not debugged
    fprintf('Creating tile image using a random placement algorithm.\n');
    rng(rseed);
    
    nTilePlaces = round( prod( tileImageSize ./ tileSize ) * tileDensity);
    
    for ii = 1:nTilePlaces
        r = max(1,round(rand(1)*(tileImageSize(1) - (tileSize(1)+1))));
        c = max(1,round(rand(1)*(tileImageSize(2) - (tileSize(2)+1))));
        whichTile = ceil(nTiles.*rand(1));
        
        outImage(r:(r+tileSize(1)-1),c:(c+tileSize(2)-1)) = ...
            reshape(tileImages(:,whichTile),tileSize(1),tileSize(2));
        
        if (mod(ii,round(nTilePlaces/10)) == 0)
            fprintf('Percent done: %3.2f\n',100*ii/nTilePlaces);
        end
        
    end
    
else
    error('Unknown method');
end

end