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

%% Loading and preparing Input
load mnist_double;

%% Architecure & Learning parameters
rand('state',0)



% F/O 

% layers = {
%     Input(28,1)
%     FLayer(1000,ReLU())
%     FLayer(100,ReLU())
%     Output(10,'softmax') %possible change of loss
% };

%C/S/O 

% layers = {
%     Input(28,1)
%     CLayer(6,5,Sigmoid())
%     SLayer(2)
%     CLayer(12,5,Sigmoid())
%     SLayer(2)
%     Output(10,'softmax') %possible change of loss
% };

%C/S/F/O

layers = {
    Input(28,1)
    CLayer(6,5,ReLU())
    SLayer(2)
    CLayer(12,5,ReLU())
    SLayer(2)
    Output(10,'softmax') %possible change of loss
    };

%I/O
% layers = {
%     input
%     Output(10,'softmax')%possible change of loss
% };

net=Network(layers);
net=net.setup();
% net.show() %uncomment to show the network structure

%% Training Settings

%Settings
opts.batchsize = 50;
opts.numepochs = 3 ;

%Optimizer 1
alpha = 1e-1; %optimizer parameter
optimizer1=GD(alpha);

%Optimizer 2
% mom = 0.5;
% momIncrease = 20;
% velocity = zeros(size(theta));
% optimizer2=SGD(mom,momIncrease)


%Training
net = nettrain(net,train_x,train_y,optimizer1,opts);

%% Testing

[er,~,~] = nettest(net,test_x,test_y);
disp(strcat('Accuracy on test labels is:' ,{' '},num2str((1-er)*100),'%'));

%plot mean squared error
figure;
plot(net.rL);

