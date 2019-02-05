function [ e ] = TRE( pointsFixed, pointsMoved, pointsWarped )
% Calculates the Target Resistration Error between the sets of points
% [ e ] = TRE( pointsFixed, pointsMoved, pointsWarped )
%   input:
%       pointsFixed  : Fixed points coordinates
%       pointsMoved  : Moved points coordinates
%       pointsWarped : Warped points coordinates
%   method:
%       It calculates the variation of the Euclidean distance calculated
%       between (pointsFixed, pointsMoved) and (pointsFixed, pointsWarped)
%   output:
%       e      : TRE value (minimum possible value = 0)


% calculates the Euclidean distance between points
Dbefore = distancePoints(pointsFixed, pointsMoved);
Dafter = distancePoints(pointsFixed, pointsWarped);

% calculates the relative variation
e = 1 - mean((Dbefore-Dafter)./(Dbefore+realmin)); % +realmin to avoid NaN

end

function [ d ] = distancePoints( pointsFixed, pointsMoved )
% calculates the Euclidean distance between pointsFixed and pointsMoved

d=sqrt(sum((pointsMoved-pointsFixed).^2,2));

end


