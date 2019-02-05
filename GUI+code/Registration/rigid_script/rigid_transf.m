function [ J, rigid_matrix, e] = rigid_transf(I, outDim, pointsFixed, pointsMoved )
% Rigid transformation image warping.
% [ J, rigid_matrix, e] = rigid_transf(I, outDim, pointsFixed, pointsMoved )
%   input:
%       I           : image 2D dimension
%       outDim      : output image dimension
%       pointsFixed : 2d destin points [n*2]
%       pointsMoved : 2d source points [n*2]
%   method:
%       pointsMoved = rigid_matrix * pointsFixed
%       Uses Singular Value Decomposition (SVD) in order to obtain the
%       rigid transformation matrix from the points given
%   output:
%       J            : output image
%       rigid_matrix : rigid transformation matrix 
%       e            : Target registration error value


if(size(pointsFixed) == size(pointsMoved))

    if(size(pointsFixed,1))>=2
        
        % scales the images to the same size
        if size(I) ~= outDim
            s = outDim./size(I);
            if s(1)==s(2)
                I=imresize(I,s(1));
                pointsMoved=pointsMoved.*s(1);
            else
                error('Images must have the same ratio')
            end
        end
        
        nPoints = size(pointsFixed, 1);
        dimension = size(pointsFixed, 2);

        % calculates the centroid of each set of points
        centroid1 = sum(pointsFixed, 1)./nPoints;
        centroid2 = sum(pointsMoved, 1)./nPoints;

        
        centered1 = pointsFixed - repmat(centroid1, nPoints, 1);
        centered2 = pointsMoved - repmat(centroid2, nPoints, 1);

        % Computes the covariance matrix
        S = centered1' * centered2;

        % Applies the SVD method. Note: E is not needed (middle value)
        [U, ~, V] = svd(S);

        M = eye(dimension, dimension);
        M(dimension, dimension) = det(V*U');

        % obtains rotation matrix
        R = V * M * U';
        % obtains translation vector
        t = centroid2' - R*centroid1';

        % constructs the rigid transformation matrix
        rigid_matrix = eye(3,3);
        rigid_matrix(1:2, 1:2) = R;
        rigid_matrix(1:2, 3) = t;
        
        % applies the matrix to the image
        J=geo_transf(I, rigid_matrix, outDim);
        
        % inverts the matrix and calculates the destination of the moved
        % points after the transformation
        matrixInv=pinv(rigid_matrix);
        pointsWarped = matrixInv * [pointsMoved'; ones(1,size(pointsMoved,1))];
        pointsWarped = pointsWarped(1:2,:)';
        
        % calculates the TRE
        e = TRE(pointsFixed, pointsMoved, pointsWarped);
        
    else
        error('At least 2 points must be provided.')
    end
else
    error('Points dimensions mismatch.')
end

end

