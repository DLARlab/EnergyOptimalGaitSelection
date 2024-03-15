function [gait] = parse(nlp, sol)
    %% parse the optimization results to more readible structure data
    
    [tspan, states, inputs, params] = exportSolution(nlp, sol);

   
    
    tspan{3} = tspan{1}(end) + (tspan{3} - tspan{3}(1));

    
    gait = struct(...
        'tspan', tspan,...
        'states', states,...
        'inputs', inputs,...
        'params', params);


end

