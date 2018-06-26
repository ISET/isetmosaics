% script
%
% Make a mosaic image of the Panther's
% 


% These are the parameters that we need for everything else. 
% 
curDir = cd;
originalImageDir = '/home/gigi/MATLAB/MOSAICS/TRY/originalImage/';
subImageDir = '/home/gigi/MATLAB/MOSAICS/TRY/subImage/';
baseImageDir = '/home/gigi/MATLAB/MOSAICS/TRY/baseImage/';
dataDir = '/home/gigi/MATLAB/MOSAICS/TRY/';
routinesDir = '/home/gigi/MATLAB/MOSAICS/Distribution/';
nGray = 220; 
crop = [1 1; 128 128];

path(path,routinesDir);
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
