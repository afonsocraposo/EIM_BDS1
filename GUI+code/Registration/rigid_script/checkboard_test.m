close all
clear

angle = 0.3;
x = 0;
y = 0;
x_exemplo = [cos(angle), sin(angle), x;
             -sin(angle), cos(angle), y;
              0, 0 1];

c=uint8(round(checkerboard(40)*255));
I=imresize(c,2);
J=geo_transf(I,x_exemplo,size(I));

%J=I;
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
pointsA=ginput(2);
hold on
scatter(pointsA(:,1),pointsA(:,2),'r','Linewidth',2)
hold off

subplot(2,2,2)
pointsb=ginput(2);
hold on
scatter(pointsb(:,1),pointsb(:,2),'g','Linewidth',2)
hold off


[Jfinal, matrix, e]=rigid_transf(J, size(I), pointsA,pointsb);

% Jfinal=geo_transf(J,matrix,size(I));

pointsAB=pinv(matrix)*[pointsb ones(size(pointsb,1),1)]';
pointsAB=pointsAB(1:2,:)';

subplot(2,2,3)
imagesc(Jfinal);
hold on
scatter(pointsA(:,1),pointsA(:,2),'r','Linewidth',2)
scatter(pointsAB(:,1),pointsAB(:,2),'g','Linewidth',2)
hold off
pbaspect([1 1 1])
title('DWI w/ rigid transformation')

subplot(2,2,4)
imshowpair(I,Jfinal)
pbaspect([1 1 1])
title('T2 vs DWI w/ rigid transformation')

hold on
% get axis limits 
x0 = get(gca,'xlim') ;
y0 = get(gca,'ylim') ;
% draw dummy data to show legend 
scatter(0,0,200,'s','MarkerEdgeColor','g','MarkerFaceColor','g')
hold on
scatter(0,0,200,'s','MarkerEdgeColor','m','MarkerFaceColor','m')
% set the mits 
axis([x0 y0])
% add the legend 
legend('T2','DWI')
axis off %hide axis

[ncc, nmi] = evalIM(I,J,pointsA)
[ncc, nmi] = evalIM(I,Jfinal,pointsA)
