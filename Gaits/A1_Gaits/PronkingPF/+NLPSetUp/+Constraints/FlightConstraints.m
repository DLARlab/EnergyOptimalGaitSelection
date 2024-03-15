function FlightConstraints(nlp, bounds, varargin)
%% Add Virtual Constraints
    nlp.Plant.VirtualConstraints.time.imposeNLPConstraint(nlp, [bounds.time.kp, bounds.time.kd], [1,1]);
    
%% Tau Boundary [0,1]
    addNodeConstraint(nlp,AllConstraints.Tau0(nlp),[{'T'},nlp.Plant.VirtualConstraints.time.PhaseParamName],'first', 0, 0, 'Nonlinear');
    addNodeConstraint(nlp,AllConstraints.TauF(nlp),[{'T'},nlp.Plant.VirtualConstraints.time.PhaseParamName], 'last', 0, 0, 'Nonlinear');

%% Bezier Symmetry to enforce the same motion on both sides 
    [N,M] = size(nlp.Plant.Params.atime);
    selected = SymVariable('s',[N/2,1]);
    a  = SymVariable('a',[N,M]);
    constraint_matrix = repmat(selected,1,M) .* ...
        ([-a(1,:);-a(7,:);a(2:3,:);a(8:9,:)] - [a(4,:);a(10,:);a(5:6,:);a(11:12,:)]);
    constraint = constraint_matrix(:);
    BezierSymmetry = SymFunction('BezierSymmetry', constraint, SymVariable(a(:)), selected);

    selected = ones(N/2,1);
    BezierSymmetry_cstr = NlpFunction('Name','BezierSymmetry',...
        'Dimension',N/2*M,...
        'lb', -0,...
        'ub', +0,...
        'Type','Linear',...
        'SymFun',BezierSymmetry,...
        'DepVariables',nlp.OptVarTable.atime(end),...
        'AuxData',selected);

    addConstraint(nlp, 'BezierSymmetry', 'last', BezierSymmetry_cstr);

%% Final node foot velocity
    addNodeConstraint(nlp,AllConstraints.SwingFootContactVelocity(nlp,'FR'), ...
        {'x','dx'}, 'last', bounds.swing_foot_contact_vel_FR.lb, bounds.swing_foot_contact_vel_FR.ub, 'Nonlinear'); 
    
    addNodeConstraint(nlp,AllConstraints.SwingFootContactVelocity(nlp,'RR'), ...
        {'x','dx'}, 'last', bounds.swing_foot_contact_vel_RR.lb, bounds.swing_foot_contact_vel_RR.ub, 'Nonlinear'); 
    
    addNodeConstraint(nlp,AllConstraints.SwingFootContactVelocity(nlp,'FL'), ...
        {'x','dx'}, 'last', bounds.swing_foot_contact_vel_FL.lb, bounds.swing_foot_contact_vel_FL.ub, 'Nonlinear'); 
    
    addNodeConstraint(nlp,AllConstraints.SwingFootContactVelocity(nlp,'RL'), ...
        {'x','dx'}, 'last', bounds.swing_foot_contact_vel_RL.lb, bounds.swing_foot_contact_vel_RL.ub, 'Nonlinear'); 
    
%% Unilateral Constraints    
            FRFK = nlp.Plant.ContactPoints.FRfoot.computeForwardKinematics;  %  Front-Right Foot Forward Kinematics 
             Fz1 = FRFK(3,4);
          Fz1Fun = SymFunction('FRFootHeight', Fz1, {nlp.Plant.States.x}); 
          addNodeConstraint(nlp,Fz1Fun,{'x'},3:9,0.04,inf,'Nonlinear');

            FLFK = nlp.Plant.ContactPoints.FLfoot.computeForwardKinematics;  %  Front-Left Foot Forward Kinematics 
             Fz2 = FLFK(3,4); 
          Fz2Fun = SymFunction('FLFootHeight', Fz2, {nlp.Plant.States.x}); 
          addNodeConstraint(nlp,Fz2Fun,{'x'},3:9,0.04,inf,'Nonlinear');
  
            RRFK = nlp.Plant.ContactPoints.RRfoot.computeForwardKinematics;  %  Rear-Right Foot Forward Kinematics 
             Fz3 = RRFK(3,4);
          Fz3Fun = SymFunction('RRFootHeight', Fz3, {nlp.Plant.States.x}); 
          addNodeConstraint(nlp,Fz3Fun,{'x'},3:9,0.04,inf,'Nonlinear');

            RLFK = nlp.Plant.ContactPoints.RLfoot.computeForwardKinematics;  %  Rear-Left Foot Forward Kinematics 
             Fz4 = RLFK(3,4); 
          Fz4Fun = SymFunction('RLFootHeight', Fz4, {nlp.Plant.States.x}); 
          addNodeConstraint(nlp,Fz4Fun,{'x'},3:9,0.04,inf,'Nonlinear');
end
