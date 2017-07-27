function [sae, saeTrain]= babyLearn()
    load('C:\Users\Anurag Misra\Documents\MATLAB\SE\data\vel.mat');
%     load('C:\Users\Sunakshi\Dropbox\thesis\laws discovering\results\parabola\Resvel500.mat');
%     vel=vel500;
    sae=[];
    saeTrain=[];
    for i=1:1
%         i=4;
        if i==1
            d=50;
        else
            d=2*(i-1)*100;
        end
        load(['C:\Users\Sunakshi\Dropbox\thesis\laws discovering\results\parabola\Y' num2str(d) '.mat']);
        load(['C:\Users\Sunakshi\Dropbox\thesis\laws discovering\results\parabola\names' num2str(d) '.mat']);
        for p=1:length(names)
            nam(p)=str2num(cell2mat(names(p)));
        end
        names=nam;
        for(i=1:size(names,2))
            output(i)=vel(names(i));
        end
        runAnnGen(Y,output);
        global net;
%         save (['C:\Users\Sunakshi\Dropbox\thesis\laws discovering\results\parabola\MorResnet' num2str(d) '.mat'], 'net');
%         wtlearnProgressive;
%         save (['C:\Users\Sunakshi\Dropbox\thesis\laws discovering\results\parabola\qCoord' num2str(d) '.mat'], 'qCoord');
        load(['C:\Users\Sunakshi\Dropbox\thesis\laws discovering\results\parabola\qCoord' num2str(d) '.mat']);
        pred=sim(net,qCoord');
        load('C:\Users\Sunakshi\Dropbox\thesis\thesis\balldashed\new\test\velPara.mat');
        sae=[sae sum(abs(pred'-velPara))/length(velPara)];
        pred1=sim(net,Y.coords{2});
        saeTrain=[saeTrain sum(abs(pred1-output))/length(output)];
%         disp(saeTrain);
    end