function [ ncc, nccI ] = NCC( I1, I2 )
% Normalized Cross Correlation function for two images
% 	[ ncc, nccI ] = NCC( I1, I2 )
%   input:
%       I1 : image 1
%       I2 : image 2
%   method:
%       Calculates the Normalized Cross Correlation between two images
%   output:
%       ncc  : NCC value
%       nccI : Image obtained from the normalized cross correlation

I1=double(I1);
I2=double(I2);

% calculate mean values of both images
m1 = mean(mean(I1));
m2 = mean(mean(I2));

% calculate standard deviation of both images
s1 = std(std(I1));
s2 = std(std(I2));

% number of pixels
N = numel(I1);

% calculate the NCC
nccI=((I1-m1).*(I2-m2))./(realmin+N*s1*s2); % +realmin to avoid NaN

% sum the value of each pixel of the image obtained from the NCC
ncc=sum(sum(nccI));


end

