function w_all = GradUpdate(w_all, lambda, pattern, learning_rate)
    nodes = size(w_all,1);
    nInputs = size(w_all,2);
    dw = w_all;
    for i = 1:nodes
        for j = 1:nInputs
            dw(i,j) = learning_rate*lambda(i)*(pattern(j)-w_all(i,j));
        end
    end
    w_all = w_all + dw;
end

