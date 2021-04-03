function out_func = Output_func(w,xi,theta)
%The output function of the network
    beta = 1/2;
    w_input_sum = w*xi';
    out_func = (tanh(beta*(w_input_sum-theta)));%repmat(theta,1,size(w_input_sum,2)))));

end

