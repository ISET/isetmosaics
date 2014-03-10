%
% Structure for the new mosaic code
%

curDir = cd;
originalImageDir = '/home/wandell/mosaics/JordanHall/originalTiles/';
subImageDir = '/home/wandell/mosaics/JordanHall/subImage/';
baseImageDir = '/home/wandell/mosaics/JordanHall/baseImage/';
dataDir = '/home/wandell/mosaics/JordanHall/';
bname = 'JordanHall';
baseImageName = [baseImageDir bname]

curDir = cd;
originalTileDir = '/home/wandell/mosaics/panthers/originalTiles/';
subImageDir = '/home/wandell/mosaics/panthers/subImage/';
baseImageDir = '/home/wandell/mosaics/panthers/baseImage/';
dataDir = '/home/wandell/mosaics/panthers/';
bname = 'lion';
baseImageName = [baseImageDir bname]

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
  tileRow = 64; tileCol = 64;
  disp('Creating sub-images and building mosaicData file')
  CreateSubImages
  changeDir(dataDir)
  save mosaicData originalTileDir subImageDir nGray crop nameList
end

% This routine allows the tile images to be different sizes.  We
% aren't set up for that yet.
scaleFactor = 2;
[tileImageList tileSize] =  ...
  readTileImages(subImageDir,[tileRow tileCol],scaleFactor);

% For now, we are insisting on all the tiles being the same size
% 
tileSize = tileSize(1,:);
[baseImage baseMap] = readBaseImage(baseImageName,24);

nRow = floor(size(baseImage,1)/tileSize(1))*tileSize(1);
nCol = floor(size(baseImage,2)/tileSize(2))*tileSize(2);
baseImage = baseImage(1:nRow,1:nCol);
baseImageSize = size(baseImage);
tileImageSize = size(baseImage)

tileImage = placeTiles(tileImageList,tileSize,tileImageSize,'t');

% image(tileImage), colormap(gray(256)), axis image

% At this point we assume the tiles, which are in the columns of
% tileImage, are all the same size (tileSize)
% 
[r g b] = blendImages(baseImage,baseMap,tileImage,tileSize);

% Write it out with some kind of reasonable name drawn from the
% parameters of the calls
% 
mosaicName = [bname,num2str(tileRow/scaleFactor),'.tif'];
fprintf('Saving first mosaic:  %s\n',mosaicName);
changeDir(dataDir), tiffwrite(r,g,b,mosaicName);
% unix(['xv -perfect ',mosaicName,' &']);

[rs gs bs] = splineColorTiles(r,g,b);

[mosaicImage, mosaicMap] = rgb2ind(rs,gs,bs);
