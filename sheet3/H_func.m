function H = H_func (zeta,out)
%The energy function for sheet 3
    H = 1/2*sum((zeta-out').^2);

end

