function X  = Eliminate( X,i )
    [n,m]= size(X);
    a=X(i,i);
    X(i,:)=X(i,:)/a;
    for k=1:n
        if k==i
            continue;
        end 
        X(k,:)=X(k,:)-X(i,:)*X(k,i);
    end 
end

