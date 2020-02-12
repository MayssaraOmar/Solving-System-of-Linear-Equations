function [C, err] = GaussJordan(A, B)
    err = false;
    X = [A B];
    i =1;
    [n,m]=size(X);
    while i<=n
        if X(i,i)==0
            fPrintf('Diagonal element zero');
            C = [];
            err = true;
            break;
        end 
        X=Eliminate(X,i);
        i=i+1;
    end 
    C=X(:,m)
end