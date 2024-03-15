%% 1- Setup
clear; 
root = get_root_path;
addpath(root); 
addpath(genpath(fullfile(root,'A1_Optimization'))); 
addpath(fullfile(root,'A1_Gaits')); 
addpath(genpath(fullfile(root,'A1_Gaits','BoundingB2'))); 
addpath(fullfile(root,'A1_Model'));
addpath(genpath(fullfile(root,'A1_Model','gen'))); 
addpath(fullfile(root,'A1_Model','meshes'));
addpath(fullfile(root,'frost-dev'));
clc;
frost_addpath;
LOAD_PATH = fullfile(root,'A1_Gaits','BoundingB2','gen','sym');
EXPORT_PATH = fullfile(root,'A1_Gaits','BoundingB2','gen','opt');
if ~exist(EXPORT_PATH,'dir')
    mkdir(EXPORT_PATH);
end
addpath(EXPORT_PATH);

%% 2- Settings 
LOAD = false;  % load symbolic expressions instead of direct evaluation to save time, must save the symbolic expresssion first.
COMPILE = true; % compile MEX binaries.
SAVE = true;    % save symbolic expressions for load directly.
OMIT_CORIOLIS = false; % drop veloci terms.

%% 3- Load Hybrid System 
robot = A1(fullfile(root, 'A1_Model','urdf','a1Default.urdf'));  
if LOAD
    robot.loadDynamics(LOAD_PATH, OMIT_CORIOLIS,{},'OmitCoriolisSet',OMIT_CORIOLIS); 
    [sys, domains, guards] = load_behavior(robot, LOAD_PATH,'type','BoundingB2');
else
    robot.configureDynamics('DelayCoriolisSet',OMIT_CORIOLIS,'OmitCoriolisSet',OMIT_CORIOLIS); 
    [sys, domains, guards] = load_behavior(robot,[], 'type','BoundingB2');
end
                                        
%% 4- Create Optimization Problem 
% Specifying the Number of collocation points in each phase:
num_grid.stance_RRRL = 10; 
num_grid.flight_FRFL = 5;
num_grid.stance_FRFL = 10;
num_grid.flight_RRRL = 5;
nlp = HybridTrajectoryOptimization('A1_BoundingB2',sys,num_grid,[],'EqualityConstraintBoundary',1e-3);

%% 5- Add Phase Specific Constraints
nlp.Phase(1).Plant.UserNlpConstraint  = @NLPSetUp.Constraints.FRFLConstraint;     
nlp.Phase(2).Plant.UserNlpConstraint  = @NLPSetUp.Constraints.EventConstraint;     
nlp.Phase(3).Plant.UserNlpConstraint  = @NLPSetUp.Constraints.FlightRRRLConstraint;   
nlp.Phase(4).Plant.UserNlpConstraint  = @NLPSetUp.Constraints.EventConstraint;  
nlp.Phase(5).Plant.UserNlpConstraint  = @NLPSetUp.Constraints.RRRLConstraint;      
nlp.Phase(6).Plant.UserNlpConstraint  = @NLPSetUp.Constraints.EventConstraint;     
nlp.Phase(7).Plant.UserNlpConstraint  = @NLPSetUp.Constraints.FlightFRFLConstraint;   
nlp.Phase(8).Plant.UserNlpConstraint  = @NLPSetUp.Constraints.EventConstraint;      
nlp.update;

%% 6- Configure Bounds and Update
bounds = NLPSetUp.Bounds.getBounds(robot); 
if LOAD
    nlp.configure(bounds, LOAD_PATH);
else
    nlp.configure(bounds); 
end

%% 7- Add Multi-Domain Constraints
nlp = NLPSetUp.Constraints.MultidomainConstraints(nlp,bounds);
nlp.update;

%% 8- Compile All Constarints and Cost Functions
if COMPILE
     compileConstraint(nlp,[],[],EXPORT_PATH, []);
     compileObjective(nlp,[],[],EXPORT_PATH, []);
end

if SAVE
    if ~exist(LOAD_PATH,'dir') 
        mkdir(LOAD_PATH);
    end
    sys.saveExpression(LOAD_PATH);
end

%% 9- Solving the NLP Problem with default IC
solver = IpoptApplication(nlp);
[sol, info] = optimize(solver);

%% 10- Gait Search
Vx_range = 1:0.1:1.1;
FileName = 'B2_Search';
NLPSetUp.Utilities.CreateParameterStudy(FileName, sol, 1, 'Vx', 1, Vx_range);
NLPSetUp.Utilities.ProcessParameterStudy(FileName, nlp, info, robot)

%% 11- Sort Solutions
load('B2_Search')
SortSolutions = NLPSetUp.Utilities.Sort(configurations,grids);

%% 12- Gait Library and Work Calculations
for i = 1 : length(SortSolutions.V)
sol = SortSolutions.V{i}.sol;
      SortSolutions.V{i}.gait = NLPSetUp.Utilities.parse(nlp,sol); 
end
B0 = NLPSetUp.Utilities.WorkCalc(SortSolutions);
save('GaitLibrary_B2','B2')

%% 12- Animation
close all
gait = B2.V{1}.gait; % Pick a solution (B2.V{i}.gait). 
ANIM_PATH = fullfile(root,'A1_Gaits','BoundingB2','gen','anim');
if ~exist(ANIM_PATH,'dir')
    mkdir(ANIM_PATH);
end
skip_export = false; % set it to true after exporting the functions once.
load_animation(robot, gait, [], 'ExportPath', ANIM_PATH, 'SkipExporting', skip_export);