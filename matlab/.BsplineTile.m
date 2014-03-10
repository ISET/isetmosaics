function [new_img_r, new_img_g, new_img_b] = ...
  spline_tile(r_img,g_img,b_img,tSize,plevels)
% [new_img_r, new_img_g, new_img_b] = spline_tile(r_img,g_img,b_img,tsize_r,tsize_c,plevels);
%      splines over the tiles in the tile-image given by the three bands: 
%         r_img,g_img,b_img.
%      tsize_r,tsize_c = size of each tiles in pixels.
%      plevels = no of levels of pyramid that should be used in splining.
%                cannot be greater than log2(tsize)+1.
%                if plevels is not given, maximum no of levels is calculated from tsize
%
%

% r_img = r;
% g_img = g;
% b_img = b;
% tSize = tSize;
% plevels = 2;

% Clean this duplication of arguments up.
tsize_r = tSize(1);
tsize_c = tSize(2);
oSize = size(r_img);
osize_r = oSize(1);
osize_c = oSize(2);
if ([osize_r,osize_c] ~= size(g_img)) | ([osize_r,osize_c] ~= size(b_img))
  error('input images must be same size')
end;
if (((floor(osize_r./tsize_r).*tsize_r) ~= osize_r) |   ...
    ((floor(osize_c./tsize_c).*tsize_c) ~= osize_c))
  error('input images must be multiple of tile size')
end;

fSupport = round(max(tSize)/3);
fWidth = fSupport/3;
filt = mkGaussKernel(fSupport,fWidth);
%filt = mkGaussKernel(5,1.4);

big_pyr = constPyramid([osize_r,osize_c],plevels); % create zero pyramids
sz = getpyrSize([osize_r,osize_c],plevels);

disp('First color band');
big_gpyr0 = r_img;
new_osize_r = osize_r;
new_osize_c = osize_c;
new_tsize_r = tsize_r;
new_tsize_c = tsize_c;

for (level = 1:plevels-1)
  big_npyr0 = zeros(sz(level,1),sz(level,2));
  big_gpyr1 = zeros(sz(level+1,1),sz(level+1,2));
  for r=1:new_tsize_r:new_osize_r
    for c=1:new_tsize_c:new_osize_c
      img = big_gpyr0(r:r+new_tsize_r-1,c:c+new_tsize_c-1);
      nimg = convolvecirc(img,filt,[2,2]);
      big_gpyr1((r-1)./2+1:(r-1)./2+ceil(new_tsize_r./2),(c-1)./2+1:(c-1)./2+ceil(new_tsize_c./2)) = nimg;
      big_npyr0(r:r+new_tsize_r-1,c:c+new_tsize_c-1) = expandcirc(nimg,filt,[2,2],[0,0],[new_tsize_r,new_tsize_c]);
    end
  end
  big_pyr = putpyrSubim(big_pyr,big_gpyr0 - 4.* big_npyr0);
  big_gpyr0 = big_gpyr1;
  new_osize_r = ceil(new_osize_r ./ 2);
  new_osize_c = ceil(new_osize_c ./ 2);
  new_tsize_r = ceil(new_tsize_r ./ 2);
  new_tsize_c = ceil(new_tsize_c ./ 2);
end

big_pyr = putpyrSubim(big_pyr,big_gpyr0);
new_img_r = reconPyramid(big_pyr,filt);
new_img_r = clipRange(new_img_r,0,1);

disp('Second color band');
big_pyr0 = createPyramid(g_img,tSize,oSize,plevels);
big_pyr = putpyrSubim(big_pyr,big_gpyr0);
new_img_g = reconPyramid(big_pyr,filt);
new_img_g = clipRange(new_img_g,0,1);


disp('Third color band');
big_gpyr0 = b_img;
new_osize_r = osize_r;
new_osize_c = osize_c;
new_tsize_r = tsize_r;
new_tsize_c = tsize_c;


for (level = 1:plevels-1)
 big_npyr0 = zeros(sz(level,1),sz(level,2));
 big_gpyr1 = zeros(sz(level+1,1),sz(level+1,2));
 for r=1:new_tsize_r:new_osize_r
   for c=1:new_tsize_c:new_osize_c
     img = big_gpyr0(r:r+new_tsize_r-1,c:c+new_tsize_c-1);
     nimg = convolvecirc(img,filt,[2,2]);
     big_gpyr1((r-1)./2+1:(r-1)./2+ceil(new_tsize_r./2),(c-1)./2+1:(c-1)./2+ceil(new_tsize_c./2)) = nimg;
     big_npyr0(r:r+new_tsize_r-1,c:c+new_tsize_c-1) = expandcirc(nimg,filt,[2,2],[0,0],[new_tsize_r,new_tsize_c]);
   end;
 end;
 putpyrSubim(big_pyr,big_gpyr0 - 4.* big_npyr0);
 big_gpyr0 = big_gpyr1;
 new_osize_r = ceil(new_osize_r ./ 2);
 new_osize_c = ceil(new_osize_c ./ 2);
 new_tsize_r = ceil(new_tsize_r ./ 2);
 new_tsize_c = ceil(new_tsize_c ./ 2);
end;

big_pyr = putpyrSubim(big_pyr,big_gpyr0);
new_img_b = reconPyramid(big_pyr,filt);
new_img_b = clipRange(new_img_b,0,1);
