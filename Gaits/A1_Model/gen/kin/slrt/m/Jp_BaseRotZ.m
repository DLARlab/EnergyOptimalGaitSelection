function [output1] = Jp_BaseRotZ(var1)
    if coder.target('MATLAB')
        [output1] = Jp_BaseRotZ_mex(var1);
    else
        coder.cinclude('Jp_BaseRotZ_src.h');
        
        output1 = zeros(3, 18);

        
        coder.ceval('Jp_BaseRotZ_src' ...
            ,coder.wref(output1) ...
            ,coder.rref(var1) );
    end
end
