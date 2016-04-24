classdef (Abstract) Activfun

    methods(Abstract)
      s = fun(p);
      s = dfun(p);
    end
end