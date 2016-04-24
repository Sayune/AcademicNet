classdef FLayer < Layer
    properties
        inputsize;
        outputsize; %number of output neurons
        activfun; %activation function
        a; %matrix of activations
        d; %delta
        w; % weights
        b; %bias vector
        dw;
        db;
        
    end
    methods
        function obj=FLayer(outputsize,activfun)
            obj.type='f'; 
            obj.outputsize=outputsize;
            obj.activfun=activfun;
            
        end
    end
end