function lambda = LambdaFunc(r, rwin, sigma  )
%The lambdafunction (chapter 6 lecture notes).
% takes r which is the i index of the w_ij. rwin is i index of the winning
% w_ij.
    myNorm = (r-rwin*ones(length(r),1)).^2;
    % lambda = 1./sqrt(2*pi*sigma.^2)*exp(-norm((r-rwin)).^2./(2*sigma.^2))
    lambda = exp(-myNorm./(2*sigma^2));
end


