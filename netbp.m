function net=netbp(net,y)

%% OutputLayer
n=net.numlayers;
numimages=net.layers{1}.numimages;
E=net.layers{n}.a-y; %could be a property of Output  
net.layers{n}.d=net.layers{n}.setdelta(E);
%Setting loss
net.layers{n}.cost=net.layers{n}.setcost(E,y);

%% bp to F-Layers if they exist
l=n-1;
%NB: Fix the input->output case
while(not(net.layers{l}.type=='c' || net.layers{l}.type=='s' ) && l>=2)
    net.layers{l}.d=(net.layers{l+1}.w'*net.layers{l+1}.d).* net.layers{l}.activfun.dfun(net.layers{l}.a) ;
    l=l-1;
end
%l indexes last C/S-Layer & l+1 indexes first F/O-Layer
%bp to Last C-layer connexion
dm=(net.layers{l+1}.w)'*net.layers{l+1}.d;
if (net.layers{l}.type=='s')
    net.layers{l}.dm=dm;
elseif (net.layers{l}.type=='c')
    net.layers{l}.dm=dm.*(net.layers{l}.activfun.dfun(net.layers{l}.am));
elseif (net.layers{l}.type=='i')
else
    error (str2cat('Network badly configured at layer',num2str(l)))
end


%%  bp to C/S layers
%Reshaping delta of last C/S-Layer into map style
if (net.layers{l}.type=='s' || net.layers{l}.type=='c')
m=net.layers{l}.mapsize;
%dm is a (outputmaps.mapsize.mapsize)xnumimages
%d is a outputmapsxmapsizexmapsizexnumimages map/tensor

for j = 1 : net.layers{l}.outputmaps
    net.layers{l}.d{j} = reshape(net.layers{l}.dm(((j - 1)*(m^2) + 1):j*(m^2), :),m,m, numimages);
end
end

for s = l-1: -1 : 2
    if (net.layers{s+1}.type=='s') % c->s
        for j = 1 : net.layers{s}.outputmaps
            net.layers{s}.d{j} = net.layers{s}.activfun.dfun(net.layers{s}.a{j}).* (expand(net.layers{s + 1}.d{j}, [net.layers{s + 1}.scale net.layers{s + 1}.scale 1]) / net.layers{s + 1}.scale ^ 2);
        end
    elseif (net.layers{s+1}.type=='c') %We assume only c ->c and c->s cases
        for i = 1:net.layers{s}.outputmaps
            z = zeros(net.layers{s}.mapsize,net.layers{s}.mapsize,numimages);
            for j = 1 : net.layers{s + 1}.outputmaps
                z = z + convn(net.layers{s + 1}.d{j}, rot180(net.layers{s + 1}.k{i}{j}), 'full');
            end
            net.layers{s}.d{i} = z;
        end
    end
end

%% gradients

%C/S layers
for s = 2 : l
    if (net.layers{s}.type=='c')
        for j = 1 :net.layers{s}.outputmaps
            for i = 1 :net.layers{s - 1}.outputmaps
                net.layers{s}.dk{i}{j} = convn(flipall(net.layers{s- 1}.a{i}), net.layers{s}.d{j}, 'valid') /numimages;
            end
            net.layers{s}.db{j} = sum(net.layers{s}.d{j}(:)) / numimages;
        end
    end
end

%First F-Layer
net.layers{l+1}.dw=(net.layers{l+1}.d)*(net.layers{l}.am)'/numimages;
net.layers{l+1}.db=mean(net.layers{l+1}.d,2);

%Flayers
for s = l+2 : n
    net.layers{s}.dw=(net.layers{s}.d)*(net.layers{s-1}.a)'/numimages;
    net.layers{s}.db=mean(net.layers{s}.d,2);
end
