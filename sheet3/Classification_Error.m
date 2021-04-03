function class_error = Classification_Error(zeta,out)
    p = length(zeta);
    class_error = 1/(2*p)*sum(abs(zeta-sign(out')));
    
end