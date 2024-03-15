function [output1] = Jp_FR_calf_joint(var1)
    if coder.target('MATLAB')
        [output1] = Jp_FR_calf_joint_mex(var1);
    else
        coder.cinclude('Jp_FR_calf_joint_src.h');
        
        output1 = zeros(3, 18);

        
        coder.ceval('Jp_FR_calf_joint_src' ...
            ,coder.wref(output1) ...
            ,coder.rref(var1) );
    end
end
