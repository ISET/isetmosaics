function [tileImages, tSize] =  ...
   readTileImages(subImageDir, maxTileSize, scaleFactor)
%
% [tileImages, tSize] = makeTile(subImageDir, maxTile,Size scaleFactor)
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

disp('Reading tile images')

% Read in the names of the tiff files
% 
changeDir(subImageDir)
[status tiffFiles] = unix('ls *.tif');
NEWLINE = 10;
indx = find(tiffFiles == NEWLINE);
nImages = length(indx);
indx = [0 indx];

%
tileImages = zeros(prod(maxTileSize/scaleFactor),nImages);

%  
for(i = 1:nImages)
  fname = tiffFiles(indx(i)+1:indx(i+1)-1);
  fprintf('image: %s\n', fname);
  [tmp tmp_mp] = tiffread([subImageDir fname]);
  [r c] = size(tmp);
  tmp = tmp(1:scaleFactor:r,1:scaleFactor:c);
  tSize(i,:) = size(tmp);
  sz = length(tmp(:));
  tileImages(1:sz,i) = tmp(:);
end
