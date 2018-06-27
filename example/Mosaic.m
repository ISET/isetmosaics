% Mosaic - example
%
% Make a mosaic image with the fruit example in the repository.
% 
% BW, 2018

%% These are the parameters that we need for everything else. 
% 
curDir = cd;

% The directory above the detailed directories
originalImageDir = fullfile(mosaicsRootPath,'example');

% The directory with images that will be used to make tiles
originalTilesDir = fullfile(mosaicsRootPath,'example','originalTiles');

% The base image that will set the color and contrast of the tiles
baseImageDir     = fullfile(mosaicsRootPath,'example','baseImage');
bname         = 'fruit512';
baseImageName = fullfile(baseImageDir,bname);
disp(baseImageName);

% Where we build the cropped tiles (subImages)
subImageDir      = fullfile(mosaicsRootPath,'example','subImage');

% Where we write out the results
dataDir       = fullfile(mosaicsRootPath,'local'); 

tileSize = [16,16];

%% This seems to build up the collection of tiles for the mosaic

% This script might require having all the data files in place
% instead of doing this.
%
cd(dataDir)
if exist(fullfile(dataDir,'mosaicData.mat'),'file')
    % If the file was built and placed in the data directory, load it
    disp('Loading existing mosaicData file')
    load mosaicData
else
    disp('Creating sub-images and building mosaicData file')
    CreateSubImages(originalTilesDir,subImageDir);    
end

%% This routine allows the tile images to be different sizes.  We
% aren't set up for that yet.
tileImages = readTileImages(subImageDir,tileSize,'image type','tif');
baseImage  = imread(baseImageName,'tif');

%% Change base image to be a multiple of the tiles.
nRow = floor(size(baseImage,1)/tileSize(1))*tileSize(1);
nCol = floor(size(baseImage,2)/tileSize(2))*tileSize(2);
baseImage = imresize(baseImage,[nRow, nCol]);
baseImageSize = size(baseImage);

%% Seems to do the work
monochromeTileImages = placeTiles(baseImageSize(1:2),tileImages);
% vcNewGraphWin; imshow(monochromeTileImages)

%% This puts all the images together, matching the baseImage
imgMosaic = blendImages(baseImage,monochromeTileImages,tileSize);

vcNewGraphWin; imshow(imgMosaic); 
vcNewGraphWin; imshow(baseImage)
%%

