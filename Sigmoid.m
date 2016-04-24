classdef Sigmoid<Activfun
    
    methods(Static)

        function s = fun(p)
            s=1./(1+exp(-p));
        end 
        
        function s = dfun(p)
            s=(1./(1+exp(-p))) .*  (1-1./(1+exp(-p))) ;
        end
        
    end
    
end