function net = nettrain(net,x,y,optimizer,opts)
if (net.layers{1}.outputmaps==3)
    m=size(x,4);
elseif(net.layers{1}.outputmaps==1)
    m=size(x,3);
else
    error('Only RGB and BW Inputs are supported')
end
numbatches =m / opts.batchsize;

if rem(numbatches, 1) ~= 0
    error('numbatches not integer');
end
net.rL = [];
it=0;
for i = 1 : opts.numepochs
    disp(['epoch ' num2str(i) '/' num2str(opts.numepochs)]);
    tic;
    kk = randperm(m);
    for l = 1 : numbatches
        it=it+1;
        %SettingBatch
        if (net.layers{1}.outputmaps==3)
            batch_x = x(:,:,:,kk((l - 1) * opts.batchsize + 1 : l * opts.batchsize));
            batch_y = y(:, kk((l - 1) * opts.batchsize + 1 : l * opts.batchsize));
        else %necessarely one color channel due to error thrown
            batch_x = x(:,:, kk((l - 1) * opts.batchsize + 1 : l * opts.batchsize));
            batch_y = y(:,kk((l - 1) * opts.batchsize + 1 : l * opts.batchsize));
        end
        %Training on batch
        net = netfp(net,batch_x,batch_y);
        net = netbp(net,batch_y);
        net = optimizer.applygrads(net);
        disp(strcat('Epoch',{' '},num2str(i),':',{' '},'cost on iteration',{' '},num2str(it),{' '},'is',{' '},num2str(net.layers{net.numlayers}.cost)));
        %Computing Errors
        if isempty(net.rL)
            net.rL(1) =  net.layers{net.numlayers}.cost;
        end
        net.rL(end + 1) = 0.99 * net.rL(end) + 0.01 * net.layers{net.numlayers}.cost;
    end
    toc;
end

end
