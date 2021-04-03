function output = GaussianFunc(x, w, w_all)

    output = zeros(size(x,1), size(w_all,1));
    B = 0;
    for i = 1:size(w_all,1)
        w_all_rep = repmat(w_all(i,:),size(x,1),1);
        B = B + exp(-sum((x-w_all_rep).^2,2)/2);
    end

    for j = 1:size(w_all,1)
        w_rep = repmat(w_all(j,:),size(x,1),1);
        A = exp(-sum((x-w_rep).^2,2)/2);
        output(:,j) = A./B;
    end

end

