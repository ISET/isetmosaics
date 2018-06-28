function tileImages = CreateSubImages(originalTilesDir,subImageDir,varargin)
% Start with original tiles, resize and save to subimage directory
%
% Description
%  The images in originalTilesDir are converted to a tile size
%  (default 32x32) and written out to the subImageDir
%
% Inputs
%  originalTilesDir
%  subImageDir
%
% Key/value options
%  image type  - 'jpg' is default but 'tif' or 'png' are possible
%  tileSize    - Tile size
%
% Return
%   tileImage - tileSize by nFiles tensor of images
%
% BW, 1995
%
% See also
%

%%  Parse inputs
varargin = ieParamFormat(varargin);

p = inputParser;
p.addRequired('originalTilesDir',@(x)(exist(x,'dir')));
p.addRequired('subImageDir',@(x)(exist(x,'dir')));
p.addParameter('imagetype','jpg',@ischar);
p.addParameter('tilesize',[32 32],@isvector);

p.parse(originalTilesDir,subImageDir, varargin{:});

imagetype = p.Results.imagetype;
tileSize  = p.Results.tilesize;

%% List the files

cd(originalTilesDir);
srch = ['*.',imagetype];
imgFiles = dir(srch);
nFiles = numel(imgFiles);

tileImages = zeros(tileSize(1),tileSize(2),nFiles);

for ii=1:nFiles
    fname = imgFiles(ii).name;
    disp(fname);
    % The r,g,b values run from [0,1].  So, we average them and
    % then scale them up to nGray range for writing out as tiff.
    %
    [im,mp] = imread(fname);
    % imshow(im);
    
    % Convert the image if index map.
    if ~isempty(mp), rgb = ind2rgb(im,mp);
    else, rgb = im;
    end
    
    % Make it double and resize it
    rgb = double(rgb);
    tile = imresize(rgb,tileSize);
    % vcNewGraphWin; imagesc(rgb); colormap(gray); axis image
    
    % Convert rgb images to black and white
    if ndims(tile) == 3
        tile = rgb2gray(tile);
    end
    
    % Normalize
    tile = ieScale(tile,0,1);
    % vcNewGraphWin; imshow(tile);
    
    tileImages(:,:,ii) = tile;
    
    % Write out the small image time
    cd(subImageDir)
    imwrite(tile,fname);
    
    cd(originalTilesDir);
end




