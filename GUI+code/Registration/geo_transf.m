function [ I ] = geo_transf( J, A , outDim)
% Transformation of coordinates using the matrix A.
% [ I ] = geo_transf( J, A , sizeI)
%   input:
%       J      : image 2D dimension, input image
%       A      : transformation matrix
%       outDim : output image dimension
%   method:
%       [xJ yJ 1] = A * [xI; yI; 1]
%   output:
%       I      : output image



% size of I
M=outDim(1);
N=outDim(2);

% create an empty (black) image I
I=uint8(zeros(M,N));

[MJ,NJ]=size(J);

% go through every point of I
for x=1:N
    for y=1:M
        % calculate what point of J corresponds to the point (x,y) of I
        % [cord(1) cord(2) 1] = A * [x; y; 1]
        cord=round(A*[x; y; 1]);
        
        % if the obtained coordinates are inside J, copy the value of
        % J(cord(2), cord(1) to I(y, x)
        if cord(1)<=NJ && cord(2)<=MJ && cord(1)>0 && cord(2)>0 
            I(y,x)=J(cord(2),cord(1));
        end
        % ATTENTION to the fact that in the matrix we work with (x,y), but
        % in reality, to access the image matrix we have to switch the
        % order to row-column = (y,x)
    end
end

end

