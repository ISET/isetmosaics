function rootPath = mosaicsRootPath()
% Return the path to the root iset directory
%
% This function must reside in the directory at the base of the ISET
% directory structure.  It is used to determine the location of various
% sub-directories.
% 
% Example:
%   fullfile(mosaicsRootPath,'local')

rootPath = which('mosaicsRootPath');

rootPath = fileparts(rootPath);

return
