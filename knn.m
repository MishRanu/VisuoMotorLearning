function [P IX]=knn(qData,data,k,D)
   if nargin<4
       disp('L2 dist used');
       D=L2_distance(qData,data,1);
   end

    for testInd=1:size(qData,2)
        [a IX]=sort(D(testInd,:),2);
        for i=1:k
            P(i,:)=data(:,IX(i+1))'; % P is k*d matrix k:nearest neighbours d:dimensionality
        end
    end
end