function blendImages(baseImage,baseMap,tileImage,tileSize) 
% 
%  mosaic = blendImages(baseImage,baseMap,tileImage,tileSize) 
% 
% AUTHOR:
% 
% 
% 
% 
% 


for r=1:tileSize(1):size(baseImage,1)
  for c=1:tileSize(2):size(baseImage,2)

    img = oimg(r:r+tileSize(1)-1,c:c+tileSize(2)-1);
    mp = omp(reshape(img,1,i_size),1:3);
    mean_mp = mean(mp);
    norm_mp = mp - ones(size(mp,1),1)*mean_mp;
    cov_mp = norm_mp'*norm_mp;
    [u s v] = svd(cov_mp);
    m1 = pinv(sqrt(s))*u';

    i_index = ceil(num_i_img.*rand(1));   % random number 1:num_i_img
    s_img = i_img(:,i_index);

% assume s_img is BW and has gs values not indices
    mean_s = mean(s_img);
    norm_s = s_img - mean_s;
    cov_s = [norm_s norm_s norm_s]' *[norm_s norm_s norm_s];
    [u,s,v] = svd(cov_s);
    x = zeros(3,3); x(1,1) = 1 / sqrt(s(1,1));
    m2 = x*u';
    
% transform s_img into new color indices
    s_img = pinv(m1)*m2*[norm_s norm_s norm_s]';
    s_img = s_img + mean_mp'*ones(1,size(s_img,2));

% clipping s_img values
    s_img(find(s_img<0.0)) = zeros(size(find(s_img<0.0)));
    s_img(find(s_img>1.0)) = ones(size(find(s_img>1.0)));

% copying new small image to new big image
    new_img_r(r:r+tileSize(1)-1,c:c+tileSize(2)-1) = reshape(s_img(1,:),tileSize(1),tileSize(2));
    new_img_g(r:r+tileSize(1)-1,c:c+tileSize(2)-1) = reshape(s_img(2,:),tileSize(1),tileSize(2));
    new_img_b(r:r+tileSize(1)-1,c:c+tileSize(2)-1) = reshape(s_img(3,:),tileSize(1),tileSize(2));
  end;
  disp(int2str(i_index))
end;
disp('')
