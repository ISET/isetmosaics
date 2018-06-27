function tileImages =  readTileImages(subImageDir, tileSize, varargin)
%
% tileImages = readTileImages(subImageDir, tileSize, varargin)
%
% Description
%  Read and scale the size of the tiled images.  Return them in a single
%  row,col,nImage tensor scaled to 0,1;
%
% Inputs
%   subImageDir:  Directory containing the sub-images 
%   tileSize:     Size of the tiles after resizing (row,col) 
%
% Optional key/value
%   image type:  image file type (default 'png')
%
%RETURNS:
%   tileImages:  row x col x nImages, scaled to 0,1
%
% H. Hel-Or and B. Wandell, 02.6.95
%
% See also
%   blendImages


%% Read in the names of the image files

varargin = ieParamFormat(varargin);

p = inputParser;
p.addRequired('subImageDir',@(x)(exist(subImageDir,'dir')));
p.addRequired('tileSize',@isvector);
p.addParameter('imagetype','png',@ischar);

p.parse(subImageDir,tileSize,varargin{:});

imageType = p.Results.imagetype;

%%
cd(subImageDir)
disp('Reading tile images')

% Find all the files of a given type
srch      = ['*.',imageType];
tileFiles = dir(srch);
nImages   = numel(tileFiles);

% Allocate size for the tiles after they are resized.
tileImages = zeros(tileSize(1),tileSize(2),nImages);

%% Make the tensor of B/W tile images

for ii = 1:nImages
  fname = tileFiles(ii).name;
  fprintf('image: %s\n', fname);
  tmp = imread(fullfile(subImageDir,fname));
  tileImages(:,:,ii) = imresize(tmp,tileSize);
end

%%