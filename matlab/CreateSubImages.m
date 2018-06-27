function CreateSubImages(originalTilesDir,subImageDir,varargin)
% 
% Variables needed:  
%  originalImageDir:
%  nGray:
%  crop:      Region where we crop the image.  This should go away.
%
% BW
%
% See also
%

%%
p = inputParser;
p.addRequired('originalTilesDir',@(x)(exist(x,'dir')));
p.addRequired('subImageDir',@(x)(exist(x,'dir')));
p.parse(originalTilesDir,subImageDir, varargin{:});

%% List the tiff files

% This should become general image files, and we need to exclude . and
% ..
cd(originalTilesDir);
imgFiles = dir('*.tif');

for ii=1:numel(imgFiles)
  fname = imgFiles(ii).name;
  disp(fname);
  % The r,g,b values run from [0,1].  So, we average them and
  % then scale them up to nGray range for writing out as tiff.
  % 
  [im,mp] = imread(fname);
  rgb = ind2rgb(im,mp);
  % vcNewGraphWin; imagesc(rgb); % colormap(mp)
  
  rgb = imresize(rgb,[64 64]);

  % Convert color images to black and white
  % 
  im = rgb2gray(rgb);
  im = ieScale(im,0,1);
  % vcNewGraphWin; imshow(im);

  % Write out the image
  cd(subImageDir)
  imwrite(im,fname); 
  
  cd(originalTilesDir);
end  




