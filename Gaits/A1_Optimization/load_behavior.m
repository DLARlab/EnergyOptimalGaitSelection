function [sys,domains,guards] = load_behavior(robot, load_path, varargin)   % load gait behavior of A1 %

% (Domains = Phases)  e.g. Flight Phase, Stance Phase , (Guards = Triger Events)  e.g. Touchdown, Lift-off %
% FR = Front Right Leg, FL = Front Left Leg, RR = Rear Right Leg, RL = Rear Left Leg %  

% Parse inputs
p = inputParser;
p.addOptional('type', 'BoundingBE')
p.parse(varargin{:});
parser_results = p.Results;   
    
% Choose behavior type %
    switch parser_results.type
%----------------------------------------------------------------------------------------------------------------------------------------------------%
        case 'PronkingPF'  % stance_FRFLRRRL -> flight %
            
            % --Define domains-- %
            stance_FRFLRRRL = AllPhases.continuous(robot, load_path, 'stanceleg', 'FRFLRRRL', 'guard', 'FRFLRRRLlo');           
                     flight = AllPhases.continuous(robot, load_path, 'stanceleg', 'none'    , 'guard', 'FRFLRRRLtd'); % 'FRFLRRRLtd' % RRRLtd
            
            % --Define guards-- %
                FRFLRRRL_td = AllPhases.discrete(robot, load_path, 'leg', 'FRFLRRRL', 'event', 'td', 'next_domain', 'FRFLRRRL');
                FRFLRRRL_lo = AllPhases.discrete(robot, load_path, 'leg', 'FRFLRRRL', 'event', 'lo', 'next_domain', 'flight');
 
            domains = [stance_FRFLRRRL,  flight]; 
             guards = [FRFLRRRL_lo, FRFLRRRL_td]; 
            
            % --Define hybrid system-- %
            srcs = {'stance_FRFLRRRL','flight'};                                    % (srcs = Source)  %
            tars = circshift(srcs,-1); % circularly left shift by 1                 % (tars = Targets) %
             sys = HybridSystem('A1');
             sys = addVertex(sys, srcs, 'Domain', {stance_FRFLRRRL, flight});
             sys = addEdge(sys, srcs, tars);
             sys = setEdgeProperties(sys, srcs, tars, 'Guard', {FRFLRRRL_lo,FRFLRRRL_td}); 
                
%----------------------------------------------------------------------------------------------------------------------------------------------------%
         case 'BoundingB2' % stance_FRFL -> flight -> stance_RRRL -> flight %
   
            % --Define domains-- % 
            stance_FRFL = AllPhases.continuous(robot, load_path, 'stanceleg', 'FRFL', 'guard', 'FRFLlo');          
            stance_RRRL = AllPhases.continuous(robot, load_path, 'stanceleg', 'RRRL', 'guard', 'RRRLlo');     
            flight_RRRL = AllPhases.continuous(robot, load_path, 'stanceleg', 'none', 'guard', 'RRRLtd'); 
            flight_FRFL = AllPhases.continuous(robot, load_path, 'stanceleg', 'none', 'guard', 'FRFLtd'); 
            
            % --Define guards-- %
            RRRL_td = AllPhases.discrete(robot, load_path, 'leg', 'RRRL', 'event', 'td', 'next_domain', 'RRRL');
            FRFL_td = AllPhases.discrete(robot, load_path, 'leg', 'FRFL', 'event', 'td', 'next_domain', 'FRFL');
            RRRL_lo = AllPhases.discrete(robot, load_path, 'leg', 'RRRL', 'event', 'lo', 'next_domain', 'flight');
            FRFL_lo = AllPhases.discrete(robot, load_path, 'leg', 'FRFL', 'event', 'lo', 'next_domain', 'flight');
 
            domains = [stance_FRFL, flight_RRRL, stance_RRRL, flight_FRFL];
            guards = [FRFL_lo, RRRL_td, RRRL_lo, FRFL_td];
            
            % --Define hybrid system-- %
            srcs = {'stance_FRFL','flight_RRRL','stance_RRRL','flight_FRFL'};      
            tars = circshift(srcs,-1);                 
             sys = HybridSystem('A1');
             sys = addVertex(sys, srcs, 'Domain', {stance_FRFL, flight_RRRL, stance_RRRL, flight_FRFL});
             sys = addEdge(sys, srcs, tars);
             sys = setEdgeProperties(sys, srcs, tars, 'Guard', {FRFL_lo, RRRL_td, RRRL_lo, FRFL_td});    
            
%----------------------------------------------------------------------------------------------------------------------------------------------------%   
        case 'BoundingBE'  % stance_FRFL -> stance_FRFLRRRL -> stance_RRRL -> flight %
                
            % --Define domains-- % 
                stance_FRFL = AllPhases.continuous(robot, load_path,'stanceleg','FRFL'    ,'guard','RRRLtd');   
            stance_FRFLRRRL = AllPhases.continuous(robot, load_path,'stanceleg','FRFLRRRL','guard','FRFLlo'); 
                stance_RRRL = AllPhases.continuous(robot, load_path,'stanceleg','RRRL'    ,'guard','RRRLlo');  
                flight_FRFL = AllPhases.continuous(robot, load_path,'stanceleg','none'    ,'guard','FRFLtd');
      
            % --Define guards-- %
                FRFL_td = AllPhases.discrete(robot, load_path,'leg','FRFL','event','td','next_domain','FRFL');
                RRRL_td = AllPhases.discrete(robot, load_path,'leg','RRRL','event','td','next_domain','FRFLRRRL');
                FRFL_lo = AllPhases.discrete(robot, load_path,'leg','FRFL','event','lo','next_domain','RRRL');
                RRRL_lo = AllPhases.discrete(robot, load_path,'leg','RRRL','event','lo','next_domain','flight');
 
            domains = [stance_FRFL, stance_FRFLRRRL, stance_RRRL, flight_FRFL];
             guards = [RRRL_td, FRFL_lo, RRRL_lo, FRFL_td];
            
            % --Define hybrid system-- %
            srcs = {'stance_FRFL', 'stance_FRFLRRRL', 'stance_RRRL', 'flight_FRFL'};   
            tars = circshift(srcs,-1);                 
             sys = HybridSystem('A1');
             sys = addVertex(sys, srcs, 'Domain', {stance_FRFL, stance_FRFLRRRL, stance_RRRL, flight_FRFL});
             sys = addEdge(sys, srcs, tars);
             sys = setEdgeProperties(sys, srcs, tars, 'Guard', {RRRL_td, FRFL_lo, RRRL_lo, FRFL_td}); 

%----------------------------------------------------------------------------------------------------------------------------------------------------%
         case 'BoundingBG'  % stance_RRRL -> stance_FRFLRRRL -> stance_FRFL -> flight %
                
            % --Define domains-- % 
                stance_RRRL = AllPhases.continuous(robot, load_path,'stanceleg',    'RRRL','guard','FRFLtd');  
            stance_FRFLRRRL = AllPhases.continuous(robot, load_path,'stanceleg','FRFLRRRL','guard','RRRLlo'); 
                stance_FRFL = AllPhases.continuous(robot, load_path,'stanceleg',    'FRFL','guard','FRFLlo');   
                flight_RRRL = AllPhases.continuous(robot, load_path,'stanceleg',    'none','guard','RRRLtd');
      
            % --Define guards-- %
                RRRL_td = AllPhases.discrete(robot, load_path,'leg','RRRL','event','td','next_domain','RRRL');
                FRFL_td = AllPhases.discrete(robot, load_path,'leg','FRFL','event','td','next_domain','FRFLRRRL');
                RRRL_lo = AllPhases.discrete(robot, load_path,'leg','RRRL','event','lo','next_domain','FRFL');
                FRFL_lo = AllPhases.discrete(robot, load_path,'leg','FRFL','event','lo','next_domain','flight');
 
            domains = [stance_RRRL, stance_FRFLRRRL, stance_FRFL, flight_RRRL];
             guards = [FRFL_td, RRRL_lo, FRFL_lo, RRRL_td];
            
            % --Define hybrid system-- %
            srcs = {'stance_RRRL', 'stance_FRFLRRRL', 'stance_FRFL', 'flight_RRRL'};   
            tars = circshift(srcs,-1);                 
             sys = HybridSystem('A1');
             sys = addVertex(sys, srcs, 'Domain', {stance_RRRL, stance_FRFLRRRL, stance_FRFL, flight_RRRL});
             sys = addEdge(sys, srcs, tars);
             sys = setEdgeProperties(sys, srcs, tars, 'Guard', {FRFL_td, RRRL_lo, FRFL_lo, RRRL_td}); 
             
%----------------------------------------------------------------------------------------------------------------------------------------------------%
        case 'BoundingB0'  % stance_FRFL -> stance_FRFLRRRL -> stance_RRRL -> stance_FRFLRRRL %
                
            % --Define domains-- % 
                stance_FRFL = AllPhases.continuous(robot, load_path,'stanceleg',    'FRFL','guard','RRRLtd');   
           stance_FRFLRRRL1 = AllPhases.continuous(robot, load_path,'stanceleg','FRFLRRRL','guard','FRFLlo'); 
                stance_RRRL = AllPhases.continuous(robot, load_path,'stanceleg',    'RRRL','guard','FRFLtd'); 
           stance_FRFLRRRL2 = AllPhases.continuous(robot, load_path,'stanceleg','FRFLRRRL','guard','RRRLlo'); 
      
            % --Define guards-- %
                FRFL_td = AllPhases.discrete(robot, load_path,'leg','FRFL','event','td','next_domain','FRFLRRRL');
                RRRL_td = AllPhases.discrete(robot, load_path,'leg','RRRL','event','td','next_domain','FRFLRRRL');
                FRFL_lo = AllPhases.discrete(robot, load_path,'leg','FRFL','event','lo','next_domain','RRRL');
                RRRL_lo = AllPhases.discrete(robot, load_path,'leg','RRRL','event','lo','next_domain','FRFL');
 
            domains = [stance_FRFL, stance_FRFLRRRL1, stance_RRRL, stance_FRFLRRRL2];
             guards = [    RRRL_td,          FRFL_lo,     FRFL_td,          RRRL_lo];
            
            % --Define hybrid system-- %
            srcs = {'stance_FRFL', 'stance_FRFLRRRL1', 'stance_RRRL', 'stance_FRFLRRRL2'};   
            tars = circshift(srcs,-1);                 
             sys = HybridSystem('A1');
             sys = addVertex(sys, srcs, 'Domain', {stance_FRFL, stance_FRFLRRRL1, stance_RRRL, stance_FRFLRRRL2});
             sys = addEdge(sys, srcs, tars);
             sys = setEdgeProperties(sys, srcs, tars, 'Guard', {RRRL_td, FRFL_lo, FRFL_td, RRRL_lo}); 
          
%----------------------------------------------------------------------------------------------------------------------------------------------------%
         otherwise
              error('Unknown behavior type')
            
    end
    
    
end
