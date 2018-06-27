function outImage = placeTiles(baseImageSize,tileImages,varargin)
% Randomly place the tiles into a monochrome output image the size of base
%
% Description
%
% Inputs
%  baseImageSize:  (row,col)
%  tileImages:     row,col size of the returned black and white image
%
% Return
%  outImage:  monochrome image containing the positioned tiles (0,1)
%
% Hel-Or, Wandell, Nov. 1995
%
% See also
%

%%
p = inputParser;

p.addRequired('baseImageSize',@(x)(length(x) == 2));
p.addRequired('tileImages',@(x)(ndims(x) == 3));

p.parse(baseImageSize,tileImages,varargin{:});

nTiles = size(tileImages,3);
[r,c,~] = size(tileImages);
tileImageSize = [r,c];

outImage = zeros(baseImageSize);

%% Create the monochrome tile image

rowPositions = 1:tileImageSize(1):baseImageSize(1);
colPositions = 1:tileImageSize(2):baseImageSize(2);

for r = rowPositions
    for c = colPositions
        whichTile = ceil(nTiles .* rand(1));
        outImage(r:(r+tileImageSize(1)-1),c:(c+tileImageSize(2)-1)) = ...
            tileImages(:,:,whichTile);
    end
end

% Out image is scaled to 0,1
outImage = ieScale(outImage,0,1);

end