classdef GD<Optimizer
    %Here we implement Gradient Descent with a parameter
    properties
        alpha;
    end
    methods
        
        function obj=GD(alpha)
            obj.alpha=alpha;
        end
        
        function net=applygrads(obj,net)
            for l = 2 : net.numlayers
                if (net.layers{l}.type=='c')
                    for j = 1 : net.layers{l}.outputmaps
                        for i = 1 : net.layers{l}.inputmaps
                            net.layers{l}.k{i}{j} = net.layers{l}.k{i}{j} - obj.alpha * net.layers{l}.dk{i}{j};
                        end
                        net.layers{l}.b{j} = net.layers{l}.b{j} - obj.alpha * net.layers{l}.db{j};
                    end
                elseif (net.layers{l}.type=='f' || net.layers{l}.type=='o')
                    net.layers{l}.w = net.layers{l}.w - obj.alpha * net.layers{l}.dw;
                    net.layers{l}.b =  net.layers{l}.b - obj.alpha *  net.layers{l}.db;
                end
            end
        end
        
    end
    
end