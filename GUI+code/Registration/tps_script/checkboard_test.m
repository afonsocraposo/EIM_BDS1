close all
clear

x_exemplo = [1.2, 0.2, 1;
              0.2, 0.8, 0;
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

pointsa=ginput(5);
hold on
scatter(pointsa(:,1),pointsa(:,2),'r')
hold off

pointsb=ginput(5);
hold on
scatter(pointsb(:,1),pointsb(:,2),'r')
hold off

[imgw, mask, e]=tps_transf(J,size(I),pointsa,pointsb);


% f=figure;
% imshow(I)
% hold on
% scatter(pointsa(:,1),pointsa(:,2),'g','Linewidth',2)
% hold off
% saveas(f,'I.jpg')
% 
% imshow(J)
% hold on
% scatter(pointsb(:,1),pointsb(:,2),'g','Linewidth',2)
% hold off
% saveas(f,'J.jpg')
% 
% imshow(imgw)
% saveas(f,'J_I.jpg')


subplot(2,2,3)
imagesc(imgw)

subplot(2,2,4)
imshowpair(I, imgw)

% pointsAB=pinv(x)*[pointsb ones(5,1)]';
% pointsAB=pointsAB(1:2,:)';
% 
% subplot(2,2,3)
% imagesc(Jfinal);
% hold on
% scatter(pointsA(:,1),pointsA(:,2),'r','Linewidth',2)
% scatter(pointsAB(:,1),pointsAB(:,2),'g','Linewidth',2)
% hold off
% pbaspect([1 1 1])
% title('DWI w/ affine transformation')
% 
% subplot(2,2,4)
% imshowpair(I,Jfinal)
% pbaspect([1 1 1])
% title('T2 vs DWI w/ affine transformation')
% 
% hold on
% % get axis limits 
% x0 = get(gca,'xlim') ;
% y0 = get(gca,'ylim') ;
% % draw dummy data to show legend 
% scatter(0,0,200,'s','MarkerEdgeColor','g','MarkerFaceColor','g')
% hold on
% scatter(0,0,200,'s','MarkerEdgeColor','m','MarkerFaceColor','m')
% % set the mits 
% axis([x0 y0])
% % add the legend 
% legend('T2','DWI')
% axis off %hide axis
