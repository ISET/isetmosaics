function tileImages =  readTileImages(subImageDir, tileSize)
%
% tileImages = readTileImages(subImageDir, tileSize)
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

cd(subImageDir)
disp('Reading tile images')

% This should be more general than tif soon
tileFiles = dir('*.tif');
nImages = numel(tileFiles);

tileImages = zeros(tileSize(1),tileSize(2),nImages);

%% Make the tensor of B/W tile images

for ii = 1:nImages
  fname = tileFiles(ii).name;
  fprintf('image: %s\n', fname);
  tmp = imread(fullfile(subImageDir,fname));
  tileImages(:,:,ii) = imresize(tmp,tileSize);
end

%%