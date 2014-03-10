function [cImage,cMap] = readBaseImage(fname,nBits)
%
%AUTHOR:  Wandell
%DATE:    nov. 1995
%PURPOSE:
%  Read in the base image

if nargin < 2
 nBits = 8;
end

if nBits == 8
  disp('Reading 8 bit image')
  [cImage cMap] = tiffread(fname);
elseif nBits == 24
  disp('Converting 24 to 8 bits')
  [r g b] = tiffread(fname);
  [cImage cMap] = rgb2ind(r,g,b);
end

