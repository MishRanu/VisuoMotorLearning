function [qSol, err]=quadFit(Y,ind,eps)
%quadratic fitting of the form Aq1^2+Bq1q2+Cq2^2+Dq1+Eq2+F=eps where q1 and
%q2 are given in Y
    q=zeros(length(ind),2);
    for i=1:length(ind)
        q(i,:)=Y.coords{2}(:,ind(i))';
    end
    N=size(q,1);
    for i=1:N
        a=zeros(1,6);
        a(1)=q(i,1)*q(i,1);
        
%         [a(2),a(3)]=deal(q(i,1)*q(i,2));
%         a(4)=q(i,2)*q(i,2);
%         a(5)=q(i,1);
%         a(6)=q(i,2);
%         a(7)=1;
          a(2)=q(i,1)*q(i,2);
        a(3)=q(i,2)*q(i,2);
        a(4)=q(i,1);
        a(5)=q(i,2);
        a(6)=1;
        A(i,:)=a;
    end
    
    qSol=A\eps;
    exp=[q1*q1 q1*q2 q1*q2 q2*q2 q1 q2]* qSol;
    ezplot(exp);
    err=sum(abs(A*qSol-eps))/N;
%     q1=-50:1:50;
%     A=qSol(1);B=qSol(2)+qSol(3);C=qSol(4);D=qSol(5);E=qSol(6);
%     for i=1:length(q1)
%         q2(i)=(-(B*q1(i)+E)+sqrt((B*q1(i)+E)^2-4*C*(A*q1(i)^2+D*q1(i))))/(2*C);end
    
    %OR x=Y.coords{2}(1,:)';y=Y.coords{2}(2,:)';[U,S,V] = svd([x.^2,x.*y,y.^2,x,y,epsI']);
    % V(:,6) contains the coeff A,B,C,D,E,F resp.
%     plot(q1,q2)
end
