function fNames = createNameList(f1,f2,f3,f4,f5,f6,f7,f8,f9,f10)
%
%AUTHOR:  Hel-Or, Wandell
%DATE:    May, 1995
%PURPOSE:
%  Create a matrix whose entries contain a list of file names
% that can be read by cmosaic.
%
%ARGUMENTS: 
%  fi:  These are the names
%
%RETURNS:
%
%  fNames:  A matrix with the names in the rows
%

if nargin > 10
 error('createNameList:  Only 10 names at a time.')
end

fNames = zeros(nargin,128);
nFileNames = 1;
for i = 1:nargin
    name = eval(['f' num2str(i)]);
    l = length(name);
    if (l > 128)
        fprintf(1,'fname %s  is longer than 128 chars - not included\n',name);
    else
        fNames(nFileNames,1:l) = name;
        nFileNames = nFileNames + 1;
    end;
end;


