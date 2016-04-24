function net=netfp(net,x,y)
n=net.numlayers;
l=2; %index on first f layer
net.layers{1}=net.layers{1}.createinput(x,y); %copy images and labels into first layer
numimages=net.layers{1}.numimages;

%% C/S layers
while(not(net.layers{l}.type=='f' || net.layers{l}.type=='o' ))
    if (net.layers{l}.type=='c')
        for j = 1 : net.layers{l}.outputmaps   %  for each output map
            %  create temp output map
            z= zeros(net.layers{l}.mapsize,net.layers{l}.mapsize,numimages);
            for i = 1 : net.layers{l}.inputmaps   %  for each input map
                %  convolve with corresponding kernel and add to temp output map
                z = z + convn(net.layers{l - 1}.a{i}, net.layers{l}.k{i}{j}, 'valid');
            end
            %  add bias, pass through nonlinearity
            net.layers{l}.a{j} = net.layers{l}.activfun.fun(z + net.layers{l}.b{j});
        end
    end
    if (net.layers{l}.type=='s')
        for j = 1 : net.layers{l}.outputmaps
            z = convn(net.layers{l - 1}.a{j}, ones(net.layers{l}.scale) / (net.layers{l}.scale ^ 2), 'valid');
            net.layers{l}.a{j} = z(1 : net.layers{l}.scale : end, 1 : net.layers{l}.scale : end, :);
        end
    end
    l=l+1;
end

%% connexion to first f layer
%reshape c/s output
am=[]; %possible gain of speed
for j = 1 : net.layers{l-1}.outputmaps
    am = [am; reshape(net.layers{l-1}.a{j}, (net.layers{l-1}.mapsize)^2, numimages)];
end
net.layers{l-1}.am=am;

%possible gain of speed by uniformization
if (net.layers{l}.type=='o')
    net.layers{l}.a=(net.layers{l}.w*net.layers{l-1}.am)+ repmat(net.layers{l}.b,1,numimages);
else
    net.layers{l}.a=(net.layers{l}.activfun.fun( (net.layers{l}.w* net.layers{l-1}.am)+ repmat(net.layers{l}.b,1,numimages)));
end

for s=l+1:n
    if (net.layers{s}.type=='o')
        net.layers{s}.a= (net.layers{s}.w*net.layers{s-1}.a)+ repmat(net.layers{s}.b,1,numimages) ;
    else
        net.layers{s}.a=net.layers{s}.activfun.fun( (net.layers{s}.w*net.layers{s-1}.a) + repmat(net.layers{s}.b,1,numimages));
    end
end

%% setting output
net.layers{n}=net.layers{n}.setoutput();
