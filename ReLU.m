classdef ReLU<Activfun
    
    methods(Static)

        function s = fun(p)
            s=max(0,p);
        end 
        
        function s = dfun(p)
            s=(p>0) ;
        end
        
    end
    
end