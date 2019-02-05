function [nmi] = NMI(im1,im2)
% Normalized Mutual Information function for two images
% 	[nmi] = NMI(im1,im2)
%   input:
%       im1 : image 1
%       im2 : image 2
%   method:
%       Calculates the Normalized Mutual Information between two images
%   output:
%       nmi : NMI value


indrow = double(im1(:)) + 1;
indcol = double(im2(:)) + 1; %// Should be the same size as indrow
jointHistogram = accumarray([indrow indcol], 1);
jointProb = jointHistogram / numel(indrow);

indNoZero = jointHistogram ~= 0;
jointProb1DNoZero = jointProb(indNoZero);

jointEntropy = -sum(jointProb1DNoZero.*log2(jointProb1DNoZero));

histogramImage1 = sum(jointHistogram, 1);
histogramImage2 = sum(jointHistogram, 2);

% Find non-zero elements for first image's histogram
indNoZero = histogramImage1 ~= 0;

% Extract them out and get the probabilities
prob1NoZero = histogramImage1(indNoZero);
prob1NoZero = prob1NoZero / (realmin+sum(prob1NoZero)); % +realmin to avoid NaN

% Compute the entropy
entropy1 = -sum(prob1NoZero.*log2(prob1NoZero));

% Repeat for the second image
indNoZero = histogramImage2 ~= 0;
prob2NoZero = histogramImage2(indNoZero);
prob2NoZero = prob2NoZero / (realmin+sum(prob2NoZero)); % +realmin to avoid NaN
entropy2 = -sum(prob2NoZero.*log2(prob2NoZero));

% Now compute mutual information
mutualInformation = entropy1 + entropy2 - jointEntropy;

% Normalization
nmi = mutualInformation / sqrt(realmin+entropy1*entropy2); % +realmin to avoid NaN