function [mH] = DialogEvaluation(layer)
        
        msg = {['             ', 'NMI:   ', '  ',  '    NCC:    ', '    ', 'TRE:    '];
               ['DWI      ', sprintf('%0.3f',layer.NMIDWI),        '        ', sprintf('%0.3f',layer.NCCDWI), '        ', '  -    '];...
               ['Rigid    ', sprintf('%0.3f',layer.NMIDWIrigid),   '        ', sprintf('%0.3f',layer.NCCDWIrigid), '        ', sprintf('%0.3f',layer.TRErigid)];...
               ['Affine   ', sprintf('%0.3f',layer.NMIDWIaffine),  '        ', sprintf('%0.3f',layer.NCCDWIaffine), '        ', sprintf('%0.3f',layer.TREaffine)];...
               ['TPS      ', sprintf('%0.3f',layer.NMIDWItps),     '        ', sprintf('%0.3f',layer.NCCDWItps), '        ', sprintf('%0.3f',layer.TREtps)]};
           
       mH = msgbox(msg);

end