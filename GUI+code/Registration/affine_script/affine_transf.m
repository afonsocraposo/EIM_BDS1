function [ J, affine_matrix, e] = affine_transf(I, outDim, pointsFixed, pointsMoved )
% Affine transformation image warping.
% [ J, affine_matrix, e] = affine_transf(I, outDim, pointsFixed, pointsMoved )
%   input:
%       I           : image 2D dimension
%       outDim      : output image dimension
%       pointsFixed : 2d destin points [n*2]
%       pointsMoved : 2d source points [n*2]
%   method:
%       pointsMoved = Matrix * pointsFixed
%       Applies the linear least square method to obtain the affine
%       transformation matrix from the points given
%       LS method :  A x = b
%   output:
%       J             : output image
%       affine_matrix : affine transformation matrix 
%       e             : Target registration error value


if(size(pointsFixed) == size(pointsMoved))

    if(size(pointsFixed,1))>=3
        
        % scales the two images
        if size(I) ~= outDim
            s = outDim./size(I);
            if s(1)==s(2)
                I=imresize(I,s(1));
                pointsMoved=pointsMoved.*s(1);
            else
                error('Images must have the same ratio')
            end
        end
        
        % creates matrix A from pointsFixed
        A=createA(pointsFixed);

        % creates matrix B from pointsMoved
        b=createb(pointsMoved);

        % applies the least square method to estimate the value of x
        leastSquare = pinv(A'*A)*A'*b;

        % creates the affine transformation matrix from the vector x
        % obtained on the previous step
        affine_matrix=createx(leastSquare); 
        
        % applies the transformation
        J=geo_transf(I, affine_matrix, outDim);
        
        % inverts the affine transformation matrix in order to find the
        % destination of the movedPoints in the final image
        matrixInv=pinv(affine_matrix);
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


function [ A ] = createA( points )
% Receives a list of points [x, y] and arranges them to calculate the
% linear least squares
%
%                      A
% [x1, y1]    [x1, y1, 1, 0, 0, 0]
% [x2, y2] -> [0, 0, 0, x1, y1, 1]
% [x3, y3]    [x2, y2, 1, 0, 0, 0]
%             [0, 0, 0, x2, y2, 1]
%             [x3, y3, 1, 0, 0, 0]
%             [0, 0, 0, x3, y3, 1]

A=zeros(size(points,1),6);

for i=1:size(points,1)
        A(1+(i-1)*2,:)=[points(i,1), points(i,2), 1, 0, 0, 0];
        A(2+(i-1)*2,:)=[0, 0, 0, points(i,1), points(i,2), 1];
end

end


function [ b ] = createb( points )
% creates a column vector with the coordinates of points [n*2 x 1]

b = reshape(points',numel(points),1);

end


function [ x ] = createx( points )
% Obtains the matrix points in a line vector and compiles the affine
% geometric transformation matrix:
%
% [x11]       [x11 x12 x13]
% [x12]   ->  [x21 x22 x23]
% [x13]       [ 0   0   1 ]   
% [x21]
% [x22]
% [x23]

x = [reshape(points,3,2) [0; 0;1]]';

end