% image mosaics:  Structure for the new mosaic code
%

%% This is one example data set
curDir = cd;
originalImageDir = '/home/gigi/MATLAB/MOSAICS/TRY/originalTiles/';
subImageDir = '/home/gigi/MATLAB/MOSAICS/TRY/subImage/';
baseImageDir = '/home/gigi/MATLAB/MOSAICS/TRY/baseImage/';
dataDir = '/home/gigi/MATLAB/MOSAICS/TRY/';
bname = 'fruit512';
baseImageName = [baseImageDir bname]

%% Another example data set
curDir = cd;
originalTileDir = '/home/wandell/mosaics/panthers/originalTiles/';
subImageDir = '/home/wandell/mosaics/panthers/subImage/';
baseImageDir = '/home/wandell/mosaics/panthers/baseImage/';
dataDir = '/home/wandell/mosaics/panthers/';
bname = 'lion';
baseImageName = [baseImageDir bname]

%% This seems to build up the collection of tiles for the mosaic

% This script might require having all the data files in place 
% instead of doing this.
% 
changeDir(dataDir)
if check4File('mosaicData')
  disp('Loading existing mosaicData file')
  load mosaicData
else
  nGray = 220; 
  crop = [1 1; 64 64]
  tileRow = 128; tileCol = 128;
  disp('Creating sub-images and building mosaicData file')
  CreateSubImages
  changeDir(dataDir)
  save mosaicData originalTileDir subImageDir nGray crop nameList
end

% This routine allows the tile images to be different sizes.  We
% aren't set up for that yet.
scaleFactor = 2;
[tileImageList, tileSize] =  ...
  readTileImages(subImageDir,[tileRow tileCol],scaleFactor);

% For now, we are insisting on all the tiles being the same size
tileSize = tileSize(1,:);
[baseImage, baseMap] = readBaseImage(baseImageName,24);

%% Change base image to be a multiple of the tiles.
nRow = floor(size(baseImage,1)/tileSize(1))*tileSize(1);
nCol = floor(size(baseImage,2)/tileSize(2))*tileSize(2);
baseImage = baseImage(1:nRow,1:nCol);
baseImageSize = size(baseImage);
tileImageSize = size(baseImage);

%% Seems to do the work
tileImage = placeTiles(tileImageList,tileSize,tileImageSize,'t');

% image(tileImage), colormap(gray(256)), axis image


% At this point we assume the tiles, which are in the columns of
% tileImage, are all the same size (tileSize)

%% This must do something
[r g b] = blendImages(baseImage,baseMap,tileImage,tileSize);

%% Write it out with some kind of reasonable name 
% This is drawn from the parameters of the calls
% 
mosaicName = [bname,num2str(tileRow/scaleFactor),'.tif'];
fprintf('Saving first mosaic:  %s\n',mosaicName);
changeDir(dataDir), tiffwrite(r,g,b,mosaicName);
% unix(['xv -perfect ',mosaicName,' &']);

%% Now what?
SplinedTileImage = splineTile(tileImage,tileSize,3);

[mosaicImage, mosaicMap] = rgb2ind(rs,gs,bs);

%% End