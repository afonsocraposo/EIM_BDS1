classdef Volume
    properties
        layers=cell(0);
        slices;
        layer=1;
        volT2;
        volDWI;
    end
    methods
        function obj = Volume(T2, DWI)
            if nargin == 2
                if isnumeric(T2) && isnumeric(DWI)
                    if ismatrix(T2) && ismatrix(DWI)
                        obj.layers{end+1}=Layer(T2,DWI);
                    elseif (ndims(T2) == 3 && size(T2,3) == 3) && (ndims(DWI) == 3 && size(DWI,3) == 3)
                         obj.layers{end+1}=Layer(T2,DWI);
                    elseif (ndims(T2) == 3 && size(T2,3) > 3) && (ndims(DWI) == 3 && size(DWI,3) > 3) && (size(T2,3)==size(DWI,3))
                        for i = 1 : size(T2,3)
                            obj.layers{end+1}=Layer(T2(:,:,i), DWI(:,:,i));
                        end  
                        obj.volT2=T2;
                        obj.volDWI=DWI;
                    elseif (ndims(T2) == 4 && size(T2,3) == 3) && (ndims(DWI) == 4 && size(DWI,3) == 3) && (size(T2,4)==size(DWI,4))
                        for i = 1 : size(T2,4)
                            obj.layers{end+1}=Layer(T2(:,:,:,i), DWI(:,:,:,i));
                        end 
                    else
                        error('Verify input!')
                    end
                else
                    error('Input must be two images')
                end
                
            else
                error('Two images must be provided')
            end
            
            obj.slices = length(obj.layers);
 
        end
        
        function nr = getSlices(obj)
            nr = obj.slices;
        end
        
        function nr = getLayerNr(obj)
            nr = obj.layer;
        end
        
        function layer = getLayer(obj)
            layer = obj.layers{obj.layer};
        end
        
        function obj = setLayer(obj, layer)
            obj.layers{obj.layer} = layer;
        end
        
        function obj = nextLayer(obj)
            if obj.layer<obj.slices
            obj.layer = obj.layer+1;
            end
        end
        
        function obj = previousLayer(obj)
            if obj.layer>1
            obj.layer = obj.layer-1;
            end
        end
        
        function obj = updateTransforms(obj)
           for i=1:obj.slices
                l=obj.layers{i};
                l=l.updateTransforms();
                obj.layers{i}=l;
           end
        end
        
    end
end

