function qCoord=wtLearn(srcdir,querDir,Y)
%function learns the corresponding manifold embedding points for a query image using the interpolation on
%the nearest neighbours in the manifold
% srcDir: directory of the original manifold images
% querDir: directory of the query images
% Y: manifold embedding cell matrix (output of Isomap)
% abcd: type of images to be read
%--------------------------------------------------
%     abc.type='jpg';
%     abcd.type='png';
    k=7;
%     srcdir='F:\thesis\thesis\balldashed\new\';
%     querDir='C:\Users\sunakshi\Dropbox\thesis\thesis\balldashed\new\test\';
%     srcdir='F:\thesis\laws discovering\ballon incline\ordred incline\';
%     querDir='F:\thesis\laws discovering\ballon incline\query\';
% %     srcdir='C:\Users\sunakshi\Dropbox\thesis\laws discovering\crankNpiston\';
% %     querDir='C:\Users\sunakshi\Dropbox\thesis\laws discovering\crankNpiston\test\';
%     addpath ('C:\Users\sunakshi\Dropbox\thesis\laws discovering');
    [data, names] = loadImageDataOrdered(srcdir);
    [qData, qNames]=loadImageDataOrdered(querDir);
%     rmpath ('F:\thesis\laws discovering');
%     data=double(data);
    qData=double(qData);
    D=L2_distance(qData,data,1);

    for testInd=1:size(qData,2)
        [a IX]=sort(D(testInd,:),2);
        for i=1:k
            P(i,:)=data(:,IX(i+1))'; % P is k*d matrix k:nearest neighbours d:dimensionality
        end

        Z=qData(:,testInd)'; % Z is 1*d matrix testInd is any index you want to test from the original data
        X=linsolve(P',Z'); % X comes out to be k*1
%         load([srcdir 'Y1440.mat']);
%         load('F:\thesis\laws discovering\ballon incline\Y100.mat');
        for(i=1:k)
            Q(i,:)=Y.coords{2}(:,IX(i+1)); % Q is k*d' where d'<<d reduced dimensionality
        end
        qCoord(testInd,:)=X'*Q; % qCoord 1:d' containing the q coordinates for query point
        
    end
end