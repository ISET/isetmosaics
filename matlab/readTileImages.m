function tileImages =  readTileImages(subImageDir, maxTileSize, scaleFactor)
%
% tileImages = readTileImages(subImageDir, maxTileSize, scaleFactor)
%
% AUTHOR:  H. Hel-Or and B. Wandell
% DATE:    02.6.95
% PURPOSE:
%  Read and scale the size of the tiled images.  Return them in a single 
% matrix whose columns are the black and white tiles.
%
%INPUT ARGUMENTS:
%   subImageDir:  Directory containing the sub-images
%       the remaining entries are filled with zeros.
%   maxTileImage:  Largest row or column of the tile image
%   scaleFactor:  Reduction of the size of the base image
%
%RETURNS:
%   tileImages:  vector containing the data for the tiles.
%   tSize:     vector listing the row(1),col(1) size of the tiles after 
%              scaling
%              
% Allocate space for the tiled image and copy the first image in
%

%% Read in the names of the tiff files
% 

disp('Reading tile images')

cd(subImageDir)
tiffFiles = dir('*.tif');
nImages = numel(tiffFiles);

tileImages = zeros(prod(maxTileSize/scaleFactor),nImages);

%% Make the tensor of B/W tile images

for (ii = 1:nImages)
  fname = tiffFiles(ii).name;
  fprintf('image: %s\n', fname);
  tmp = imread(fullfile(subImageDir,fname));
  tmp = tmp(1:scaleFactor:end,1:scaleFactor:end);
  if ii == 1
      tileImages = zeros(size(tmp,1),size(tmp,2),nImages);
  end
  tileImages(:,:,ii) = tmp;
end

%%