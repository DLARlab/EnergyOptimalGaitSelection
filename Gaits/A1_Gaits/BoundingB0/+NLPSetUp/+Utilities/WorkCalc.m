%% 4- Calculate the work of each joint
function WorkStruc = WorkCalc(GaitStructure)

DATA = GaitStructure;
for i = 1 : length(DATA.V) 
% Time ----------------------------------------------------------------------------------------------------------
        t1 = DATA.V{i}.gait(1).tspan;  
        t2 = DATA.V{i}.gait(3).tspan;
        t3 = DATA.V{i}.gait(5).tspan;  
        t4 = DATA.V{i}.gait(7).tspan;
    Tstep1 = t1(2) - t1(1); 
    Tstep2 = t2(2) - t2(1);     
    Tstep3 = t3(2) - t3(1);
    Tstep4 = t4(2) - t4(1); 
    
% Power of each joint --------------------------------------------------------------------------------------------
o = 0;
for j = 1 : 4   % gait indecies for bounding 1, 3 ,5, 7
   DATA.V{i}.gait(j+o).Power(1,:) = DATA.V{i}.gait(j+o).states.dx(7,:) .* DATA.V{i}.gait(j+o).inputs.u(1,:); 
   DATA.V{i}.gait(j+o).Power(2,:) = DATA.V{i}.gait(j+o).states.dx(8,:) .* DATA.V{i}.gait(j+o).inputs.u(2,:); 
   DATA.V{i}.gait(j+o).Power(3,:) = DATA.V{i}.gait(j+o).states.dx(9,:) .* DATA.V{i}.gait(j+o).inputs.u(3,:); 
   DATA.V{i}.gait(j+o).Power(4,:) = DATA.V{i}.gait(j+o).states.dx(10,:) .* DATA.V{i}.gait(j+o).inputs.u(4,:); 
   DATA.V{i}.gait(j+o).Power(5,:) = DATA.V{i}.gait(j+o).states.dx(11,:) .* DATA.V{i}.gait(j+o).inputs.u(5,:); 
   DATA.V{i}.gait(j+o).Power(6,:) = DATA.V{i}.gait(j+o).states.dx(12,:) .* DATA.V{i}.gait(j+o).inputs.u(6,:); 
   DATA.V{i}.gait(j+o).Power(7,:) = DATA.V{i}.gait(j+o).states.dx(13,:) .* DATA.V{i}.gait(j+o).inputs.u(7,:); 
   DATA.V{i}.gait(j+o).Power(8,:) = DATA.V{i}.gait(j+o).states.dx(14,:) .* DATA.V{i}.gait(j+o).inputs.u(8,:); 
   DATA.V{i}.gait(j+o).Power(9,:) = DATA.V{i}.gait(j+o).states.dx(15,:) .* DATA.V{i}.gait(j+o).inputs.u(9,:); 
   DATA.V{i}.gait(j+o).Power(10,:) = DATA.V{i}.gait(j+o).states.dx(16,:) .* DATA.V{i}.gait(j+o).inputs.u(10,:); 
   DATA.V{i}.gait(j+o).Power(11,:) = DATA.V{i}.gait(j+o).states.dx(17,:) .* DATA.V{i}.gait(j+o).inputs.u(11,:); 
   DATA.V{i}.gait(j+o).Power(12,:) = DATA.V{i}.gait(j+o).states.dx(18,:) .* DATA.V{i}.gait(j+o).inputs.u(12,:); 
  o = o + 1;
end

% Work of each joint --------------------------------------------------------------------------------------------
 o = 0;
 TimeStep = [Tstep1 Tstep2 Tstep3 Tstep4];
for j = 1 : 4
   DATA.V{i}.gait(j+o).iWork(1,:) = DATA.V{i}.gait(j+o).Power(1,:).*TimeStep(j);
   DATA.V{i}.gait(j+o).iWork(2,:) = DATA.V{i}.gait(j+o).Power(2,:).*TimeStep(j);
   DATA.V{i}.gait(j+o).iWork(3,:) = DATA.V{i}.gait(j+o).Power(3,:).*TimeStep(j);
   DATA.V{i}.gait(j+o).iWork(4,:) = DATA.V{i}.gait(j+o).Power(4,:).*TimeStep(j);
   DATA.V{i}.gait(j+o).iWork(5,:) = DATA.V{i}.gait(j+o).Power(5,:).*TimeStep(j);
   DATA.V{i}.gait(j+o).iWork(6,:) = DATA.V{i}.gait(j+o).Power(6,:).*TimeStep(j);
   DATA.V{i}.gait(j+o).iWork(7,:) = DATA.V{i}.gait(j+o).Power(7,:).*TimeStep(j);
   DATA.V{i}.gait(j+o).iWork(8,:) = DATA.V{i}.gait(j+o).Power(8,:).*TimeStep(j);
   DATA.V{i}.gait(j+o).iWork(9,:) = DATA.V{i}.gait(j+o).Power(9,:).*TimeStep(j);
  DATA.V{i}.gait(j+o).iWork(10,:) = DATA.V{i}.gait(j+o).Power(10,:).*TimeStep(j);
  DATA.V{i}.gait(j+o).iWork(11,:) = DATA.V{i}.gait(j+o).Power(11,:).*TimeStep(j);
  DATA.V{i}.gait(j+o).iWork(12,:) = DATA.V{i}.gait(j+o).Power(12,:).*TimeStep(j);
  o = o + 1;
end 

% Extarct positive and negative work of each joint ----------------------------------------------------------------
o = 0;
for j = 1 : 4
    for k = 1 : 12
                 ExtractPositive = DATA.V{i}.gait(j+o).iWork(k,:) > 0;
                 ExtractNegative = DATA.V{i}.gait(j+o).iWork(k,:) < 0;
                             yyy = DATA.V{i}.gait(j+o).iWork(k,:);
  DATA.V{i}.gait(j+o).pWork(k,1) = sum(yyy(ExtractPositive));
  DATA.V{i}.gait(j+o).nWork(k,1) = sum(yyy(ExtractNegative));                      
    end
  o = o + 1;
end

end
%   
 WorkStruc = DATA;
end