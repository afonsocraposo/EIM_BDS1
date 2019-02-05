function [ J ] = VOI( I, points )
% Applying a mask to the image I in order to eliminate the background of
% the VOI
% [ J ] = VOI( I, points)
%   input:
%       I      : image 2D dimension, input image
%       points : transformation matrix
%   method:
%       It calculates the centroid of points. Then calculates the distance
%       in the x axis and y axis between each point and the centroid and
%       selects the maximum x distance and y distance. After that, all
%       points outside the rectangle of width (3*max_x+1) and height 
%       (2*max_y+1) become black
%   output:
%       J      : output image


    % calculates the centroid
    points_mean = round(mean(points));
    
    % calculates the distance between points
    distances = abs(points - points_mean);
    
    % calculates the maximum distance x and y and multiplies it by 1.5
    max_distances = round(1.5*max(distances));
        
    % if the rectangles width is smaller than 0.25 its height, it becomes
    % the size of 0.5 its height
    if max_distances(1)<=0.25*max_distances(2)
        max_distances(1)=round(0.5*max_distances(2));
    end
    
    % if the rectangles height is smaller than 0.25 its width, it becomes
    % the size of 0.5 its width
    if max_distances(2)<=0.25*max_distances(1)
        max_distances(2)=round(0.5*max_distances(1));
    end
    
    [M,N] = size(I);
    
    % calculates the corners coordinates of the rectangle
    n_min = points_mean(1) - max_distances(1);
    n_max = points_mean(1) + max_distances(1);
    m_min = points_mean(2) - max_distances(2);
    m_max = points_mean(2) + max_distances(2);
    
    % if the rectangle is out of the image range, it trims it
    if n_min<1
        n_min=1;
    end
    if n_max>N
        n_max=N;
    end
    if m_min<1
        m_min=1;
    end
    if m_max>M
        m_max=M;
    end
    
    % creates the output image
    J=uint8(zeros(size(I)));
    J(m_min:m_max,n_min:n_max)=I(m_min:m_max,n_min:n_max);

end

