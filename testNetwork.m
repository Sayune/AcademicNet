function testNetwork

clear ;
clc;
%% Prepare Input

%We set the convention that Input must be of the following format 
%images are NORMALIZED DOUBLES (between 0 and 1)  of
%mapsizexmapsizex3xnumImages for RGB images
%or
%mapsizexmapsizexnumImages for Black&White images
%labels are groundtruth     matrices of numClassesxnumImages
%the data must be divided into 
%train_x : training images
%train_y : training labels
%test_x : training images
%test_y : training labels
%See the Class Input to see how it is initialized

load mnist_double;
debug_x=train_x(:,:,1:255);
debug_y=train_y(:,1:255);
% input=Input(28,1);
% input=input.createinput(debug_x,debug_y);
% testSet=Input(test_x,test_y,1);

%% Architecure & Learning parameters
rand('state',0)



% 
% layers = {
%     Input(28,1)
%     FLayer(100,Sigmoid())
%     Output(10,'l2')
% };

layers = {
    Input(28,1)
    CLayer(6,5,Sigmoid())
    SLayer(2)
    CLayer(12,5,Sigmoid())
    SLayer(2)
    Output(10,'l2')
};


% layers = {
%     input
%     Output(10,'softmax')
% };

net=Network(layers);
net=net.setup();
% net.show()
% net=netfp(net,debug_x,debug_y);
% net=netbp(net,debug_y);
%% Training Settings

%Settings
opts.batchsize = 50;
opts.numepochs = 1 ;
%Optimizer 1
alpha = 1; %optimizer parameter
optimizer1=GD(alpha);
%Optimizer 2
% mom = 0.5;
% momIncrease = 20;
% velocity = zeros(size(theta));
% optimizer2=SGD(mom,momIncrease)


%Training
net = nettrain(net,train_x,train_y,optimizer1,opts);

%% Testing
[er,~] = nettest(net,test_x,test_y);
er
%plot mean squared error
figure;
plot(net.rL);
% assert(er<0.12, 'Too big error');
