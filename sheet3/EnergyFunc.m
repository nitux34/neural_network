function energy = EnergyFunc(w_all, input, lambda)

    nodes = size(w_all,1);
    energy = 0;
    
    for i = 1:nodes
        myNorm = norm(input-repmat(w_all(i,:),size(input,1),1))^2;
        energy = energy + 1/2*myNorm.*lambda(i);
    end
end

