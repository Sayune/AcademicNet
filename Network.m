classdef Network
    
    properties
        layers; %vector of layers
        numlayers;
        rL; %to modify
    end
    
    methods
        function obj=Network(layers)
            obj.layers=layers;
            obj.numlayers=size(layers,1);
        end
        
        function show(obj)
            for i=1:obj.numlayers
                    obj.layers{i}
            end
        end
        
        function obj=setup(obj)
            obj=netsetup(obj);
        end
        
%         function obj=fp(obj,x,y)
%             obj=netfp(obj,x,y);
%         end
%         
%         function obj=bp(obj,y)
%             obj=netbp(obj,y);
%         end
        
        
%         function obj=train(obj,x,y,optimizer,opts) 
%             obj=nettrain(obj,x,y,optimizer,opts);
%         end
%         
%         function [er, bad]=test(obj,x,y)
%             [er, bad]=nettest(obj,x,y);
%         end
        
        function obj=gradcheck(obj,x,y)
            obj=netgradcheck(obj,x,y);
        end
      
        function O=getoutput(obj)
           O=obj.layers{obj.numlayers}.a;
        end
        
    end
    
end