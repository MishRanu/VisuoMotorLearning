function colorNeighGraph(Y,params,C,embedding)
%params: 1XN or NX1 matrix of the parameter which is used to color the
%manifold
  
    if(nargin>4)%if color code is given C(NX3) and Y is a dXN vector not a cell matrix
        N=size(Y,2);
    else
        N=size(Y.coords{2},2);%if Y is the cell matrix as output from Isomap
    end
    if nargin~=3
        C=zeros(N,3);
        mins=min(params);
        maxs=max(params);
        diff=(maxs-mins)/5;
        for i=1:N
    %         if params(i)>44 && params(i)<46
    %             C(i,:)=[0 0 0];
    %         else
            
            if params(i)<mins+diff
                 C(i,:)=[1 1 0];%yellow
            else if params(i)<mins+2*diff
                 C(i,:)=[1 0 1];%magenta
                else if params(i)<mins+3*diff
                        C(i,:)=[1 0 0];%red
                    else if params(i)<mins+4*diff
                            C(i,:)=[0 1 0];%green
                        else C(i,:)=[0 0 1];%blue
                        end
                    end
                end
    %         end
            end
%             if params(i)==mins
%                 C(i,:)=[0 0 0];
%             end
        end
     end
%     C=jet(N);
%     C(1,:)=[0 0 0];
    if(nargin>4)
        scatter(Y(1,:),Y(2,:),15,C,'filled');
        hold on;
    else
        scatter(Y.coords{2}(1,:),Y.coords{2}(2,:),15,C,'filled');
        hold on;
    end
%     plot(x,y,'k','Linewidth',1);
% hold off;
twod=2;
% gplot(params(Y.index, Y.index), [Y.coords{twod}(1,:); Y.coords{twod}(2,:)]'); 
end