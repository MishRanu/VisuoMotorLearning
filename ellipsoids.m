% % image for dart
% image=ones([100 100]);
% imshow(image);
% hold on;
% set( gca,'Units','normalized','Position',[0 0 1 1]);
% line([70 70],[20 30],'Color','k','LineWidth',1);
% f=getframe();
% imwrite(f.cdata,([ 'dart'  '.png']));
% hold off;

im=imread('dart.png');
im=imresize(rgb2gray(im),[100 100]);
im=double(im);
im=reshape(im,100*100,1);
N=size(data,2);
zerE=[];

dart=3955;
for(i=1:N)
    if(data(dart,i)<200) 
        zerE=[zerE i];
    end
end
k=80;
% [P IX]=knn(data(:,zerE(40)),data,k);

for  testI=10:20:length(zerE)
    oneE=[];
    twoE=[];
    thrE=[];
    fouE=[];
    fivE=[];
    [P IX]=knn(data(:,zerE(testI)),data,k,D1(zerE(testI),:));
    eps=3;
    P=P';%d*k
    for i=1:k
        if(P(dart-eps,i)<200 ||P(dart+eps,i)<200)
            oneE=[oneE IX(i)];
        else if(P(dart-2*eps,i)<200 ||P(dart+2*eps,i)<200)
                twoE=[twoE IX(i)];
            else if(P(dart-3*eps,i)<200 ||P(dart+3*eps,i)<200)
                    thrE=[thrE IX(i)];
                else if(P(dart-4*eps,i)<200 ||P(dart+4*eps,i)<200)
                        fouE=[fouE IX(i)];
                    else if(P(dart-5*eps,i)<200 ||P(dart+5*eps,i)<200)
                             fivE=[fivE IX(i)];
                        end
                    end
                end
            end
        end
    end
    randm=zeros(N,1);
    ind=[zerE(testI) oneE];
    ind(2,1:length(twoE)+length(thrE))=[twoE thrE];
    errorEllipse(Y,randm,ind);
end