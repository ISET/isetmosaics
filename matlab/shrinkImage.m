function shrinkImage(indir,fname,outdir,nSamples,nGray)
%
%

if nargin < 5
 nGray = 256;
end
mp = gray(nGray);
% figure(1), colormap(mp);

% Reading
%
startDir = cd;
cmd = ['cd ',indir];
eval(cmd)
disp('reading file ...')
[img mp] = tiffread(fname);
img = mp(img);
[m n] = size(img);
disp('Original')
% figure(1), imagesc(img), axis off, axis image

% Blurring
%
s = min(m,n);
img = img(1:s,1:s);
g = mkGaussKernel([s/16 s/16],[s/64 s/64]);
img = conv2(img,g,'valid');
disp('Blurred')
% figure(1), imagesc(img), axis off, axis image

% Now, sample the image down and linearly interpolate
%
[m n] = size(img);
s = min(m,n);
mStep = s/nSamples;
nStep = s/nSamples;
xLoc = 1:mStep:s;
yLoc = 1:nStep:s;
[imgX imgY] = meshgrid(1:s,1:s);
[sampX sampY ] = meshgrid(xLoc,yLoc);
img2 = interp2(imgX, imgY,img,sampX,sampY);
img2 = scale(img2,1,nGray);
% trueShow(img2,mp);

% Write out the new file
%
cmd = ['cd ',outdir];
eval(cmd);

% Intensity image format.  Map is assumed to be gray(256)
tiffwrite(img2,mp,fname);

% Go back to start
%
cmd = ['cd ',startDir];
