function [tileImage, nTiles, tSize] = ...
   makeTileImage(subImageDir, subImageName, scaleFactor, rseed)
%
%  function [allTiles, nTiles, tSize] = 
%         makeTile(subImageDir, subImageName, baseImage, scaleFactor, rseed)
%
% AUTHOR:  H. Hel-Or and B. Wandell
% DATE:    02.6.95
% PURPOSE:
%  Read and scale the size of the tiled images.  Return them in a single 
% matrix whose columns are the black and white tiles.
%
%INPUT ARGUMENTS:
%   subImageDir:  Directory containing the sub-images
%   subImageName:  Matrix whose rows contain the names of the sub-images and
%       the remaining entries are filled with zeros.
%   scaleFactor:  The size of the sub-images is reduced by this factor.
%      For example, if the subimages are 64 by 64 and the scaleFactor is 2,
%      then the images used will be 32 by 32.  If this is not present, then
%      the factor is set to 1.
%
%OPTIONAL:
%   rseed:  A seed to used initiate the random number generator to select
%      the order in which the sub-images are used. If this is not in the
%      parameter list, then the seed is random, drawn from the clock.
%   
%RETURNS:
%   allTiles:  vector containing the data for the tiles.
%   tSize:     vector listing the row(1),col(1) size of the tiles after 
%              scaling
%   nTiles:    Number of image tiles
%              
% directory of small images and large image
% subImageDir = '/grn1/bookCover/new/';   
% baseImage = '/home/gigi/matlab/TILES/eagle.tif';
%      
%  
if(nargin < 3) 
  error('Not enough arguments to makeTile.')
elseif nargin == 3
  scaleFactor = 1;
elseif nargin == 4
  rand('seed',rseed);
end

% Read in the first image to determine the tile size
%
nTiles = size(subImageName,1);
fname = subImageName(1,find(subImageName(1,:)~=0));
[tmp_img tmp_mp] = tiffread([subImageDir fname]);
[rTileSize, cTileSize] = size(tmp_img);
r_index = [1:scaleFactor:rTileSize];
c_index = [1:scaleFactor:cTileSize];
i_len_r = length(r_index);
i_len_c = length(c_index);
i_size = i_len_r*i_len_c;

% Allocate space for the tiled image and copy the first image in
%
allTiles = zeros(i_size,nTiles);
allTiles(:,1) = reshape(tmp_mp(tmp_img(r_index,c_index),1),i_size,1);
tSize = [i_len_r i_len_c];

%  
s = sprintf('Reading small images:\n'); disp(s)
for(i=2:nTiles)
  fname = subImageName(i,find(subImageName(i,:)~=0));
  s = sprintf('  image: %s\n', fname); disp(s)
  [tmp_img tmp_mp] = tiffread([subImageDir fname]);
  if ([rTileSize, cTileSize] ~= size(tmp_img))
    error('all images must be of same size')
  end;
  allTiles(:,i) = reshape(tmp_mp(tmp_img(r_index,c_index),1),i_size,1);
end;

