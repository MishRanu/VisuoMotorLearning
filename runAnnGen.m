function runAnnGen(Y,output)
%  learns a neural network from manifold embedding points given to the
%  corresponding parameters given.
% output is a kXN matrix where k represents number of parameters to which
% mapping is required
    input= Y.coords{2};
    global N;
    N= size(Y.coords{2},2);
    input=double(input);
    trainInd = 1:N;
    testInd = 1:N;
    global net;
    %# create ANN and initialize network weights
    net = newpr(input, output, 40);
    net = init(net);
    net.trainParam.epochs = 75;        %# max number of iterations
    %  quer1=quert';
    %# learn net weights from training data
    net = train(net, input(:,trainInd), output(:,trainInd));
    global pred;
    %# predict output of net on testing data
    pred = sim(net, input(:,testInd));

    
    %# predict output of net on testing data
    %  pred1 = sim(net, quer1(:,1));

    %# classification confusion matrix
    [err,cm] = confusion(output(:,testInd), pred);
end