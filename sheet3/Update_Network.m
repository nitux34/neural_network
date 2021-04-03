function [w, theta] = Update_Network(w,zeta,xi,out,theta)
%Update network with asynchronous back propagation wthout hiddenlayers. I.e update the weights
%and thresholds by choosing a random pattern (as input) to update.
    beta = 1/2;
    learning_rate = 0.1;

    g_deriv = beta*(1-Output_func(w,xi,theta).^2); %out.^2);

    dtheta = -learning_rate*(zeta-out).*g_deriv;
    dw = -dtheta*xi;
    w = w+dw;
    theta = theta+dtheta;


end

