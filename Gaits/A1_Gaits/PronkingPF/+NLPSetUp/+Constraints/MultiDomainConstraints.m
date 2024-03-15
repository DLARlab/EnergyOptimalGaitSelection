function [nlp] = MultiDomainConstraints(nlp,bounds)
%% Average Velocity
    T1   = SymVariable('t1',[2,1]);
    T2   = SymVariable('t2',[2,1]);
    X0   = SymVariable('x0',[nlp.Phase(1).Plant.numState,1]);
    XF   = SymVariable('xF',[nlp.Phase(1).Plant.numState,1]);
    
    avg_vel = (XF(1:2) - X0(1:2)) ./ (T1(2) - T1(1) + T2(2) - T2(1));
    avg_vel_fun = SymFunction('average_velocity', avg_vel, {T1,T2,X0,XF}); % use curly brackets to covert SymVar to cell arrays
     
    average_velocity_cstr_X = NlpFunction('Name',['average_velocity_','entire_stride'],...
                                          'Dimension',1,...
                                          'lb', bounds.average_velocity.lb,...
                                          'ub', bounds.average_velocity.ub ,...
                                          'Type','Linear',...
                                          'SymFun',avg_vel_fun,...
                                          'DepVariables',[nlp.Phase(1).OptVarTable.T(1),nlp.Phase(3).OptVarTable.T(1),...
                                                          nlp.Phase(1).OptVarTable.x(1),nlp.Phase(3).OptVarTable.x(end)]);
     
    addConstraint(nlp.Phase(3), ['average_velocity_','entire_stride'], 'last', average_velocity_cstr_X);
    
%% dCOT 
      mass = [4.713, 0.001, 0.696*4, 1.013*4, 0.166*4, 0.06*4]; % Masses of [Torso, IMU, Hip, Thigh, Calf, Foot]
      Mass = sum(mass); 
         g = 9.81;  
% Time ----------------------------------------------------------------------------------------------------------               
        tS = cell(1,nlp.Phase(1).NumNode); 
     for i = 1:nlp.Phase(1).NumNode
    tS{i} = SymVariable(['tFS',num2str(i)],[2,1]);     
     end
     
        tF = cell(1,nlp.Phase(3).NumNode);
     for i = 1:nlp.Phase(3).NumNode
    tF{i} = SymVariable(['tFF',num2str(i)],[2,1]);     
     end
     
% Configuration -------------------------------------------------------------------------------------------------        
        xS = cell(1,nlp.Phase(1).NumNode);
     for i = 1:nlp.Phase(1).NumNode
    xS{i} = SymVariable(['xFS',num2str(i)],[nlp.Phase(1).Plant.numState,1]);   
     end
     
        xF = cell(1,nlp.Phase(3).NumNode);
     for i = 1:nlp.Phase(3).NumNode
    xF{i} = SymVariable(['xFF',num2str(i)],[nlp.Phase(3).Plant.numState,1]);   
     end
      
% Velocities ----------------------------------------------------------------------------------------------------       
       dxS = cell(1,nlp.Phase(1).NumNode);
     for i = 1:nlp.Phase(1).NumNode
   dxS{i} = SymVariable(['dxFS',num2str(i)],[nlp.Phase(1).Plant.numState,1]);   
     end
     
       dxF = cell(1,nlp.Phase(3).NumNode);
     for i = 1:nlp.Phase(3).NumNode
   dxF{i} = SymVariable(['dxFF',num2str(i)],[nlp.Phase(3).Plant.numState,1]);   
     end
     
% Input ---------------------------------------------------------------------------------------------------------      
         uS = cell(1,nlp.Phase(1).NumNode);
      for i = 1:nlp.Phase(1).NumNode
     uS{i} = SymVariable(['uFS',num2str(i)],[length(nlp.Phase(1).Plant.Inputs.Control.u),1]);   
      end
      
         uF = cell(1,nlp.Phase(3).NumNode);
      for i = 1:nlp.Phase(3).NumNode
     uF{i} = SymVariable(['uFF',num2str(i)],[length(nlp.Phase(3).Plant.Inputs.Control.u),1]);   
      end
      
% Constarint Expression---------------------------------------------------------------------------------------------------------------
    Tstep1 = (tS{2}(2) - tS{1}(1))/(nlp.Phase(1).NumNode-1);
    Tstep2 = (tF{2}(2) - tS{1}(1))/(nlp.Phase(3).NumNode-1);      
         w = [1;1;1;1;1;1;1;1;1;1;1;1];
                
    WorkFS = SymExpression(ones(nlp.Phase(1).NumNode,1));
     for i = 1:nlp.Phase(1).NumNode-1
 WorkFS(i) = sum(sqrt((w.*uS{i}.*dxS{i}(7:18)).^2))*Tstep1; 
     end
TotalWorkFS = sum(WorkFS);
   
    WorkFF = SymExpression(ones(nlp.Phase(3).NumNode,1));
     for i = 1:nlp.Phase(3).NumNode-1
 WorkFF(i) = sum(sqrt((w.*uF{i}.*dxF{i}(7:18)).^2))*Tstep2; 
     end
TotalWorkFF = sum(WorkFF);
 
 
 TotalWork = TotalWorkFS + TotalWorkFF;
      dCOT = (TotalWork)/(Mass * g * (xF{end}(1) - xS{1}(1)));       
         
  dCOT_fun = SymFunction('dCOTall',dCOT,[tS,tF,xS,xF,dxS,dxF,uS,uF]); % use curly brackets to covert SymVar to cell arrays
                                                 % Constr   [T,H]

 dCOT_cost = NlpFunction('Name','dCOTall',...
                         'Dimension',1,...
                         'lb', -inf,...
                         'ub', +inf,...
                         'Type','Nonlinear',...
                         'SymFun',dCOT_fun,...
                         'DepVariables',[nlp.Phase(1).OptVarTable.T' ,nlp.Phase(3).OptVarTable.T',...
                                         nlp.Phase(1).OptVarTable.x' ,nlp.Phase(3).OptVarTable.x',...
                                         nlp.Phase(1).OptVarTable.dx',nlp.Phase(3).OptVarTable.dx',...
                                         nlp.Phase(1).OptVarTable.u' ,nlp.Phase(3).OptVarTable.u']); 
         
     addCost(nlp.Phase(3), 'dCOTall', 'last', dCOT_cost);
end