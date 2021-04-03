%CONSTANTS
data = importdata('data_classify.txt');
nData = size(data,1);
nTrainData = nData*0.7;

trainindex = sort(randperm(size(data,1),nTrainData));
validindex = 1:nData;
validindex(trainindex) = [];

train_data =  data(trainindex,:);
valid_data = data(validindex,:);

nInputs = size(data,2)-1;


 %preallocate

t_input = train_data(:,2:3);
v_input = valid_data(:,2:3);

t_zeta = train_data(:,1);
v_zeta = valid_data(:,1);
%% COMPETETIVE TRAINING
%nodes = 5;
iterations = 3*10^3;
iterationsComp = 10^5;
nRuns = 20;
for nodes = 5
    nodes
gauss = zeros(nodes,1);
learning_rate = 0.02;
sigma = 0.15;
alpha = 0.5;
w_all = InitializeWeights(nodes,nInputs);
r_all = (1:nodes)'; %the row index in the w_all matrix, used in LambdaFunc
%thresh = Initializew_alls(nodes,1);

t_energy = zeros(iterations,nRuns);
v_energy = t_energy;
w_run = zeros(nodes,nInputs,nRuns);
H_t = zeros(iterations,nRuns);
H_v = H_t;
C_t = H_t;
C_v = H_t;
tic
for j = 1:nRuns
    j
   
    for t= 1:iterationsComp
        pattern = datasample(data(:,2:3),1);
        %B = 0;
        %for i = 1:size(w_all,1)
        %    B = B + exp(-norm(pattern-w_all(i,:)).^2/2);
        %end

        for i = 1:nodes       
            %gauss(i) = GaussianFunc(pattern, w_all(i), w_all);
            A = exp(-norm(pattern-w_all(i,:)).^2/2);
            gauss(i) = A;%./B;
        end

        [~, rwin] = max(gauss);

        lambda = LambdaFunc(r_all,rwin,sigma);        

        %UPDATE
        w_all = GradUpdate(w_all, lambda, pattern, learning_rate);
        %sigma = sigma-t/iterations;
        %learning_rate = 0.02*t^(-alpha);
    end
    w_run(:,:,i) = w_all;



% SIMPLE PERCEPTRON (2ab Train Network without hidden layers, sheet3)
clf


gt_input = zeros(size(t_input,1),nodes);
gauss = GaussianFunc(t_input,w_all,w_all);
[~, rwin] = max(gauss,[],2); %Maximum of each row
for i = 1:length(rwin)
    gt_input(i,rwin(i)) = 1; 
end
gv_input = zeros(size(v_input,1),nodes);
gauss = GaussianFunc(v_input,w_all,w_all);
[~, rwin] = max(gauss,[],2); %Maximum of each row
for i = 1:length(rwin)
    gv_input(i,rwin(i)) = 1; 
end


    w_perc = InitializeWeights(1, nodes);
    theta = InitializeWeights(1,1);
    %w_theta = [w_perc, theta];
    k = 1;
    for i = 1:iterations
        
        %Choose random patterns
        r_t = fix(rand*length(train_data))+1; 
        out_t = Output_func(w_perc,gt_input,theta);
        out_v = Output_func(w_perc,gv_input,theta);
       
        [w_perc, theta] = Update_Network(w_perc,t_zeta(r_t),gt_input(r_t,:),out_t(r_t),theta);      
        
        
        
        
        H_t(i,j) = H_func(t_zeta,out_t);
        H_v(i,j) = H_func(v_zeta,out_v);
        C_t(i,j) = Classification_Error(t_zeta,out_t);
        C_v(i,j) = Classification_Error(v_zeta,out_v);  
    end
toc
end
averageClassError_t(nodes) = mean(C_t(end,:));
averageClassError_v(nodes) = mean(C_v(end,:));
end
%%
figure(1)
clf
pt = plot(H_t,'b');
hold on
pv = plot(H_v,'g');
xlabel('time')
ylabel('Energy')
title('Training and validation sets energies over time for 20 experiments')
legend([pv(1) pt(1)], 'Validation', 'Training')

%%
figure(2)
clf
pt = plot(C_t(:,:),'b');
hold on
pv = plot(C_v(:,:),'g');
title('The classification error for the training and validation sets')
xlabel('time')
ylabel('Classification Error')
xlim([0 1000])
legend([pv(1) pt(1)], 'Validation', 'Training')
%%
figure(3)
clf
[X, Y] = meshgrid(-15:0.5:25,-10:0.5:15);
gd_input = zeros(numel(X)*numel(Y),nodes);
gauss = GaussianFunc([X(:),Y(:)],w_all,w_all);
[~, rwin] = max(gauss,[],2); %Maximum of each row
for i = 1:length(rwin)
    gd_input(i,rwin(i)) = 1;
end
out_d = Output_func(w_perc,gd_input,theta);
ind = find(out_d>0);

index1 = find(data(:,1)==-1);
index2 = find(data(:,1)==1);

scatter(data(index1,2),data(index1,3),'r')
hold on
scatter(data(index2,2),data(index2,3),'b')
plot(X(:),Y(:),'r.')    
plot(X(ind),Y(ind),'b.')
scatter(w_all(:,1),w_all(:,2),'g','fill')
legend('-1','+1','Space -1','Space +1','weights')

%%
figure(4)
clf
plot(1:length(averageClassError_t),averageClassError_t, 'b')
hold on
plot(1:length(averageClassError_v),averageClassError_v, 'g')
legend('Training','Validation')
xlabel('Number of nodes')
ylabel('Average classification error')
title('Error depending on the number of nodes')

