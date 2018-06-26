% CreateSubImages
% 
% Variables needed:  
%  originalImageDir:
%  nGray:
%  crop:      Region where we crop the image.  This should go away.


%%
cd(originalImageDir)
mp = gray(nGray);

%% List the tiff files

tiffFiles = dir('*.tif');

for ii=1:numel(tiffFiles)
  fname = tiffFiles(ii).name;
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
  % 
  cd(subImageDir)
  imwrite(im,fname); 
  cd(originalImageDir);

end  




