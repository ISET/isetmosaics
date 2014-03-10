function img = create_random(osize_r,osize_c,subImageName,scaleFactor,rseed)

if(nargin < 3) 
  fprintf(1,'img = create_random(osize_r,osize_c,i_name_array[,scaleFactor,rseed])\n');
elseif nargin == 3
  scaleFactor = 1;
elseif nargin == 4
 ;
elseif nargin == 5
  rand('seed',rseed);
end
 
num_i_img = size(subImageName,1);
subImageDir = './';
fname = subImageName(1,find(subImageName(1,:)~=0));
[tmp_img tmp_mp] = tiffread([subImageDir fname]);
[i_size_r, i_size_c] = size(tmp_img);
r_index = [1:scaleFactor:i_size_r];
c_index = [1:scaleFactor:i_size_c];
i_len_r = length(r_index);
i_len_c = length(c_index);
i_size = i_len_r*i_len_c;
i_img = zeros(i_size,num_i_img);
i_img(:,1) = reshape(tmp_mp(tmp_img(r_index,c_index),1),i_size,1);
%  
disp(['reading in small image ' fname]);
for(i=2:num_i_img)
  fname = subImageName(i,find(subImageName(i,:)~=0));
  disp(['reading in small image ' fname])
  [tmp_img tmp_mp] = tiffread([subImageDir fname]);
  if ([i_size_r, i_size_c] ~= size(tmp_img))
    error('all images must be of same size')
  end;
  i_img(:,i) = reshape(tmp_mp(tmp_img(r_index,c_index),1),i_size,1);
end;
 

osize_r = floor(osize_r./i_len_r).*i_len_r;
osize_c = floor(osize_c./i_len_c).*i_len_c;
fprintf(1,'Creating image of size %d %d\n',osize_r,osize_c);
img = zeros(osize_r,osize_c);

for r=1:i_len_r:osize_r
  for c=1:i_len_c:osize_c
    i_index = ceil(num_i_img.*rand(1));   % random number 1:num_i_img
    s_img = i_img(:,i_index);
    img(r:r+i_len_r-1,c:c+i_len_c-1) = reshape(i_img(:,i_index),i_len_r,i_len_c);
end;
end;
