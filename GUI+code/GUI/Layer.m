classdef Layer
    properties
        DWI;
        DWIdefault;
        T2;
        T2default;
        pointsT2;
        pointsDWI;
        pointsT2Display;
        pointsDWIDisplay;
        transfNormal;
        transfNormalInv;
        transfRigid;
        transfAffine;
        DWIRigid;
        DWIRigiddefault;
        DWIAffine;
        DWIAffinedefault;
        DWIThin;
        DWIThindefault;
        sizeDWI;
        sizeT2;
        pointsChanged;
        TRErigid;
        TREaffine;
        TREtps;
        NMIDWI;
        NMIDWIrigid;
        NMIDWIaffine;
        NMIDWItps;
        NCCDWI;
        NCCDWIrigid;
        NCCDWIaffine;
        NCCDWItps;
    end
    methods
        function obj = Layer(T2, DWI)
            if nargin == 2
                if isnumeric(T2)
                    if ismatrix(T2)
                        obj.T2 = T2;
                    elseif ndims(T2) == 3 && size(T2,3) == 3
                        obj.T2 = rgb2gray(T2);
                    else
                        error('Input must be an image')
                    end
                else
                    error('Input must be an image')
                end
                
                if isnumeric(DWI)
                    if ismatrix(DWI)
                        obj.DWI = DWI;
                    elseif ndims(DWI) == 3 && size(DWI,3) == 3
                        obj.DWI = rgb2gray(DWI);
                    else
                        error('Input must be an image')
                    end
                else
                    error('Input must be an image')
                end
                
                obj.DWIdefault=obj.DWI;
                obj.T2default=obj.T2;
                obj.sizeT2 = size(obj.T2);
                obj.sizeDWI = size(obj.DWI);
                obj.transfNormal = [obj.sizeDWI(2)/obj.sizeT2(2) 0 0; 0 obj.sizeDWI(1)/obj.sizeT2(1) 0; 0 0 1];
                obj.transfNormalInv = pinv(obj.transfNormal);
                obj.pointsT2 = zeros(0,2);
                obj.pointsDWI = zeros(0,2);
                obj.pointsT2Display = cell(0, 2);
                obj.pointsDWIDisplay = cell(0, 2);
                obj.pointsChanged = false;
            else
                error('Two images must be provided')
            end
            
        end
        
        function img = getT2(obj)
            img = obj.T2;
        end
        
        function img = getDWI(obj)
            img = obj.DWI;
        end
        
        function obj = setTransfAffine(obj, matrix)
            obj.transfAffine = matrix;
        end
        
        function matrix = getTransfNormal(obj)
            matrix = obj.transfNormal;
        end
        
        function matrix = getTransfNormalInv(obj)
            matrix = obj.transfNormalInv;
        end
        
        function matrix = getTransfAffine(obj)
            matrix = obj.transfAffine;
        end
        
        function obj = setDWIRigid(obj, img)
            obj.DWIRigid = img;
        end
        
        function obj = setDWIAffine(obj, img)
            obj.DWIAffine = img;
        end
        
        function obj = setDWIThin(obj, img)
            obj.DWIThin = img;
        end
        
        function points = getPointsT2(obj)
            points = obj.pointsT2;
        end
        
        function obj = addPointsT2(obj, points)
            obj.pointsT2(end+1,:) = points;
        end
        
        function obj = removePointsT2(obj)
            if size(obj.pointsT2,1)==1
                obj.pointsT2 = zeros(0, 2);
            elseif size(obj.pointsT2,1)>1
                obj.pointsT2 = obj.pointsT2(1:end-1,:);
            end
        end
        
        function points = getPointsDWI(obj)
            points = obj.pointsDWI;
        end
        
        function obj = addPointsDWI(obj, points)
            obj.pointsDWI(end+1,:) = points;
        end
        
        function obj = removePointsDWI(obj)
            if size(obj.pointsDWI,1)==1
                obj.pointsDWI = zeros(0, 2);
            elseif size(obj.pointsDWI,1)>1
                obj.pointsDWI = obj.pointsDWI(1:end-1,:);
            end
        end
        
        
        function obj = addPointsT2Display(obj, points)
            obj.pointsT2Display(end+1,:) = points;
        end
        
        function obj = removePointsT2Display(obj)
            cellfun(@(x) delete(x),obj.pointsT2Display(end,:))
            if size(obj.pointsT2Display,1)==1
                obj.pointsT2Display = cell(0, 2);
            elseif size(obj.pointsT2Display,1)>1
                obj.pointsT2Display = obj.pointsT2Display(1:end-1,:);
            end
        end
        
        function obj = addPointsDWIDisplay(obj, points)
            obj.pointsDWIDisplay(end+1,:) = points;
        end
        
        function obj = removePointsDWIDisplay(obj)
            cellfun(@(x) delete(x),obj.pointsDWIDisplay(end,:))
            if size(obj.pointsDWIDisplay,1)==1
                obj.pointsDWIDisplay = cell(0, 2);
            elseif size(obj.pointsDWIDisplay,1)>1
                obj.pointsDWIDisplay = obj.pointsDWIDisplay(1:end-1,:);
            end
        end
        
        function obj = clearPointsT2Display(obj)
            cellfun(@(x) delete(x),obj.pointsT2Display(:))
            obj.pointsT2Display = cell(0, 2);
        end
        
        function obj = clearPointsDWIDisplay(obj)
            cellfun(@(x) delete(x),obj.pointsDWIDisplay(:))
            obj.pointsDWIDisplay = cell(0, 2);
        end
        
        function value = getT2value(obj, points)
            if points(1)>0 && points(2)>0 && points(1)<=obj.sizeT2(1) && points(2)<=obj.sizeT2(2)
                value = obj.T2(points(1),points(2));
            else
                value=nan;
            end
        end
        
        function value = getDWIvalue(obj, points)
            if points(1)>0 && points(2)>0 && points(1)<=obj.sizeDWI(1) && points(2)<=obj.sizeDWI(2)
                value = obj.DWI(points(1),points(2));
            else
                value=nan;
            end
        end
        
        function s = getSizeT2(obj)
            s = obj.sizeT2;
        end
        
        function s = getSizeDWI(obj)
            s = obj.sizeDWI;
        end
        
        function obj = resetImages(obj)
            obj.T2=obj.T2default;
            obj.DWI=obj.DWIdefault;
            obj.DWIRigid=obj.DWIRigiddefault;
            obj.DWIAffine=obj.DWIAffinedefault;
            obj.DWIThin=obj.DWIThindefault;
        end
        
        function obj = updateTransforms(obj)
            if obj.pointsChanged
                
                if size(obj.pointsT2,1)>=5
                    [obj.NCCDWI, obj.NMIDWI] = evalIM(obj.T2, obj.DWI, obj.pointsT2);

                    [obj.DWIRigid, obj.transfRigid, obj.TRErigid] = rigid_transf(obj.DWI, obj.sizeT2, obj.pointsT2, obj.pointsDWI);
                    [obj.NCCDWIrigid, obj.NMIDWIrigid] = evalIM( obj.T2, obj.DWIRigid, obj.pointsT2);
                
                    [obj.DWIAffine, obj.transfAffine, obj.TREaffine] = affine_transf(obj.DWI, obj.sizeT2, obj.pointsT2, obj.pointsDWI);
                    [obj.NCCDWIaffine, obj.NMIDWIaffine] = evalIM( obj.T2, obj.DWIAffine, obj.pointsT2);
                
                    [obj.DWIThin, ~, obj.TREtps] = tps_transf(obj.DWI, obj.sizeT2, obj.pointsT2, obj.pointsDWI);
                    [obj.NCCDWItps, obj.NMIDWItps] = evalIM( obj.T2, obj.DWIThin, obj.pointsT2);
                    
                    obj.DWIRigiddefault=obj.DWIRigid;
                    obj.DWIAffinedefault=obj.DWIAffine;
                    obj.DWIThindefault=obj.DWIThin;
                
                end
                
                obj.pointsChanged = false;
            end
        end
        
    end
end

