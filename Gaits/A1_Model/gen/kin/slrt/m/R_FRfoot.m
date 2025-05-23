function [output1] = R_FRfoot(var1)
    if coder.target('MATLAB')
        [output1] = R_FRfoot_mex(var1);
    else
        coder.cinclude('R_FRfoot_src.h');
        
        output1 = zeros(3, 3);

        
        coder.ceval('R_FRfoot_src' ...
            ,coder.wref(output1) ...
            ,coder.rref(var1) );
    end
end
