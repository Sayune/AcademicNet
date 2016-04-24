function net=netsetup(net)
l=2; %index on first f layer
while(not(net.layers{l}.type=='f' || net.layers{l}.type=='o' ))
    
    if (net.layers{l}.type=='s')
        net.layers{l}.inputmaps=net.layers{l-1}.outputmaps;
        net.layers{l}.outputmaps=net.layers{l-1}.outputmaps;
        net.layers{l}.mapsize=net.layers{l-1}.mapsize/net.layers{l}.scale;
    end
    
    if (net.layers{l}.type=='c')
        net.layers{l}.inputmaps=net.layers{l-1}.outputmaps;
        net.layers{l}.mapsize=net.layers{l-1}.mapsize-net.layers{l}.kernelsize+1;
        nbOut=net.layers{l}.outputmaps * net.layers{l}.kernelsize ^ 2; %number of lateral neurons
        for j = 1 : net.layers{l}.outputmaps
            nbIn = net.layers{l}.inputmaps * net.layers{l}.kernelsize ^ 2; %number of volume neurons
            for i = 1 : net.layers{l}.inputmaps
                net.layers{l}.k{i}{j} = (rand(net.layers{l}.kernelsize) - 0.5) * 2 * sqrt(6 / (nbIn + nbOut));
            end
            net.layers{l}.b{j} = 0;
        end
    end
    l=l+1;
end

%Init of first f layer
net.layers{l}.inputsize=(net.layers{l-1}.outputmaps)*((net.layers{l-1}.mapsize)^2);
net.layers{l}.w=(rand(net.layers{l}.outputsize,net.layers{l}.inputsize)-0.5)*2*sqrt(6/(net.layers{l}.outputsize+net.layers{l}.inputsize));
net.layers{l}.b=zeros(net.layers{l}.outputsize,1);

%Init of the rest of f layers and output layer
for s=l+1:net.numlayers
    net.layers{s}.inputsize=net.layers{s-1}.outputsize;
    net.layers{s}.w=(rand(net.layers{s}.outputsize,net.layers{s}.inputsize)-0.5)*2*sqrt(6/(net.layers{s}.outputsize+net.layers{s}.inputsize));
    net.layers{s}.b=zeros(net.layers{s}.outputsize,1);
end

end