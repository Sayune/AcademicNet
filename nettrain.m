function net = nettrain(net,x,y,optimizer,opts)
m = size(x, 3); % to implement color input
numbatches = size(x,3) / opts.batchsize; %%to inmplement color input
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
        %to implement color input
        %         for c=1:input.outputmaps
        %             batch_x(:,:,c,:) = x(:,:, kk((l - 1) * opts.batchsize + 1 : l * opts.batchsize));
        %         end
        batch_x = x(:,:, kk((l - 1) * opts.batchsize + 1 : l * opts.batchsize));
        batch_y = y(:, kk((l - 1) * opts.batchsize + 1 : l * opts.batchsize));
        %Training on batch
        net = netfp(net,batch_x,batch_y);
        net = netbp(net,batch_y);
        net = optimizer.applygrads(net);
        disp(strcat('cost on iteration',{' '},num2str(it),{' '},'is',{' '},num2str(net.layers{net.numlayers}.cost))); 
        %Computing Errors
        if isempty(net.rL)
            net.rL(1) =  net.layers{net.numlayers}.cost;
        end
        net.rL(end + 1) = 0.99 * net.rL(end) + 0.01 * net.layers{net.numlayers}.cost;
    end
    toc;
end

end
