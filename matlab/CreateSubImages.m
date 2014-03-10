% script
% 
% Variables needed:  
%  originalImageDir:
%  nGray:
%  crop:      Region where we crop the image.  This should go away.


changeDir(originalImageDir)
mp = gray(nGray);
[status tiffFiles] = unix('ls *.tif');

% On a Mac, this should be 13
% 
NEWLINE = 10;
indx = find(tiffFiles == NEWLINE);
indx = [0 indx];
for (i=2:length(indx))
  fname = tiffFiles(indx(i-1)+1:indx(i)-1);
  disp(fname);
  % The r,g,b values run from [0,1].  So, we average them and
  % then scale them up to nGray range for writing out as tiff.
  % 
  [im,mp] = tiffread(fname);
  imSize = size(im);

  % Crop the image
  % 
  im = imCrop(im(:),crop,imSize);
  cropSize = crop(2,:) - crop(1,:) + 1;
  im = reshape(im,cropSize);

  % Convert color images to black and white
  % 

  % Write out the image
  % 
  changeDir(subImageDir)
  tiffwrite(im,mp,fname); 
  changeDir(originalImageDir);

end  




