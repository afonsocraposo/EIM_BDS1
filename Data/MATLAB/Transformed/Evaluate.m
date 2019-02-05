files = dir('*.mat');
c=0;
C = cell(26,19);

rigid_dNCC_mean=0;
rigid_dNMI_mean=0;
affine_dNCC_mean=0;
affine_dNMI_mean=0;
tps_dNCC_mean=0;
tps_dNMI_mean=0;
erigid_mean=0;
eaffine_mean=0;
etps_mean=0;

for file = files'
    
    c=c+1;
    disp(c)
    
    IM = load(file.name);
    
    num = file.name(4:7);
    
    IM=IM.IM;
    T2=IM.T2;
    DWI=IM.DWI;
    DWIrigid=IM.DWIrigid;
    DWIaffine=IM.DWIaffine;
    DWItps=IM.DWItps;
    pointsFixed=IM.pointsFixed;
    pointsMoved=IM.pointsMoved;
    erigid=IM.erigid;
    eaffine=IM.eaffine;
    etps=IM.etps;
    
    
    % save(file.name,'IM');

    [NCC_DWI, NMI_DWI] = evalIM(T2,DWI,pointsFixed);
    [NCC_DWIrigid, NMI_DWIrigid] = evalIM(T2,DWIrigid,pointsFixed);
    [NCC_DWIaffine, NMI_DWIaffine] = evalIM(T2,DWIaffine,pointsFixed);
    [NCC_DWItps, NMI_DWItps] = evalIM(T2,DWItps,pointsFixed);
    
    rigid_dNCC=(NCC_DWIrigid-NCC_DWI)*100/NCC_DWI;
    affine_dNCC=(NCC_DWIaffine-NCC_DWI)*100/NCC_DWI;
    tps_dNCC=(NCC_DWItps-NCC_DWI)*100/NCC_DWI;
    
    rigid_dNMI=(NMI_DWIrigid-NMI_DWI)*100/NMI_DWI;
    affine_dNMI=(NMI_DWIaffine-NMI_DWI)*100/NMI_DWI;
    tps_dNMI=(NMI_DWItps-NMI_DWI)*100/NMI_DWI;
    
    
%     rigid_dNCC_mean=rigid_dNCC_mean+rigid_dNCC/25;
%     rigid_dNMI_mean=rigid_dNMI_mean+rigid_dNMI/25;
%     affine_dNCC_mean=affine_dNCC_mean+affine_dNCC/25;
%     affine_dNMI_mean=affine_dNMI_mean+affine_dNMI/25;
%     tps_dNCC_mean=tps_dNCC_mean+tps_dNCC/25;
%     tps_dNMI_mean=tps_dNMI_mean+tps_dNMI/25;
%     
%     erigid_mean=erigid_mean+erigid/25;
%     eaffine_mean=eaffine_mean+eaffine/25;
%     etps_mean=etps_mean+etps/25;
    
    tableLine={strcat('IM',num), 12,...
        NCC_DWI, NMI_DWI,...
        NCC_DWIrigid, rigid_dNCC, NMI_DWIrigid, rigid_dNMI,...
        NCC_DWIaffine, affine_dNCC, NMI_DWIaffine, affine_dNMI,...
        NCC_DWItps, tps_dNCC, NMI_DWItps, tps_dNMI,...
        erigid, eaffine, etps};
    
    C(c,:)=tableLine;
end

mean_values=mean(cell2mat(C(:,3:end)));

tableLine={'Mean', 12,...
    mean_values(1), mean_values(2),...
    mean_values(3), mean_values(4), mean_values(5), mean_values(6),...
    mean_values(7), mean_values(8), mean_values(9), mean_values(10),...
    mean_values(11), mean_values(12), mean_values(13), mean_values(14),...
    mean_values(15), mean_values(16), mean_values(17)};
C(end,:)=tableLine;

T=cell2table(C,'VariableNames',...
    {'Image', 'Slice',...
    'NCC_DWI', 'NMI_DWI',...
    'NCC_DWIrigid', 'dNCC_rigid_percent', 'NMI_DWIrigid', 'dNMI_rigid_percent',...
    'NCC_DWIaffine', 'dNCC_affine_percent', 'NMI_DWIaffine', 'dNMI_affine_percent',...
    'NCC_DWItps', 'dNCC_tps_percent', 'NMI_DWItps', 'dNMI_tps_percent',...
    'TRE_rigid', 'TRE_affine', 'TRE_tps'});