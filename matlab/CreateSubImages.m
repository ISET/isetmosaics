function CreateSubImages(originalTilesDir,subImageDir,varargin)
% Start with original tiles, resize and save to subimage directory
%
% Inputs
%  originalTilesDir
%  subImageDir
%
% Key/value options
%  image type  - 'jpg' is default but 'tif' or 'png' are possible
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

p.parse(originalTilesDir,subImageDir, varargin{:});

imagetype = p.Results.imagetype;

%% List the files

cd(originalTilesDir);
srch = ['*.',imagetype];
imgFiles = dir(srch);

for ii=1:numel(imgFiles)
  fname = imgFiles(ii).name;
  disp(fname);
  % The r,g,b values run from [0,1].  So, we average them and
  % then scale them up to nGray range for writing out as tiff.
  % 
  [im,mp] = imread(fname);
  if ~isempty(mp), rgb = ind2rgb(im,mp); 
  else, rgb = im;
  end
  % vcNewGraphWin; imagesc(rgb); % colormap(mp)
  
  rgb = imresize(rgb,[64 64]);

  % Convert color images to black and white
  im = double(rgb2gray(rgb));
  im = ieScale(im,0,1);
  % vcNewGraphWin; imshow(im);

  % Write out the small image time
  cd(subImageDir)
  imwrite(im,fname); 
  
  cd(originalTilesDir);
end  




