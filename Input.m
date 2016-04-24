classdef Input  < Layer
    properties
        outputmaps; %number of color channels
        numimages;
        mapsize;
        a; % a(colorchannel) is a mapsizexmapsizexnumimages tensor
        am;
        y;
    end
    methods
        function obj=Input(mapsize,outputmaps)
            obj.mapsize=mapsize();
            obj.outputmaps=outputmaps;
        end
        function obj=createinput(obj,images,labels)
            obj.type='i';
            obj.y=labels;
            if obj.outputmaps==3
                obj.numimages=size(images,4);
                for i=1:obj.outputmaps
                    obj.a{i}=squeeze(images(:,:,i,numImages));
                end
            elseif obj.outputmaps==1
                obj.numimages=size(images,3);
                obj.a{1}=images;
            end
        end
    end
end