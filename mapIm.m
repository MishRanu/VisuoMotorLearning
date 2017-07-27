function mapIm(Y,params,src)
%plot some random 20 images on the manifold learnt and also color it
%according to the parameter you want
%Y: cell matrix containing the low dimensional embedding(eg output from
%Isomap)
% params: parameter you want to color it with.. giv a 1XN zero or one
% matrix if no coloring is required
%src: directory from which the images to be plotted are to be taken
colorNeighGraph(Y,params);
hold on;
k=randperm(length(params),20);
for i=1:20
    j=k(i);
    x=Y.coords{2}(1,j);y=Y.coords{2}(2,j);
    plot(x,y,'ko');
    par=imresize(imread([src num2str(j) '.png']),[50 50]);
    image([x,x+10],[y,y-10],par);
    hold on;
end
end