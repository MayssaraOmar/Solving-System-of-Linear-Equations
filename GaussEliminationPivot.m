function [X, err] = GaussEliminationPivot(A, B)
    err = false;
    i =1; 
    [n,m]=size(A);
    X=zeros(n,1);
    %foward elimination
    for i=1:n-1
        A
        A(i:n-1,i)
        [M, I] = max(abs(A(i:n,i)))
        temp = A(i,:)
        I = I + i - 1
        A(i,:) = A(I,:)
        A(I,:)=temp
        temp = B(i,:);
        B(i,:) = B(I,:);
        B(I,:)=temp;
        if(A(i,i) == 0)
            err = true;
            i
            disp('division by zero occurred');
            return;
        end
        a=A(i+1:n,i)/A(i,i); 
        A(i+1:n,:)= A(i+1:n,:)-a*A(i,:)
        B(i+1:n,:)= B(i+1:n,:)-a*B(i,:)
    end 
    %back substitution
    if(A(n,n) == 0)
        err = true;
        disp('division by zero occurred');
        return;
    end
    X(n,:)=B(n,:)/A(n,n);
    for i=n-1:-1:1
        if(A(i,i) == 0)
            err = true;
            disp('division by zero occurred');
            return;
        end
        X(i,:)=(B(i,:)-A(i,i+1:n)*X(i+1:n,:))/A(i,i)
    end
end