function [X, err] = LUDecomposition(A, B)
    err = false;
    i =1; 
    [n,m]=size(A);
    X=zeros(n,1);
    Y = zeros(n,1);
    L = zeros(n,n);
    for i=1:n
        for j=1:i
            if(i==j)
                L(i,j) = 1;
            end
        end
    end
    for i=1:n-1
        if(A(i,i) == 0)
            err = true;
            disp('division by zero occurred');
            return;
        end
        L(i+1:n,i) = A(i+1:n,i)/A(i,i);
        A(i+1:n,:)= A(i+1:n,:)-L(i+1:n,i)*A(i,:);
    end
    %forward substitution
    Y(1,:)=B(1,:);
    for i=2:n
        Y(i,:)=B(i,:)-L(i,1:i-1)*Y(1:i-1,:);
    end
    %back substitution
    if(A(n,n) == 0)
        err = true;
        disp('division by zero occurred');
        return;
    end
    if(A(n,n) == 0)
        err = true;
        disp('division by zero occurred');
        return;
    end
    X(n,:)=Y(n,:)/A(n,n);
    for i=n-1:-1:1
        if(A(i,i) == 0)
            err = true;
            disp('division by zero occurred');
            return;
        end
        X(i,:)=(Y(i,:)-A(i,i+1:n)*X(i+1:n,:))/A(i,i);
    end
end