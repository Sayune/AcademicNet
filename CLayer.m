classdef CLayer < Layer
    properties
        inputmaps; %depth of input activations
        outputmaps; %number of kernel/depth of layer activations
        kernelsize;
        activfun; %activation function
        mapsize; %Height/Length of activations
        a; %a(j) is a mapsizexmapsizexnumimages activations tensor 
        am; %feature activations in matrix form
        d; %delta
        dm;
        k; %kij refers to the (i,j) kernel
        b; %bias vector
        dk;
        db;
        
    end
    methods
        function obj=CLayer(outputmaps,kernelsize,activfun)
            obj.type='c';
            obj.outputmaps=outputmaps;
            obj.kernelsize=kernelsize;
            obj.activfun=activfun;
            
        end
    end
end