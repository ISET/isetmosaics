function bwImage = placeTiles(tileImage,tSize,bwSize)
%
%AUTHOR: Wandell
%DATE:   Nov. 1995
%
%ARGUMENTS
% tileImage: matrix whose columns contain the tiles
% tSize:     Size of the individual tiles.
% bwSize:  row, col size of the returned black and white image
%
%RETURNS:
% bwImage:   black white image containing the positioned tiles


% tSize = [4 4]; tSize = tSize(ones(16,1),:);
% bwSize =[64 64]
% tileImage = rand(prod(tSize(1,:)),16) + 1;

% Initialize parameters
nextLoc = [1 1];
nImages = size(tileImage,2);
bwImage = zeros(size(bwSize));
rowUpdate = max(tSize(:,1));

% We need to think of more interesting placement strategies for
% the pictures.  For example, we could start with all -1s and keep
% putting in tiles (randomly) until we get the whole thing covered.
%
while(nextLoc(1) < bwSize(1))
 while(nextLoc(2) < bwSize(2))
  nextImage = round((nImages-1)*rand(1)) + 1
  r = tSize(nextImage,1); c = tSize(nextImage,2);
  inRow = nextLoc(1):(nextLoc(1)+r-1);
  inCol = nextLoc(2):(nextLoc(2)+c-1);
  bwImage(inRow,inCol) = reshape(tileImage(:,nextImage),r,c);
  nextLoc(2) = nextLoc(2) + c
  rowUpdate = min(rowUpdate,r);
 end
 nextLoc(1) = nextLoc(1) + rowUpdate
 nextLoc(2) = 1;
end
