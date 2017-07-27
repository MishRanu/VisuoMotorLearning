function [ data, names ] = loadImageDataOrdered( srcDir, options)
%%  Description: loadImageDataOrdered
%       - loads all the images of the given directory into a matrix
%           it reads the images in ordered way according to the number
%           present in the name eg. images will be read in the order
%           img1,img2,img3...imgN rather than img1,img10,img11..etc
%   Parameters:
%       - srcDir: Source directory
%       - type  : File type. (for example jpg)
%               : = jpg if nothing is given
%
%   Output:
%       - data  : Output matrix containing all the images 
%               : as 10,000 dimensional vectors
%       - names : File names corresponding to each image.
%
%
%   Example: To load all the images from 'nao200' directory
%      
%       >> [data, names] = loadImageData('nao200', 'jpg');
%
%
    if(nargin < 2)
        options = struct();
    end
    if ~isfield(options, 'type')
        options.type = 'png';
    end
    if ~isfield(options, 'mode')
        options.mode = 'rgb';
    end
    
    data = [];
    names = {};
    files = dir([srcDir '/*.' options.type]);
    
    if ~isfield(options, 'N')
        options.N = length(files);
    end
     if ~isfield(options, 'd')
        options.d = options.N;
    end
    
    N = min(options.N, length(files));
    tic;
    fprintf('Loading %d images ', options.d);
    figname=[];
    A = isstrprop(files(1).name, 'digit');
    t=1;
    oneNam=files(1).name;
    while (A(t)==0)
       figname=[figname oneNam(t)];
       t=t+1;
    end
    for i=1:options.d
        if(mod(i, ceil(N/50)) == 0)
            fprintf('.');
        end
        %--% 
        c=num2str(i);
        img = imread([srcDir '/' figname c '.' options.type]);
%         img = imread([srcDir '/' files(i).name]);
        if strcmp(options.mode, 'grayscale')
            img = rgb2gray(img);
        end
        img = rgb2gray(img);
        img = imresize(img, [100 100]); 
        [irow icol] = size(img);

        temp = reshape(img,irow*icol,1);    % Reshaping 2D images into 1D image vectors
        data = [data temp];                 % 'data' grows after each iteration
%         temp = regexp(files(i).name, '\.', 'split');
%         names{i} = temp(1);
        names{i}=[figname c];
    end
    fprintf(' done!\n');
    toc;
end