classdef SLayer < Layer
    properties
        inputmaps; %depth of input activations
        outputmaps;
        scale; %number of output neurons
        mapsize; %Height/Length of activations
        a; %activation maps
        am; %matrix form
        d; %error maps
        dm; %error matrix
     end
    methods
        function obj=SLayer(scale)
            obj.type='s'; 
            obj.scale=scale;
        end
    end
end