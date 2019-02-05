close all
files = dir('*.mat');
c=0;
s = RandStream('mlfg6331_64');
f=figure(1); colormap pink
for file = files'
    
    c=c+1;
    if c>25
        break
    end
    
    if c>17
        
        img = load(file.name);
        img=struct2cell(img);
        img=img{1};
        
        disp(file.name)
        
        num='';
        ok=0;
        for i = 1:length(file.name)
            
            if file.name(i)=='.'
                ok=0;
            end
            
            if ok
                num=strcat(num,file.name(i));
            end
            
            if file.name(i)=='_'
                ok=1;
            end
            
        end
        
        Idwi=load(strcat('DWI_',num,'.mat'));
        IDWI=Idwi.mat_img_DWI;
        It2=load(strcat('T2_',num,'.mat'));
        IT2=It2.mat_img_T2;
        
        num=sprintf('%04d',str2double(num));
        
        %slices = datasample(s,1:size(IDWI,3),6,'Replace',false);
        %for j=1:length(slices)
            %It2=IT2(:,:,j);
            %Idwi=IDWI(:,:,j);
            z=round(size(IDWI,3)/2);
            It2=IT2(:,:,z);
            Idwi=IDWI(:,:,z);
            
            figure(1)
            subplot(2,3,1)
            pbaspect([1 1 1])
            imagesc(It2)
            title(num2str(c))
            subplot(2,3,2)
            pbaspect([1 1 1])
            imagesc(Idwi)
            %title(num2str(j))
            title(num2str(z))
            
            pointsFixed=ginput(6);
            hold on
            scatter(pointsFixed(:,1),pointsFixed(:,2),'g')
            hold off
            pointsMoved=ginput(6);
            hold on
            scatter(pointsMoved(:,1),pointsMoved(:,2),'g')
            hold off
            
            Irigid = rigid_transf(Idwi, size(It2), pointsFixed, pointsMoved);
            Iaffine = affine_transf(Idwi, size(It2), pointsFixed, pointsMoved);
            Itps = tps_transf(Idwi, size(It2), pointsFixed, pointsMoved);
            
            subplot(2,3,4)
            pbaspect([1 1 1])
            imagesc(Irigid)
            subplot(2,3,5)
            pbaspect([1 1 1])
            imagesc(Iaffine)
            subplot(2,3,6)
            pbaspect([1 1 1])
            imagesc(Itps)
            
            pause()
            
            IM=struct;
            IM.T2=It2;
            IM.DWI=Idwi;
            IM.DWIrigid=Irigid;
            IM.DWIaffine=Iaffine;
            IM.DWItps=Itps;
            IM.pointsFixed=pointsFixed;
            IM.pointsMoved=pointsMoved;
            
            %filename=strcat('IM','_',num,'_slice_',sprintf('%02d',slices(j)),'.mat');
            filename=strcat('IM','_',num,'_slice_',sprintf('%02d',z),'.mat');
            save(filename,'IM');
            
            filename=strcat('./Images/IM','_',num,'_slice_',sprintf('%02d',z),'_');
            f1=figure(2); colormap pink
            imagesc(It2)
            pbaspect([1 1 1])
            hold on
            scatter(pointsFixed(:,1),pointsFixed(:,2),'g')
            hold off
            saveas(f1,strcat(filename,'T2_points'),'jpg')

            imagesc(Idwi)
            pbaspect([1 1 1])
            hold on
            scatter(pointsMoved(:,1),pointsMoved(:,2),'g')
            hold off
            saveas(f1,strcat(filename,'DWI_points'),'jpg')
            
            imwrite(It2,strcat(filename,'T2.jpg'));
            imwrite(Idwi,strcat(filename,'DWI.jpg'));
            imwrite(Irigid,strcat(filename,'DWI_Rigid.jpg'));
            imwrite(Iaffine,strcat(filename,'DWI_Affine.jpg'));
            imwrite(Itps,strcat(filename,'DWI_TPS.jpg'));
        %end
    end
end