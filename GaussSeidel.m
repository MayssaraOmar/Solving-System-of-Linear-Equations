function [Xres, err] = GaussSeidel(A, B, Xold, maxi, es)
    err = false;
    [n,m] = size(A);
    Xres = [];
    X = Xold;
    i = 1;
    while i <= maxi
        if(A(1,1) == 0)
            err = true;
            disp('division by zero occurred');
            return;
        end
        X(1,:) = (B(1,:) - sum(A(1,2:n).*(X(2:n,:)')))/A(1,1);
        for j=2:n
            if(A(j,j) == 0)
                err = true;
                disp('division by zero occurred');
                return;
            end
            X(j,:) = (B(j,:) - (sum(A(j,:).*(X(:,:)')) - A(j,j) * X(j,:) )) / A(j,j);
        end
        if ~any(X == 0)   
            ea = (abs(X - Xold) ./ X) * 100;
            if all(ea <= es)
                tempres = [i Xold' ea']
                Xres = [Xres; tempres];
                break;
            end
        else
            ea = zeros(n,1);
        end
        Xold = X;
        tempres = [i Xold' ea']
        Xres = [Xres; tempres]
        i = i + 1;
    end
end