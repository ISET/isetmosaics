function  splinedImage = splineTile(tileImage,tileSize,plevels)
% splinedImage = splineTile(tileImage,tileSize,plevels);
%      splines over the tiles in the tileImage 
%      tileSize = size of each tile in the tileImage.
%      plevels = no of levels of pyramid that should be used in splining.
%                cannot be greater than log2(tileSize)+1.
%                if plevels is not given, maximum no of levels is
%                calculated from tileSize
%
%

% plevels = 2;


tileImageSize = size(tileImage);


if sum((floor(tileImageSize./tileSize).*tileSize) ~= tileImageSize)
  error('input images must be multiple of tile size')
end;
if (nargin < 3)
  plevels = log2(min(tileSize))+1;
else
  if (plevels > log2(min(tileSize))+1)
    error('plevels must not be greater than log2(tileSize) + 1')
  end;
end;

% A 1D filter is required forthe pyramid routines
fSupport = round(max(tileSize)/3);
fWidth = fSupport/3;
filt =mkGaussKernel([1,fSupport],[1,fWidth]);

% for initialization we would like a blank Laplacian Pyramid the
% size of tileImage however there is no such function blankPyr
% so creat the laplacian pyramid of tileImage and overwrite it
% later.
[BigPyr,BigPyr_indices] = buildLpyr(tileImage, plevels, filt);     
for r=1:tileSize(1):tileImageSize(1)./2
  for c=1:tileSize(2):tileImageSize(2)./4
      img = tileImage(r:r+tileSize(1)-1,c:c+tileSize(2)-1);
      [pyr,pyr_indices] = buildLpyr(img, plevels, filt);
      % embed the small pyramid in the big one;
      for (level = 1:plevels)
	bigBand = pyrBand(BigPyr,BigPyr_indices,level);
	smallBand = pyrBand(pyr,pyr_indices,level);
	bigBand(ceil(r/(2^(level-1))):ceil((r+tileSize(1)-1)/(2^(level-1))),...
	    ceil(c/(2^(level-1))):ceil((c+tileSize(2)-1)/(2^(level-1)))) = ...
	    smallBand;
	BigPyr = insertPyrBand(BigPyr,BigPyr_indices,level,bigBand);
      end;
   end;
   fprintf('row %d done\n',r);
end;

splinedImage = reconLpyr(BigPyr,BigPyr_indices,'all', filt);
splinedImage = clipRange(splinedImage,0,1);
