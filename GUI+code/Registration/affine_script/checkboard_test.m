close all
clear

x_exemplo = [1.2, 0.3, 1;
              0.2, 1, 0;
              0, 0 1];

% I = load('T2_2.mat');
% I=I.mat_img_T2;
% I=I(:,:,12);
% 
% J = load('DWI_2.mat');
% J=J.mat_img_DWI;
% J=J(:,:,12);
% 
% points=load('points2.mat');
% pointsA=points.pointsA;
% pointsb=points.pointsb;

I=uint8(round(checkerboard(40)*255));
J=geo_transf(I,x_exemplo,size(I));

%J = imresize(J,size(I));

figure, colormap gray
subplot(2,2,1)
imagesc(I);
pbaspect([1 1 1])
title('T2')

subplot(2,2,2)
imagesc(J);
pbaspect([1 1 1])
title('DWI')

subplot(2,2,1)
pointsA=ginput(3);
hold on
scatter(pointsA(:,1),pointsA(:,2),'r','Linewidth',2)
hold off

subplot(2,2,2)
pointsb=ginput(3);
hold on
scatter(pointsb(:,1),pointsb(:,2),'g','Linewidth',2)
hold off


[x, matrix, e]=affine_transf(J,size(I),pointsA,pointsb);

[ncc, nmi] = evalIM(I,J,pointsA)
[ncc, nmi] = evalIM(I,x,pointsA)



% f=figure;
% imshow(I)
% hold on
% scatter(pointsA(:,1),pointsA(:,2),'g','Linewidth',2)
% hold off
% saveas(f,'I.jpg')
% 
% imshow(J)
% hold on
% scatter(pointsb(:,1),pointsb(:,2),'g','Linewidth',2)
% hold off
% saveas(f,'J.jpg')
% 
% imshow(x)
% saveas(f,'J_I.jpg')
