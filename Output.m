classdef Output < Layer
    
    properties
        inputsize; %number of input neurons
        outputsize; %number of classes
        loss; %loss type
        a; %matrix of probs/activated raw outputs
        d; %delta
        cost;
        w; %weights matrix
        b; %bis vector
        dw;
        db;
    end
    
    methods
        
        function obj=Output(outputsize,loss)
            obj.type='o';
            obj.outputsize=outputsize;
            obj.loss=loss;
        end
        
        function obj=setoutput(obj)
            switch obj.loss
                case 'softmax'
                    obj.a=bsxfun(@minus,obj.a,max(obj.a));
                    obj.a=exp(obj.a); %element_wise exponential
                    S=sum(obj.a);
                    obj.a=bsxfun(@rdivide,obj.a,S);
                case 'l2' %we assume that it is followed by a sigmoid; changeable hypothesis
                    obj.a=Sigmoid().fun(obj.a);
            end
        end
        
        function d=setdelta(obj,E)
            switch obj.loss
                case 'softmax'
                    d=E;
                case 'l2' %assumed to be followed by a sigmoid
                    d=E.*(obj.a.*(1-obj.a));
            end
        end
        
        function cost=setcost(obj,E,y)
            switch obj.loss
                case 'softmax'
                    cost=-sum(sum( (y).* log(obj.a)))/size(E,2); %to replace create NaN 0*log(0)
                case 'l2' %assumed to be followed by a sigmoid
                    cost=1/2* sum(E(:) .^ 2) / size(E,2);
            end
            
        end
    end
end