function errorEllipse(Y,params,indices,embedding)
    if(nargin>3)
        N=size(Y,2);
    else
        N=size(Y.coords{2},2);
    end
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
    end
   
    for k=1:size(indices,1)
        x=[];y=[];
        for i=2:size(indices,2)
            if(indices(k,i)==0) break;end
            C(indices(k,i),:)=[0 0 0];
            x=[x Y.coords{2}(1,indices(k,i))];
            y=[y Y.coords{2}(2,indices(k,i))];
        end
        X=x';
        X(:,2)=y';
        C(indices(1,1),:)=[0 1 1];
    %     C=jet(N);


        Mu = mean( X(:,:) );
        X0 = bsxfun(@minus, X(:,:), Mu);
        % if specify standard deviation
        STD = 01.2;                     %# 2 standard deviations
        conf = 2*normcdf(STD)-1;     %# covers around 95% of population
        scale = chi2inv(conf,2);     %# inverse chi-squared with dof=#dimensions
        Cov = cov(X0) * scale;
        [V D] = eig(Cov);
        %# eigen decomposition [sorted by eigen values]
    %     [V D] = eig( X0'*X0 ./ (sum(idx)-1) );     %#' cov(X0)
        [D order] = sort(diag(D), 'descend');
        D = diag(D);
        V = V(:, order);

        t = linspace(0,2*pi,100);
        e = [cos(t) ; sin(t)];        %# unit circle
        VV = V*sqrt(D);               %# scale eigenvectors
        e = bsxfun(@plus, VV*e, Mu'); %#' project circle back to orig space
        if(nargin>3)
            scatter(Y(1,:),Y(2,:),15,C,'filled');
            hold on;
        else
            scatter(Y.coords{2}(1,:),Y.coords{2}(2,:),15,C,'filled');
            hold on;
        end

        %# plot cov and major/minor axes
        plot(e(1,:), e(2,:), 'Color','k');
    end
    %     plot(x,y,'k','Linewidth',1);
end