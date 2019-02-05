function [imo,mask, e] = tps_transf( I, outDim, pointsFixed, pointsMoved)
% Thin-plate spline 2D image warping.
% [imo,mask, e] = tps_transf( im, ps, pd)
%   input:
%       I          : image 2d matrix
%       outDim     : output image dimension
%       pointsFixed: 2d destin landmark [n*2]
%       pointsMoved: 2d source landmark [n*2]
%       method:
%       Thin plate function ko = (|pi-pj|^2) * log(|pi-pj|^2)
%   output:
%       imo  : output image
%       mask : mask for output matrix, 0/1 means out/in the border
%       e    : Target registration error value


% in this part, the images are scaled to the same size
if size(I) ~= outDim
    s = outDim./size(I);
    if s(1)==s(2)
        I=imresize(I,s(1));
        pointsMoved=pointsMoved.*s(1);
    else
        error('Images must have the same ratio')
    end
end


% initialize default parameters
[imh,imw,imc] = size(I);
imo = zeros(outDim);

%% Training w with L
nump = size(pointsFixed,1);
num_center = size(pointsMoved,1);
K=zeros(nump,num_center);
for i=1:num_center
    %Inverse warping from destination!
    dx = ones(nump,1)*pointsMoved(i,:)-pointsFixed; 
    K(:,i) = sum(dx.^2,2);
end

K = ThinPlate(K);
    
% P = [1,xp,yp] where (xp,yp) are n landmark points (nx2)
P = [ones(num_center,1),pointsFixed];
% L = [ K  P;
%       P' 0 ]
L = [K,P;P',zeros(3,3)];
% Y = [x,y;
%      0,0]; (n+3)x2
Y = [pointsMoved;zeros(3,2)];
%w = inv(L)*Y;
w = L\Y;
%% Using w
[x,y] = meshgrid(1:imw,1:imh);
pt = [x(:), y(:)];
nump = size(pt,1);
Kp = zeros(nump,num_center);
for i=1:num_center
    dx = ones(nump,1)*pointsMoved(i,:)-pt;
    Kp(:,i) = sum(dx.^2,2);
end

Kp = ThinPlate(Kp);    

L = [Kp,ones(nump,1),pt];
ptall = L*w;
%reshape to 2d image
xd = reshape( ptall(:,1),imh,imw ); % corresponding X coordinates in the "Moved" image
yd = reshape( ptall(:,2),imh,imw ); % corresponding Y coordinates in the "Moved" image
% we get a matrix with dimension outDim and in each position we have the
% correspondent X and Y coordinates on the "Moved" image
for i = 1:imc % real magic happens here
    imt= interp2( single(I(:,:,i)),xd,yd,'linear'); % 
    imo(:,:,i) = uint8(imt);
end
mask = ~isnan(imt);


imo=uint8(imo);

% in this part we find the coordinates on the final image correspondent
% to the coordinates of the "Moved" points, so we can calculate the TRE
pointsWarped=zeros(num_center,2);
for i=1:num_center
    xdif=abs(xd-pointsMoved(i,1));
    ydif=abs(yd-pointsMoved(i,2));
    xydif=(xdif+ydif)/2;
    [xydif_min,xydif_M]=min(xydif);
    [~,N]=min(xydif_min);
    pointsWarped(i,:)=[N, xydif_M(N)];
end

e = TRE(pointsFixed, pointsMoved, pointsWarped);

end

function ko = ThinPlate(ri)
% k=(r^2) * log(r^2)
    r1i = ri;
    r1i((ri==0))=realmin; % Avoid log(0)=inf
    ko = (ri).*log(r1i);
end
