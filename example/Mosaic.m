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


tileSize = [64,64];
% tileRow = 128; tileCol = 128;

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
tileImages = readTileImages(subImageDir,tileSize);
baseImage  = imread(baseImageName,'tif');

%% Change base image to be a multiple of the tiles.
nRow = floor(size(baseImage,1)/tileSize(1))*tileSize(1);
nCol = floor(size(baseImage,2)/tileSize(2))*tileSize(2);
baseImage = imresize(baseImage,[nRow, nCol]);
baseImageSize = size(baseImage);

%% Seems to do the work
tileImages = placeTiles(baseImageSize(1:2),tileImages,'t');
% vcNewGraphWin; imshow(tileImage), axis image

%% This puts all the images together, matching the baseImage

imgMosaic = blendImages(baseImage,tileImages,tileSize);
% vcNewGraphWin; imshow(imgMosaic)

%% Carry below here
% A lot to delete that 


% Now,create the gray level sub images with the crop size.  This
% is currently a script, but it could be a function.  This script
% creates nameList, which is saved.
% 
CreateSubImages

changeDir(dataDir)
save mosaicData originalImageDir subImageDir nGray crop nameList

% If you have already run the stuff above, you can start here
% with 
changeDir(dataDir)
load mosaicData

% Next, make the mosaic from the base image and the sub images.
% The base image should be an 8 bit indexed image.  If it is not
% already an indexed image, you can do this.
% 
% Write this as:  tiff24to8.m(fname);
% fname = 'mentor_poster';
% [r g b] = tiffread(fname);
% [data mp] = rgb2ind(r,g,b);
% newName = sprintf('%s8.tif',fname)
% tiffwrite(data,mp,newName);
% 

% The main mosaic routine
% 

% Reduction factor for the little images, could be 2, 4, 8, whatever.
scaleFactor = 8;  
rseed = 1;

% tiffread appends a .tif to the filname
%
bname = 'fruit256';
[r, g, b, oSize, tSize] = ...
  cmosaic3(subImageDir, [baseImageDir bname], scaleFactor, rseed);

% Write it out with some kind of reasonable name drawn from the
% parameters of the calls
% 
fname = [bname,'.mosaic2.tif'];
changeDir(dataDir) , tiffwrite(r,g,b,fname);
unix(['xv -perfect ',fname,' &']);

% Splining the image gets rid of some of the sharp edges.
% 
fname = [bname,'mosaicS.tif']
plevel = 3;
[rs, gs, bs] = spline_tile(r,g,b,tSize,plevel);
tiffwrite(rs,gs,bs,fname);
% unix(['xv -perfect ', fname,' &']);

changeDir(curDir);
