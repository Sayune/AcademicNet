classdef (Abstract) Optimizer

    methods(Abstract)
        net=applygrads(net,opts);
    end
end