function bounds = getBounds(robot)
%% Get Bounds 
model_bounds = robot.getLimits();
bounds = struct();

% torso [x,y,z] position %
model_bounds.states.x.lb(1:3) = [-10,0,0.2];
model_bounds.states.x.ub(1:3) = [+10,0,3];

% torso [yaw,pitch,roll] position %
model_bounds.states.x.lb(4:6) = deg2rad([0,-5,0]);
model_bounds.states.x.ub(4:6) = deg2rad([0,+5,0]);

% robot pose: all joint zeros ==> leg straight down (calf unfeasible)
% hip joint angles -46 deg (to the right) to +46 deg (to the left)
model_bounds.states.x.lb([7 10 13 16]) = deg2rad(-0);
model_bounds.states.x.ub([7 10 13 16]) = deg2rad(+0);

% thigh joint angles -60 deg (forward) to +240 deg (backward) 
model_bounds.states.x.lb([8 11 14 17]) = deg2rad(-0);
model_bounds.states.x.ub([8 11 14 17]) = deg2rad(+240); 

% calf joint angles -154.5 deg (shortest) to -52.5 deg (longest)
model_bounds.states.x.lb([9 12 15 18]) = deg2rad(-154.5); 
model_bounds.states.x.ub([9 12 15 18]) = deg2rad(-52.5);  

%% Multi-Domain Constraints %%

% average velocity in x (forward) direction
bounds.average_velocity.lb = [1.9;0];   
bounds.average_velocity.ub = [2.1;0];  

% last node foot velocity (implemented as constraints in each phase)
model_bounds.swing_foot_contact_vel_FR.lb = [-0.1;-0.1;   -2;-1;-200;-1];      
model_bounds.swing_foot_contact_vel_FR.ub = [+0.1;+0.1;-0.01;+1;+200;+1];   

model_bounds.swing_foot_contact_vel_FL.lb = [-0.1;-0.1;   -2;-1;-200;-1];     
model_bounds.swing_foot_contact_vel_FL.ub = [+0.1;+0.1;-0.01;+1;+200;+1];    

model_bounds.swing_foot_contact_vel_RR.lb = [-0.1;-0.1;   -2;-1;-200;-1];     
model_bounds.swing_foot_contact_vel_RR.ub = [+0.1;+0.1;-0.01;+1;+200;+1];    

model_bounds.swing_foot_contact_vel_RL.lb = [-0.1;-0.1;   -2;-1;-200;-1];    
model_bounds.swing_foot_contact_vel_RL.ub = [+0.1;+0.1;-0.01;+1;+200;+1];    

%% Front Leg Stance phase 
bounds.stance_FRFL = model_bounds;

% virtual constraints
bounds.stance_FRFL.time.t0.lb = 0;
bounds.stance_FRFL.time.t0.ub = 0;
bounds.stance_FRFL.time.t0.x0 = 0;

bounds.stance_FRFL.time.tf.lb = 0.05;
bounds.stance_FRFL.time.tf.ub = 1;
bounds.stance_FRFL.time.tf.x0 = 0.2;

bounds.stance_FRFL.time.duration.lb = 0.05;
bounds.stance_FRFL.time.duration.ub = 1;
bounds.stance_FRFL.time.duration.x0 = 0.2;

bounds.stance_FRFL.time.kp = 100;
bounds.stance_FRFL.time.kd = 20;

bounds.stance_FRFL.states.x.lb(9) = deg2rad(-110);
bounds.stance_FRFL.states.x.ub(9) = deg2rad(-70);

bounds.stance_FRFL.states.x.lb(12) = deg2rad(-110);
bounds.stance_FRFL.states.x.ub(12) = deg2rad(-70);
 
% forces
bounds.stance_FRFL.inputs.ConstraintWrench.fFRfoot.lb = -10000;
bounds.stance_FRFL.inputs.ConstraintWrench.fFRfoot.ub = 10000;
bounds.stance_FRFL.inputs.ConstraintWrench.fFRfoot.x0 = 100;

bounds.stance_FRFL.inputs.ConstraintWrench.fFLfoot.lb = -10000;
bounds.stance_FRFL.inputs.ConstraintWrench.fFLfoot.ub = 10000;
bounds.stance_FRFL.inputs.ConstraintWrench.fFLfoot.x0 = 100;

% contacts
bounds.stance_FRFL.params.pFRfoot.lb = [0;-0.5;0];
bounds.stance_FRFL.params.pFRfoot.ub = [0.5;0;0]; 
bounds.stance_FRFL.params.pFRfoot.x0 = [0.3;-0.042628;0];

bounds.stance_FRFL.params.pFLfoot.lb = [0;0;0]; 
bounds.stance_FRFL.params.pFLfoot.ub = [0.5;0.5;0];
bounds.stance_FRFL.params.pFLfoot.x0 = [0.3;0.047;0];

bounds.stance_FRFL.params.atime.lb = -10*ones(6*12,1);
bounds.stance_FRFL.params.atime.ub =  10*ones(6*12,1);
bounds.stance_FRFL.params.atime.x0 =    zeros(6*12,1);

bounds.stance_FRFL.params.ptime.lb = [bounds.stance_FRFL.time.tf.lb, bounds.stance_FRFL.time.t0.lb];
bounds.stance_FRFL.params.ptime.ub = [bounds.stance_FRFL.time.tf.ub, bounds.stance_FRFL.time.t0.ub];
bounds.stance_FRFL.params.ptime.x0 = [bounds.stance_FRFL.time.tf.x0, bounds.stance_FRFL.time.t0.x0];

%% Rear leg stance phase
bounds.stance_RRRL = model_bounds;

% virtual constraints 
bounds.stance_RRRL.time.t0.lb = 0; 
bounds.stance_RRRL.time.t0.ub = 0;  
bounds.stance_RRRL.time.t0.x0 = 0;  

bounds.stance_RRRL.time.tf.lb = 0.05; 
bounds.stance_RRRL.time.tf.ub = 1;  
bounds.stance_RRRL.time.tf.x0 = 0.2;  

bounds.stance_RRRL.time.duration.lb = 0.05; 
bounds.stance_RRRL.time.duration.ub = 1;  
bounds.stance_RRRL.time.duration.x0 = 0.2;  

bounds.stance_RRRL.time.kp = 100;
bounds.stance_RRRL.time.kd = 20;

bounds.stance_RRRL.states.x.lb(15) = deg2rad(-110);
bounds.stance_RRRL.states.x.ub(15) = deg2rad(-70);

bounds.stance_RRRL.states.x.lb(18) = deg2rad(-110);
bounds.stance_RRRL.states.x.ub(18) = deg2rad(-70);

% forces
bounds.stance_RRRL.inputs.ConstraintWrench.fRRfoot.lb = -10000;
bounds.stance_RRRL.inputs.ConstraintWrench.fRRfoot.ub = 10000;
bounds.stance_RRRL.inputs.ConstraintWrench.fRRfoot.x0 = 100;

bounds.stance_RRRL.inputs.ConstraintWrench.fRLfoot.lb = -10000;
bounds.stance_RRRL.inputs.ConstraintWrench.fRLfoot.ub = 10000;
bounds.stance_RRRL.inputs.ConstraintWrench.fRLfoot.x0 = 100;

% contacts
bounds.stance_RRRL.params.pRRfoot.lb = [-0.5;-0.5;0];
bounds.stance_RRRL.params.pRRfoot.ub = [0;0;0];
bounds.stance_RRRL.params.pRRfoot.x0 = [-0.157538;-0.042628;0];

bounds.stance_RRRL.params.pRLfoot.lb = [-0.5;0;0];
bounds.stance_RRRL.params.pRLfoot.ub = [0;0.5;0];
bounds.stance_RRRL.params.pRLfoot.x0 = [-0.157538;0.047;0];

bounds.stance_RRRL.params.atime.lb = -10*ones(6*12,1);
bounds.stance_RRRL.params.atime.ub =  10*ones(6*12,1);
bounds.stance_RRRL.params.atime.x0 =    zeros(6*12,1);

bounds.stance_RRRL.params.ptime.lb = [bounds.stance_RRRL.time.tf.lb, bounds.stance_RRRL.time.t0.lb];
bounds.stance_RRRL.params.ptime.ub = [bounds.stance_RRRL.time.tf.ub, bounds.stance_RRRL.time.t0.ub];
bounds.stance_RRRL.params.ptime.x0 = [bounds.stance_RRRL.time.tf.x0, bounds.stance_RRRL.time.t0.x0];

%% Flight Phase FRFL 
bounds.flight_FRFL = model_bounds;

% virtual constraints 
bounds.flight_FRFL.time.t0.lb = 0;
bounds.flight_FRFL.time.t0.ub = 0;
bounds.flight_FRFL.time.t0.x0 = 0;

bounds.flight_FRFL.time.tf.lb = 0.05;
bounds.flight_FRFL.time.tf.ub = 1;
bounds.flight_FRFL.time.tf.x0 = 0.5;

bounds.flight_FRFL.time.duration.lb = 0.05;
bounds.flight_FRFL.time.duration.ub = 1;
bounds.flight_FRFL.time.duration.x0 = 0.5;

bounds.flight_FRFL.time.kp = 100;
bounds.flight_FRFL.time.kd = 20;

bounds.flight_FRFL.params.atime.lb = -10*ones(6*12,1); 
bounds.flight_FRFL.params.atime.ub =  10*ones(6*12,1);
bounds.flight_FRFL.params.atime.x0 =    zeros(6*12,1);

bounds.flight_FRFL.params.ptime.lb = [bounds.flight_FRFL.time.tf.lb, bounds.flight_FRFL.time.t0.lb];
bounds.flight_FRFL.params.ptime.ub = [bounds.flight_FRFL.time.tf.ub, bounds.flight_FRFL.time.t0.ub];
bounds.flight_FRFL.params.ptime.x0 = [bounds.flight_FRFL.time.tf.x0, bounds.flight_FRFL.time.t0.x0];

%% Flight Phase RRRL 
bounds.flight_RRRL = model_bounds;

% virtual constraints 
bounds.flight_RRRL.time.t0.lb = 0;
bounds.flight_RRRL.time.t0.ub = 0;
bounds.flight_RRRL.time.t0.x0 = 0;

bounds.flight_RRRL.time.tf.lb = 0.05;
bounds.flight_RRRL.time.tf.ub = 1;
bounds.flight_RRRL.time.tf.x0 = 0.5;

bounds.flight_RRRL.time.duration.lb = 0.05;
bounds.flight_RRRL.time.duration.ub = 1;
bounds.flight_RRRL.time.duration.x0 = 0.5;

bounds.flight_RRRL.time.kp = 100;
bounds.flight_RRRL.time.kd = 20;

bounds.flight_RRRL.params.atime.lb = -10*ones(6*12,1);
bounds.flight_RRRL.params.atime.ub =  10*ones(6*12,1);
bounds.flight_RRRL.params.atime.x0 =    zeros(6*12,1);

bounds.flight_RRRL.params.ptime.lb = [bounds.flight_RRRL.time.tf.lb, bounds.flight_RRRL.time.t0.lb];
bounds.flight_RRRL.params.ptime.ub = [bounds.flight_RRRL.time.tf.ub, bounds.flight_RRRL.time.t0.ub];
bounds.flight_RRRL.params.ptime.x0 = [bounds.flight_RRRL.time.tf.x0, bounds.flight_RRRL.time.t0.x0];

%% discrete events

bounds.RRRLtd = model_bounds;
bounds.FRFLtd = model_bounds;

bounds.RRRLlo = model_bounds;
bounds.FRFLlo = model_bounds;

end
