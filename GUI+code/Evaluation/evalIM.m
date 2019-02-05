function [ ncc, nmi ] = evalIM( T2, DWI, pointsFixed)
% Calculates the NCC and NMI between images T2 and DWI, with the VOI
% calculated from pointsFixed
% [ ncc, nmi ] = evalIM( T2, DWI, pointsFixed)
%   input:
%       T2          : T2 image
%       DWI         : DWI image
%       pointsFixed : Fixed points coordinates used to calculate the VOI
%   method:
%       Applies the NCC and NMI methods to images T2 and DWI in the VOI
%       calculated from points Fixed
%   output:
%       ncc : NCC value
%       nmi : NMI value


% resize images if needed
if size(DWI) ~= size(T2)
    s = size(T2)./size(DWI);
    if s(1)==s(2)
        DWI=imresize(DWI,s(1));
    else
        error('Images must have the same ratio')
    end
end

% obtain the images with VOI
IM1 = VOI(T2, pointsFixed);
IM2 = VOI(DWI, pointsFixed);

% Calculate NCC and NMI
% In order to make NCC's max value equal to 1, we divide NCC(IM1, IM2) by
% NCC(IM1,IM1)
ncc=NCC(IM1, IM2)/NCC(IM1,IM1);
nmi=NMI(IM1, IM2);

end

