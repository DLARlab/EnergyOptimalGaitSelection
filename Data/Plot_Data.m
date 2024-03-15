%% 1- Setup 
clear; 
root = get_root_path;
addpath(genpath(fullfile(root,'Data'))); 
set(0,'units','inches')
Inch_SS = get(0,'screensize') - 0.8;
clc;

%% 2- Plot Duty Cycle, Stride Time, and COT
load('BE_GaitLibrary.mat')
load('BG_GaitLibrary.mat')
load('B2_GaitLibrary.mat')
load('B0_GaitLibrary.mat')
load('PF_GaitLibrary.mat')

VectorB2_GL = zeros(3,length(BoundingB2.V)); % No. of data
VectorBG_GL = zeros(3,length(BoundingBG.V)); % No. of data
VectorBE_GL = zeros(3,length(BoundingBE.V)); % No. of data
VectorB0_GL = zeros(3,length(BoundingB0.V)); % No. of data
VectorPF_GL = zeros(3,length(PronkingPF.V)); % No. of data

vBE = BoundingBE.V{1}.Velocity : 0.1 : BoundingBE.V{end}.Velocity; 
  for k = 1:length(BoundingBE.V) % No. of data            
    Phase1_Time =  BoundingBE.V{k}.gait(1).tspan(end);
    Phase2_Time = (BoundingBE.V{k}.gait(3).tspan(end) - BoundingBE.V{k}.gait(3).tspan(1));
    Phase3_Time = (BoundingBE.V{k}.gait(5).tspan(end) - BoundingBE.V{k}.gait(5).tspan(1));
    Stride_Time =  BoundingBE.V{k}.gait(7).tspan(end);
    % Duty Factor
    VectorBE_GL(1,k) = (((Phase1_Time + Phase2_Time) +  (Phase2_Time + Phase3_Time))/2)/Stride_Time;
    % Stride Time
    VectorBE_GL(2,k) = BoundingBE.V{k}.gait(7).tspan(end);
    % COT 
    VectorBE_GL(3,k) = BoundingBE.V{k}.CostValue;   
  end

vBG = BoundingBG.V{1}.Velocity : 0.1 : BoundingBG.V{end}.Velocity; 
  for k = 1:length(BoundingBG.V) % No. of data             
    Phase1_Time =  BoundingBG.V{k}.gait(1).tspan(end);
    Phase2_Time = (BoundingBG.V{k}.gait(3).tspan(end) - BoundingBG.V{k}.gait(3).tspan(1));
    Phase3_Time = (BoundingBG.V{k}.gait(5).tspan(end) - BoundingBG.V{k}.gait(5).tspan(1));
    Stride_Time =  BoundingBG.V{k}.gait(7).tspan(end);
    % Duty Factor
    VectorBG_GL(1,k) = (((Phase1_Time + Phase2_Time) +  (Phase2_Time + Phase3_Time))/2)/Stride_Time;
    % Stride Time
    VectorBG_GL(2,k) = BoundingBG.V{k}.gait(7).tspan(end);
    % COT 
    VectorBG_GL(3,k) = BoundingBG.V{k}.CostValue;   
  end

vB2 = BoundingB2.V{1}.Velocity : 0.1 : BoundingB2.V{end}.Velocity; 
  for k = 1:length(BoundingB2.V)% No. of data             
    Phase1_Time =  BoundingB2.V{k}.gait(1).tspan(end);
    Phase2_Time = (BoundingB2.V{k}.gait(5).tspan(end) - BoundingB2.V{k}.gait(5).tspan(1));
    Stride_Time =  BoundingB2.V{k}.gait(7).tspan(end);
    % Duty Factor
    VectorB2_GL(1,k) = ((Phase1_Time + Phase2_Time)/2)/Stride_Time;
    % Stride Time
    VectorB2_GL(2,k) = BoundingB2.V{k}.gait(7).tspan(end);
    % COT 
    VectorB2_GL(3,k) = BoundingB2.V{k}.CostValue;   
  end
   
vB0 = BoundingB0.V{1}.Velocity : 0.1 : BoundingB0.V{end}.Velocity; 
  for k = 1:15 % No. of data             
    Phase1_Time =  BoundingB0.V{k}.gait(1).tspan(end);
    Phase2_Time = (BoundingB0.V{k}.gait(3).tspan(end) - BoundingB0.V{k}.gait(3).tspan(1));
    Phase3_Time = (BoundingB0.V{k}.gait(5).tspan(end) - BoundingB0.V{k}.gait(5).tspan(1));
    Phase4_Time = (BoundingB0.V{k}.gait(7).tspan(end) - BoundingB0.V{k}.gait(7).tspan(1));
    Stride_Time =  BoundingB0.V{k}.gait(7).tspan(end);
    % Duty Factor
    VectorB0_GL(1,k) = (((Phase1_Time + Phase2_Time + Phase4_Time) +  (Phase2_Time + Phase3_Time + Phase4_Time))/2)/Stride_Time;
    % Stride Time
    VectorB0_GL(2,k) = BoundingB0.V{k}.gait(7).tspan(end);
    % COT 
    VectorB0_GL(3,k) = BoundingB0.V{k}.CostValue;   
  end
  
vPF = PronkingPF.V{1}.Velocity : 0.1 : PronkingPF.V{end}.Velocity; 
  for k = 1:47 % No. of data             
     Phase1_Time =  PronkingPF.V{k}.gait(1).tspan(end);
     Stride_Time =  PronkingPF.V{k}.gait(3).tspan(end);
    % Duty Factor
    VectorPF_GL(1,k) = Phase1_Time/Stride_Time;
    % Stride Time
    VectorPF_GL(2,k) = PronkingPF.V{k}.gait(3).tspan(end);
    % COT 
    VectorPF_GL(3,k) = PronkingPF.V{k}.CostValue;  
  end

f1 = figure;
f1.Units = 'inches';
f1.Position = [0 0 0.3*Inch_SS(3) Inch_SS(4)];
f1.Color = 'w';
set(gca,'box','off')
tiledlayout(4,1);
tiltNo = [1 1 2];
Ylabel = {'Duty Cycle (%)', 'Stride Time (s)', 'COT'}; 

for n = 1:3
nexttile(n,[tiltNo(n) 1]);
plot(vBE,VectorBE_GL(n,:),'linewidth',2,'Color',[0.4660 0.6740 0.1880]);
hold on 
plot(vBG,VectorBG_GL(n,:),'linewidth',2,'Color',[0.8500 0.3250 0.0980]);
hold on 
plot(vB2,VectorB2_GL(n,:),'linewidth',2,'Color',[0 0.4470 0.7410]);
hold on 
plot(vB0,VectorB0_GL(n,:),'linewidth',2,'Color',[0.9290 0.6940 0.1250]);
hold on
plot(vPF,VectorPF_GL(n,:),'linewidth',2,'Color',[0.4940 0.1840 0.5560]);
grid on
ylabel(Ylabel(n))
end
xlabel('Average Velocity  (m/s)' )
legend('BE','BG','B2','B0','PF') 

%% 3- Plot Joints Work (3D bar)
Velocity = '1.9';
DATA.Bounding{3} = BoundingBE.V{1,15}.gait;  % 15
DATA.Bounding{2} = BoundingBG.V{1,16}.gait;  % 16
DATA.Bounding{1} = BoundingB2.V{1,17}.gait;  % 17
DATA.Bounding{4} = BoundingB0.V{1,15}.gait;  % 15
%-------------------------BE
DATA.Bounding{3}(1).FTSPW =      DATA.Bounding{3}(1).PositiveWork(2)  +     DATA.Bounding{3}(3).PositiveWork(2);  % Front Thigh Stance Positive Work
DATA.Bounding{3}(1).FTSNW =  abs(DATA.Bounding{3}(1).NegativeWork(2)) + abs(DATA.Bounding{3}(3).NegativeWork(2)); % Front Thigh Stance Negative Work
DATA.Bounding{3}(1).FTFPW =      DATA.Bounding{3}(5).PositiveWork(2)  +     DATA.Bounding{3}(7).PositiveWork(2);  % Front Thigh Flight Positive Work
DATA.Bounding{3}(1).FTFNW =  abs(DATA.Bounding{3}(5).NegativeWork(2)) + abs(DATA.Bounding{3}(7).NegativeWork(2)); % Front Thigh Flight Negative Work

DATA.Bounding{3}(1).FCSPW =      DATA.Bounding{3}(1).PositiveWork(3)  +     DATA.Bounding{3}(3).PositiveWork(3);  % Front Calf Stance Positive Work
DATA.Bounding{3}(1).FCSNW =  abs(DATA.Bounding{3}(1).NegativeWork(3)) + abs(DATA.Bounding{3}(3).NegativeWork(3)); % Front Calf Stance Negative Work
DATA.Bounding{3}(1).FCFPW =      DATA.Bounding{3}(5).PositiveWork(3)  +     DATA.Bounding{3}(7).PositiveWork(3);  % Front Calf Flight Positive Work
DATA.Bounding{3}(1).FCFNW =  abs(DATA.Bounding{3}(5).NegativeWork(3)) + abs(DATA.Bounding{3}(7).NegativeWork(3)); % Front Calf Flight Negative Work   
%-------------------------BG
DATA.Bounding{2}(1).FTSPW =      DATA.Bounding{2}(3).PositiveWork(2)  +     DATA.Bounding{2}(5).PositiveWork(2);
DATA.Bounding{2}(1).FTSNW =  abs(DATA.Bounding{2}(3).NegativeWork(2)) + abs(DATA.Bounding{2}(5).NegativeWork(2));
DATA.Bounding{2}(1).FTFPW =      DATA.Bounding{2}(1).PositiveWork(2)  +     DATA.Bounding{2}(7).PositiveWork(2);
DATA.Bounding{2}(1).FTFNW =  abs(DATA.Bounding{2}(1).NegativeWork(2)) + abs(DATA.Bounding{2}(7).NegativeWork(2));

DATA.Bounding{2}(1).FCSPW =      DATA.Bounding{2}(3).PositiveWork(3)  +     DATA.Bounding{2}(5).PositiveWork(3);
DATA.Bounding{2}(1).FCSNW =  abs(DATA.Bounding{2}(3).NegativeWork(3)) + abs(DATA.Bounding{2}(5).NegativeWork(3));
DATA.Bounding{2}(1).FCFPW =      DATA.Bounding{2}(1).PositiveWork(3)  +     DATA.Bounding{2}(7).PositiveWork(3); 
DATA.Bounding{2}(1).FCFNW =  abs(DATA.Bounding{2}(1).NegativeWork(3)) + abs(DATA.Bounding{2}(7).NegativeWork(3));  
%-------------------------B2
DATA.Bounding{1}(1).FTSPW =       DATA.Bounding{1}(1).PositiveWork(2);
DATA.Bounding{1}(1).FTSNW =   abs(DATA.Bounding{1}(1).NegativeWork(2));
DATA.Bounding{1}(1).FTFPW =       DATA.Bounding{1}(3).PositiveWork(2)  +     DATA.Bounding{1}(5).PositiveWork(2)  +     DATA.Bounding{1}(7).PositiveWork(2);
DATA.Bounding{1}(1).FTFNW =   abs(DATA.Bounding{1}(3).NegativeWork(2)) + abs(DATA.Bounding{1}(5).NegativeWork(2)) + abs(DATA.Bounding{1}(7).NegativeWork(2));

DATA.Bounding{1}(1).FCSPW =       DATA.Bounding{1}(1).PositiveWork(3);
DATA.Bounding{1}(1).FCSNW =   abs(DATA.Bounding{1}(1).NegativeWork(3));
DATA.Bounding{1}(1).FCFPW =       DATA.Bounding{1}(3).PositiveWork(3)  +     DATA.Bounding{1}(5).PositiveWork(3)  +     DATA.Bounding{1}(7).PositiveWork(3);
DATA.Bounding{1}(1).FCFNW =   abs(DATA.Bounding{1}(3).NegativeWork(3)) + abs(DATA.Bounding{1}(5).NegativeWork(3)) + abs(DATA.Bounding{1}(7).NegativeWork(3));        
%-------------------------B0
DATA.Bounding{4}(1).FTSPW =      DATA.Bounding{4}(1).PositiveWork(2)  +     DATA.Bounding{4}(3).PositiveWork(2)  +     DATA.Bounding{4}(7).PositiveWork(2);
DATA.Bounding{4}(1).FTSNW =  abs(DATA.Bounding{4}(1).NegativeWork(2)) + abs(DATA.Bounding{4}(3).NegativeWork(2)) + abs(DATA.Bounding{4}(7).NegativeWork(2));
DATA.Bounding{4}(1).FTFPW =      DATA.Bounding{4}(5).PositiveWork(2)  ;
DATA.Bounding{4}(1).FTFNW =  abs(DATA.Bounding{4}(5).NegativeWork(2)) ;

DATA.Bounding{4}(1).FCSPW =      DATA.Bounding{4}(1).PositiveWork(3)  +     DATA.Bounding{4}(3).PositiveWork(3)  +     DATA.Bounding{4}(7).PositiveWork(3);
DATA.Bounding{4}(1).FCSNW =  abs(DATA.Bounding{4}(1).NegativeWork(3)) + abs(DATA.Bounding{4}(3).NegativeWork(3)) + abs(DATA.Bounding{4}(7).NegativeWork(3));
DATA.Bounding{4}(1).FCFPW =      DATA.Bounding{4}(5).PositiveWork(3)  ; 
DATA.Bounding{4}(1).FCFNW =  abs(DATA.Bounding{4}(5).NegativeWork(3)) ;    

% Plot Front Thigh Negative Stance Work
fa = figure;
fa.Units = 'inches'; 
fa.Color = 'w';
m = 0;
for j = 1 : 4
if j == 4
    m = -1;
end
Bar1 = bar3(DATA.Bounding{j}(1).FTSNW);
hold on
zz = get(Bar1,'Zdata');
zz = zz + DATA.Bounding{j}(1).FTSPW;
set(Bar1,'Zdata',zz);
set(Bar1,'FaceColor',[ 0.9686   0.4118    0]);
yy = get(Bar1,'Ydata');
yy = yy + m;
set(Bar1,'Ydata',yy);
hold on

% Plot Front Thigh Positive Stance Work      
Bar2 = bar3(DATA.Bounding{j}(1).FTSPW);
set(Bar2,'FaceColor',[0.7500    0.7500    0.7500]);
yy = get(Bar2,'Ydata');
yy = yy + m;
set(Bar2,'Ydata',yy);
hold on

% Plot Front Thigh Negative Flight Work      
Bar3 = bar3(DATA.Bounding{j}(1).FTFNW);
zz = get(Bar3,'Zdata');
zz = zz + DATA.Bounding{j}(1).FTFPW;
set(Bar3,'Zdata',zz);
set(Bar3,'FaceColor',[ 0.9686   0.4118    0]);
xx = get(Bar3,'Xdata');
xx = xx + 8;
set(Bar3,'Xdata',xx);
yy = get(Bar3,'Ydata');
yy = yy + m;
set(Bar3,'Ydata',yy);
hold on

% Plot Front Thigh Positive Flight Work 
Bar4 = bar3(DATA.Bounding{j}(1).FTFPW);
set(Bar4,'FaceColor',[0.7500    0.7500    0.7500]);
xx = get(Bar4,'Xdata');
xx = xx + 8;
set(Bar4,'Xdata',xx);
yy = get(Bar4,'Ydata');
yy = yy + m;
set(Bar4,'Ydata',yy);
hold on

% Plot Front Calf Negative Stance Work
Bar5 = bar3(DATA.Bounding{j}(1).FCSNW);
hold on
zz = get(Bar5,'Zdata');
zz = zz + DATA.Bounding{j}(1).FCSPW;
set(Bar5,'Zdata',zz);
set(Bar5,'FaceColor',[ 0.9686   0.4118    0]);
yy = get(Bar5,'Ydata');
yy = yy + 8 + m;
set(Bar5,'Ydata',yy);
hold on

% Plot Front Calf Positive Stance Work      
Bar6 = bar3(DATA.Bounding{j}(1).FCSPW);
set(Bar6,'FaceColor',[0.7500    0.7500    0.7500]);
yy = get(Bar6,'Ydata');
yy = yy + 8 + m;
set(Bar6,'Ydata',yy);
hold on

% Plot Front Calf Negative Flight Work      
Bar7 = bar3(DATA.Bounding{j}(1).FCFNW);
zz = get(Bar7,'Zdata');
zz = zz + DATA.Bounding{j}(1).FCFPW;
set(Bar7,'Zdata',zz);
set(Bar7,'FaceColor',[ 0.9686   0.4118    0]);
xx = get(Bar7,'Xdata');
xx = xx + 8;
set(Bar7,'Xdata',xx);
yy = get(Bar7,'Ydata');
yy = yy + 8 + m;
set(Bar7,'Ydata',yy);
hold on

% Plot Front Calf Positive Flight Work 
Bar8 = bar3(DATA.Bounding{j}(1).FCFPW);
set(Bar8,'FaceColor',[0.7500    0.7500    0.7500]);
xx = get(Bar8,'Xdata');
xx = xx + 8;
set(Bar8,'Xdata',xx);
yy = get(Bar8,'Ydata');
yy = yy + 8 + m;
set(Bar8,'Ydata',yy);
hold on
m = m + 1;
end
fa.Position = [(0.3*Inch_SS(3) + 0.25*0.7*Inch_SS(3)) Inch_SS(4)/2 0.25*0.7*Inch_SS(3) Inch_SS(4)/2];
grid on
hold on
title(['Front Thigh Work ( v = ',Velocity ,' m/s )'])
axis([0 10 -1 4 0 15]) % calves axis([0 10 7 12 0 40]) thighs axis([0 10 -1 4 0 40])
xticks([1  9])
xticklabels({'Stance','Swing'})
yticks([0 1 2 3 8 9 10 11])
yticklabels({'B0','B2','BG','BE','B0','B2','BG','BE'})
zlabel('Work  (J)');
view([40,40,20])
box on
lgd = legend('Negative Work','Positive Work');
lgd.Location = 'best';
a1 = gca;
fb = figure;
fb.Color = 'w';
fb.Units = 'inches';
fb.Position = [(0.3*Inch_SS(3) + 0.25*0.7*Inch_SS(3)) 0 0.25*0.7*Inch_SS(3) Inch_SS(4)/2];
a2 = copyobj(a1,fb);
title(['Front Calf Work ( v = ',Velocity ,' m/s )'])
axis([0 10 7 12 0 15])
view([40,40,20])
lgd = legend('Negative Work','Positive Work');
lgd.Location = 'best';
view([40,40,20])

%-------------------------BE
DATA.Bounding{3}(1).RTSPW =      DATA.Bounding{3}(5).PositiveWork(8)  +     DATA.Bounding{3}(3).PositiveWork(8);  % Front Thigh Stance Positive Work
DATA.Bounding{3}(1).RTSNW =  abs(DATA.Bounding{3}(5).NegativeWork(8)) + abs(DATA.Bounding{3}(3).NegativeWork(8)); % Front Thigh Stance Negative Work
DATA.Bounding{3}(1).RTFPW =      DATA.Bounding{3}(1).PositiveWork(8)  +     DATA.Bounding{3}(7).PositiveWork(8);  % Front Thigh Flight Positive Work
DATA.Bounding{3}(1).RTFNW =  abs(DATA.Bounding{3}(1).NegativeWork(8)) + abs(DATA.Bounding{3}(7).NegativeWork(8)); % Front Thigh Flight Negative Work

DATA.Bounding{3}(1).RCSPW =      DATA.Bounding{3}(5).PositiveWork(9)  +     DATA.Bounding{3}(3).PositiveWork(9);  % Front Calf Stance Positive Work
DATA.Bounding{3}(1).RCSNW =  abs(DATA.Bounding{3}(5).NegativeWork(9)) + abs(DATA.Bounding{3}(3).NegativeWork(9)); % Front Calf Stance Negative Work
DATA.Bounding{3}(1).RCFPW =      DATA.Bounding{3}(1).PositiveWork(9)  +     DATA.Bounding{3}(7).PositiveWork(9);  % Front Calf Flight Positive Work
DATA.Bounding{3}(1).RCFNW =  abs(DATA.Bounding{3}(1).NegativeWork(9)) + abs(DATA.Bounding{3}(7).NegativeWork(9)); % Front Calf Flight Negative Work   
%-------------------------BG
DATA.Bounding{2}(1).RTSPW =      DATA.Bounding{2}(3).PositiveWork(8)  +     DATA.Bounding{2}(1).PositiveWork(8);
DATA.Bounding{2}(1).RTSNW =  abs(DATA.Bounding{2}(3).NegativeWork(8)) + abs(DATA.Bounding{2}(1).NegativeWork(8));
DATA.Bounding{2}(1).RTFPW =      DATA.Bounding{2}(5).PositiveWork(8)  +     DATA.Bounding{2}(7).PositiveWork(8);
DATA.Bounding{2}(1).RTFNW =  abs(DATA.Bounding{2}(5).NegativeWork(8)) + abs(DATA.Bounding{2}(7).NegativeWork(8));

DATA.Bounding{2}(1).RCSPW =      DATA.Bounding{2}(3).PositiveWork(9)  +     DATA.Bounding{2}(1).PositiveWork(9);
DATA.Bounding{2}(1).RCSNW =  abs(DATA.Bounding{2}(3).NegativeWork(9)) + abs(DATA.Bounding{2}(1).NegativeWork(9));
DATA.Bounding{2}(1).RCFPW =      DATA.Bounding{2}(5).PositiveWork(9)  +     DATA.Bounding{2}(7).PositiveWork(9); 
DATA.Bounding{2}(1).RCFNW =  abs(DATA.Bounding{2}(5).NegativeWork(9)) + abs(DATA.Bounding{2}(7).NegativeWork(9));  
%-------------------------B2
DATA.Bounding{1}(1).RTSPW =       DATA.Bounding{1}(5).PositiveWork(8);
DATA.Bounding{1}(1).RTSNW =   abs(DATA.Bounding{1}(5).NegativeWork(8));
DATA.Bounding{1}(1).RTFPW =       DATA.Bounding{1}(1).PositiveWork(8)  +     DATA.Bounding{1}(3).PositiveWork(8)  +     DATA.Bounding{1}(7).PositiveWork(8);
DATA.Bounding{1}(1).RTFNW =   abs(DATA.Bounding{1}(1).NegativeWork(8)) + abs(DATA.Bounding{1}(3).NegativeWork(8)) + abs(DATA.Bounding{1}(7).NegativeWork(8));

DATA.Bounding{1}(1).RCSPW =       DATA.Bounding{1}(5).PositiveWork(9);
DATA.Bounding{1}(1).RCSNW =   abs(DATA.Bounding{1}(5).NegativeWork(9));
DATA.Bounding{1}(1).RCFPW =       DATA.Bounding{1}(1).PositiveWork(9)  +     DATA.Bounding{1}(3).PositiveWork(9)  +     DATA.Bounding{1}(7).PositiveWork(9);
DATA.Bounding{1}(1).RCFNW =   abs(DATA.Bounding{1}(1).NegativeWork(9)) + abs(DATA.Bounding{1}(3).NegativeWork(9)) + abs(DATA.Bounding{1}(7).NegativeWork(9));        
%-------------------------B0
DATA.Bounding{4}(1).RTSPW =      DATA.Bounding{4}(3).PositiveWork(8)  +     DATA.Bounding{4}(5).PositiveWork(8)  +     DATA.Bounding{4}(7).PositiveWork(8);
DATA.Bounding{4}(1).RTSNW =  abs(DATA.Bounding{4}(3).NegativeWork(8)) + abs(DATA.Bounding{4}(5).NegativeWork(8)) + abs(DATA.Bounding{4}(7).NegativeWork(8));
DATA.Bounding{4}(1).RTFPW =      DATA.Bounding{4}(1).PositiveWork(8)  ;
DATA.Bounding{4}(1).RTFNW =  abs(DATA.Bounding{4}(1).NegativeWork(8)) ;

DATA.Bounding{4}(1).RCSPW =      DATA.Bounding{4}(3).PositiveWork(9)  +     DATA.Bounding{4}(5).PositiveWork(9)  +     DATA.Bounding{4}(7).PositiveWork(9);
DATA.Bounding{4}(1).RCSNW =  abs(DATA.Bounding{4}(3).NegativeWork(9)) + abs(DATA.Bounding{4}(5).NegativeWork(9)) + abs(DATA.Bounding{4}(7).NegativeWork(9));
DATA.Bounding{4}(1).RCFPW =      DATA.Bounding{4}(1).PositiveWork(9)  ; 
DATA.Bounding{4}(1).RCFNW =  abs(DATA.Bounding{4}(1).NegativeWork(9)) ;    

% Plot Rear Thigh Negative Stance Work
fc = figure;
fc.Units = 'inches'; 
fc.Color = 'w';
m = 0;
for j = 1 : 4
if j == 4
    m = -1;
end
Bar1 = bar3(DATA.Bounding{j}(1).RTSNW);
hold on
zz = get(Bar1,'Zdata');
zz = zz + DATA.Bounding{j}(1).RTSPW;
set(Bar1,'Zdata',zz);
set(Bar1,'FaceColor',[ 0.9686   0.4118    0]);
yy = get(Bar1,'Ydata');
yy = yy + m;
set(Bar1,'Ydata',yy);
hold on

% Plot Rear Thigh Positive Stance Work      
Bar2 = bar3(DATA.Bounding{j}(1).RTSPW);
set(Bar2,'FaceColor',[0.7500    0.7500    0.7500]);
yy = get(Bar2,'Ydata');
yy = yy + m;
set(Bar2,'Ydata',yy);
hold on

% Plot Rear Thigh Negative Flight Work      
Bar3 = bar3(DATA.Bounding{j}(1).RTFNW);
zz = get(Bar3,'Zdata');
zz = zz + DATA.Bounding{j}(1).RTFPW;
set(Bar3,'Zdata',zz);
set(Bar3,'FaceColor',[ 0.9686   0.4118    0]);
xx = get(Bar3,'Xdata');
xx = xx + 8;
set(Bar3,'Xdata',xx);
yy = get(Bar3,'Ydata');
yy = yy + m;
set(Bar3,'Ydata',yy);
hold on

% Plot Rear Thigh Positive Flight Work 
Bar4 = bar3(DATA.Bounding{j}(1).RTFPW);
set(Bar4,'FaceColor',[0.7500    0.7500    0.7500]);
xx = get(Bar4,'Xdata');
xx = xx + 8;
set(Bar4,'Xdata',xx);
yy = get(Bar4,'Ydata');
yy = yy + m;
set(Bar4,'Ydata',yy);
hold on

% Plot Rear Calf Negative Stance Work
Bar5 = bar3(DATA.Bounding{j}(1).RCSNW);
hold on
zz = get(Bar5,'Zdata');
zz = zz + DATA.Bounding{j}(1).RCSPW;
set(Bar5,'Zdata',zz);
set(Bar5,'FaceColor',[ 0.9686   0.4118    0]);
yy = get(Bar5,'Ydata');
yy = yy + 8 + m;
set(Bar5,'Ydata',yy);
hold on

% Plot Rear Calf Positive Stance Work      
Bar6 = bar3(DATA.Bounding{j}(1).RCSPW);
set(Bar6,'FaceColor',[0.7500    0.7500    0.7500]);
yy = get(Bar6,'Ydata');
yy = yy + 8 + m;
set(Bar6,'Ydata',yy);
hold on

% Plot Rear Calf Negative Flight Work      
Bar7 = bar3(DATA.Bounding{j}(1).RCFNW);
zz = get(Bar7,'Zdata');
zz = zz + DATA.Bounding{j}(1).RCFPW;
set(Bar7,'Zdata',zz);
set(Bar7,'FaceColor',[ 0.9686   0.4118    0]);
xx = get(Bar7,'Xdata');
xx = xx + 8;
set(Bar7,'Xdata',xx);
yy = get(Bar7,'Ydata');
yy = yy + 8 + m;
set(Bar7,'Ydata',yy);
hold on

% Plot Rear Calf Positive Flight Work 
Bar8 = bar3(DATA.Bounding{j}(1).RCFPW);
set(Bar8,'FaceColor',[0.7500    0.7500    0.7500]);
xx = get(Bar8,'Xdata');
xx = xx + 8;
set(Bar8,'Xdata',xx);
yy = get(Bar8,'Ydata');
yy = yy + 8 + m;
set(Bar8,'Ydata',yy);
hold on
m = m + 1;
end
fc.Position = [0.3*Inch_SS(3) Inch_SS(4)/2 0.25*0.7*Inch_SS(3) Inch_SS(4)/2];
grid on
hold on
title(['Rear Thigh Work ( v = ',Velocity ,' m/s )'])
axis([0 10 -1 4 0 15]) % calves axis([0 10 7 12 0 40]) thighs axis([0 10 -1 4 0 40])
xticks([1  9])
xticklabels({'Stance','Swing'})
yticks([0 1 2 3 8 9 10 11])
yticklabels({'B0','B2','BG','BE','B0','B2','BG','BE'})
zlabel('Work  (J)');
view([40,40,20])
box on
lgd = legend('Negative Work','Positive Work');
lgd.Location = 'best';
a1 = gca;
fd = figure;
fd.Color = 'w';
fd.Units = 'inches';
fd.Position = [0.3*Inch_SS(3) 0 0.25*0.7*Inch_SS(3) Inch_SS(4)/2];
a2 = copyobj(a1,fd);
title(['Rear Calf Work ( v = ',Velocity ,' m/s )'])
axis([0 10 7 12 0 15])
view([40,40,20])
lgd = legend('Negative Work','Positive Work');
lgd.Location = 'best';
view([40,40,20])

%% 4- Plot COT with Varying COM
load('GaitLibrary_BE_f10.mat')
BEf10 = BE;
clear BE
load('GaitLibrary_BE_f20.mat')
BEf20 = BE;
clear BE
load('GaitLibrary_BE_b10.mat')
BEb10 = BE;
clear BE
load('GaitLibrary_BE_b20.mat')
BEb20 = BE;
clear BE
BE = BoundingBE;
load('GaitLibrary_BG_f10.mat')
BGf10 = BG;
clear BG
load('GaitLibrary_BG_f20.mat')
BGf20 = BG;
clear BG
load('GaitLibrary_BG_b10.mat')
BGb10 = BG;
clear BG
load('GaitLibrary_BG_b20.mat')
BGb20 = BG;
clear BG
BG = BoundingBG;
load('GaitLibrary_B2_f10.mat')
B2f10 = B2;
clear B2
load('GaitLibrary_B2_f20.mat')
B2f20 = B2;
clear B2
load('GaitLibrary_B2_b10.mat')
B2b10 = B2;
clear B2
load('GaitLibrary_B2_b20.mat')
B2b20 = B2;
clear B2
B2 = BoundingB2;
load('GaitLibrary_B0_f10.mat')
B0f10 = B0;
clear B0
load('GaitLibrary_B0_f20.mat')
B0f20 = B0;
clear B0
load('GaitLibrary_B0_b10.mat')
B0b10 = B0;
clear B0
load('GaitLibrary_B0_b20.mat')
B0b20 = B0;
clear B0
B0 = BoundingB0;

 Vector_BEf10 = zeros(length(BEf10.V),1); % No. of data
 Vector_BEf20 = zeros(length(BEf20.V),1); % No. of data
 Vector_BEb10 = zeros(length(BEb10.V),1); % No. of data
 Vector_BEb20 = zeros(length(BEb20.V),1); % No. of data
    Vector_BE = zeros(length(BE.V),1); % No. of data
 Vector_BGf10 = zeros(length(BGf10.V),1); % No. of data
 Vector_BGf20 = zeros(length(BGf20.V),1); % No. of data
 Vector_BGb10 = zeros(length(BGb10.V),1); % No. of data
 Vector_BGb20 = zeros(length(BGb20.V),1); % No. of data
    Vector_BG = zeros(length(BG.V),1); % No. of data
 Vector_B2f10 = zeros(length(B2f10.V),1); % No. of data
 Vector_B2f20 = zeros(length(B2f20.V),1); % No. of data
 Vector_B2b10 = zeros(length(B2b10.V),1); % No. of data
 Vector_B2b20 = zeros(length(B2b20.V),1); % No. of data
    Vector_B2 = zeros(length(B2.V),1); % No. of data
 Vector_B0f10 = zeros(length(B0f10.V),1); % No. of data
 Vector_B0f20 = zeros(length(B0f20.V),1); % No. of data
 Vector_B0b10 = zeros(length(B0b10.V),1); % No. of data
 Vector_B0b20 = zeros(length(B0b20.V),1); % No. of data
    Vector_B0 = zeros(length(B0.V),1); % No. of data 
      
vBEf10 = BEf10.V{1}.Velocity : 0.1 : BEf10.V{end}.Velocity; 
  for k = 1:length(BEf10.V) % No. of data             
    Vector_BEf10(k,1) = BEf10.V{k}.CostValue;
  end

vBEf20 = BEf20.V{1}.Velocity : 0.1 : BEf20.V{end}.Velocity;  
  for k = 1:length(BEf20.V) % No. of data             
    Vector_BEf20(k,1) = BEf20.V{k}.CostValue;
  end

vBEb10 = BEb10.V{1}.Velocity : 0.1 : BEb10.V{end}.Velocity;   
  for k = 1:length(BEb10.V) % No. of data             
    Vector_BEb10(k,1) = BEb10.V{k}.CostValue;
  end
  
vBEb20 = BEb20.V{1}.Velocity : 0.1 : BEb20.V{end}.Velocity; %+0.1;   
  for k = 1:length(BEb20.V) % No. of data             
    Vector_BEb20(k,1) = BEb20.V{k}.CostValue;
  end
  
vBE = BE.V{1}.Velocity : 0.1 : BE.V{end}.Velocity;   
  for k = 1:length(BE.V) % No. of data             
    Vector_BE(k,1) = BE.V{k}.CostValue;
  end
 
mycolors =  parula(5);
f = figure;
f.Units = 'inches'; 
f.Color = 'w';
f.Position = [(0.3*Inch_SS(3) + 0.25*0.7*Inch_SS(3) + 0.25*0.7*Inch_SS(3)) Inch_SS(4)/2 0.27*0.7*Inch_SS(3) Inch_SS(4)/2];
plot(vBEb20,Vector_BEb20,'Color',mycolors(1,:),'linewidth',2);
hold on 
plot(vBEb10,Vector_BEb10,'Color',mycolors(2,:),'linewidth',2);
hold on 
plot(vBE,Vector_BE,'-.','Color',mycolors(3,:),'linewidth',2);
hold on 
plot(vBEf10,Vector_BEf10,'Color',mycolors(4,:),'linewidth',2);
hold on 
plot(vBEf20,Vector_BEf20,'Color',mycolors(5,:),'linewidth',2);
grid on
title('(BE)')
xlabel('Average Velocity  (m/s)' )
ylabel('COT' )
xlim([0 5]);
ylim([0 1.5]);
legend('-0.2 m','-0.1 m','Original','+0.1 m','+0.2 m')     
colormap(mycolors);
CB = colorbar('Ticks',[-0.2,-0.1,0,0.1,0.2]);
CB.Units = 'inches';
caxis([-0.2 0.2]);
  
vBGf10 = BGf10.V{1}.Velocity : 0.1 : BGf10.V{end}.Velocity; 
  for k = 1:length(BGf10.V) % No. of data             
    Vector_BGf10(k,1) = BGf10.V{k}.CostValue;
  end

vBGf20 = BGf20.V{1}.Velocity : 0.1 : BGf20.V{end}.Velocity;  
  for k = 1:length(BGf20.V) % No. of data             
    Vector_BGf20(k,1) = BGf20.V{k}.CostValue;
  end

vBGb10 = BGb10.V{1}.Velocity : 0.1 : BGb10.V{end}.Velocity;   
  for k = 1:length(BGb10.V) % No. of data             
    Vector_BGb10(k,1) = BGb10.V{k}.CostValue;
  end
  
vBGb20 = BGb20.V{1}.Velocity : 0.1 : BGb20.V{end}.Velocity; %+0.1;   
  for k = 1:length(BGb20.V) % No. of data             
    Vector_BGb20(k,1) = BGb20.V{k}.CostValue;
  end
  
vBG = BG.V{1}.Velocity : 0.1 : BG.V{end}.Velocity;   
  for k = 1:length(BG.V) % No. of data             
    Vector_BG(k,1) = BG.V{k}.CostValue;
  end
 
f = figure;
f.Units = 'inches'; 
f.Color = 'w';
f.Position = [(0.3*Inch_SS(3) + 0.25*0.7*Inch_SS(3) + 0.25*0.7*Inch_SS(3) + 0.27*0.7*Inch_SS(3)) Inch_SS(4)/2 0.27*0.7*Inch_SS(3) Inch_SS(4)/2];
plot(vBGb20,Vector_BGb20,'Color',mycolors(1,:),'linewidth',2);
hold on 
plot(vBGb10,Vector_BGb10,'Color',mycolors(2,:),'linewidth',2);
hold on 
plot(vBG,Vector_BG,'-.','Color',mycolors(3,:),'linewidth',2);
hold on 
plot(vBGf10,Vector_BGf10,'Color',mycolors(4,:),'linewidth',2);
hold on 
plot(vBGf20,Vector_BGf20,'Color',mycolors(5,:),'linewidth',2);
grid on
title('(BG)')
xlabel('Average Velocity  (m/s)' )
ylabel('COT' )
xlim([0 5]);
ylim([0 1.5]);
legend('-0.2 m','-0.1 m','Original','+0.1 m','+0.2 m')     
colormap(mycolors);
CB = colorbar('Ticks',[-0.2,-0.1,0,0.1,0.2]);
CB.Units = 'inches';
caxis([-0.2 0.2]);
  
vB2f10 = B2f10.V{1}.Velocity : 0.1 : B2f10.V{end}.Velocity; 
  for k = 1:length(B2f10.V) % No. of data             
    Vector_B2f10(k,1) = B2f10.V{k}.CostValue;
  end

vB2f20 = B2f20.V{1}.Velocity : 0.1 : B2f20.V{end}.Velocity;  
  for k = 1:length(B2f20.V) % No. of data             
    Vector_B2f20(k,1) = B2f20.V{k}.CostValue;
  end

vB2b10 = B2b10.V{1}.Velocity : 0.1 : B2b10.V{end}.Velocity;   
  for k = 1:length(B2b10.V) % No. of data             
    Vector_B2b10(k,1) = B2b10.V{k}.CostValue;
  end
  
vB2b20 = B2b20.V{1}.Velocity : 0.1 : B2b20.V{end}.Velocity + 0.1;   
  for k = 1:length(B2b20.V) % No. of data             
    Vector_B2b20(k,1) = B2b20.V{k}.CostValue;
  end
  
vB2 = B2.V{1}.Velocity : 0.1 : B2.V{end}.Velocity;   
  for k = 1:length(B2.V) % No. of data             
    Vector_B2(k,1) = B2.V{k}.CostValue;
  end
 
f = figure;
f.Units = 'inches'; 
f.Color = 'w';
f.Position = [(0.3*Inch_SS(3) + 0.25*0.7*Inch_SS(3) + 0.25*0.7*Inch_SS(3)) 0 0.27*0.7*Inch_SS(3) Inch_SS(4)/2];
plot(vB2b20,Vector_B2b20,'Color',mycolors(1,:),'linewidth',2);
hold on 
plot(vB2b10,Vector_B2b10,'Color',mycolors(2,:),'linewidth',2);
hold on 
plot(vB2,Vector_B2,'-.','Color',mycolors(3,:),'linewidth',2);
hold on 
plot(vB2f10,Vector_B2f10,'Color',mycolors(4,:),'linewidth',2);
hold on 
plot(vB2f20,Vector_B2f20,'Color',mycolors(5,:),'linewidth',2);
grid on
title('(B2)')
xlabel('Average Velocity  (m/s)' )
ylabel('COT' )
xlim([0 5]);
ylim([0 1.5]);
legend('-0.2 m','-0.1 m','Original','+0.1 m','+0.2 m')     
colormap(mycolors);
CB = colorbar('Ticks',[-0.2,-0.1,0,0.1,0.2]);
CB.Units = 'inches';
caxis([-0.2 0.2]);
   
vB0f10 = B0f10.V{1}.Velocity : 0.1 : B0f10.V{end}.Velocity; 
  for k = 1:length(B0f10.V) % No. of data             
    Vector_B0f10(k,1) = B0f10.V{k}.CostValue;
  end

vB0f20 = B0f20.V{1}.Velocity : 0.1 : B0f20.V{end}.Velocity;  
  for k = 1:length(B0f20.V) % No. of data             
    Vector_B0f20(k,1) = B0f20.V{k}.CostValue;
  end

vB0b10 = B0b10.V{1}.Velocity : 0.1 : B0b10.V{end}.Velocity;   
  for k = 1:length(B0b10.V) % No. of data             
    Vector_B0b10(k,1) = B0b10.V{k}.CostValue;
  end
  
vB0b20 = B0b20.V{1}.Velocity : 0.1 : B0b20.V{end}.Velocity; %+0.1;   
  for k = 1:length(B0b20.V) % No. of data             
    Vector_B0b20(k,1) = B0b20.V{k}.CostValue;
  end
  
vB0 = B0.V{1}.Velocity : 0.1 : B0.V{end}.Velocity;   
  for k = 1:length(B0.V) % No. of data             
    Vector_B0(k,1) = B0.V{k}.CostValue;
  end
 
f = figure;
f.Units = 'inches'; 
f.Color = 'w';
f.Position = [(0.3*Inch_SS(3) + 0.25*0.7*Inch_SS(3) + 0.25*0.7*Inch_SS(3) + 0.27*0.7*Inch_SS(3)) 0 0.27*0.7*Inch_SS(3) Inch_SS(4)/2];
plot(vB0b20,Vector_B0b20,'Color',mycolors(1,:),'linewidth',2);
hold on 
plot(vB0b10,Vector_B0b10,'Color',mycolors(2,:),'linewidth',2);
hold on 
plot(vB0,Vector_B0,'-.','Color',mycolors(3,:),'linewidth',2);
hold on 
plot(vB0f10,Vector_B0f10,'Color',mycolors(4,:),'linewidth',2);
hold on 
plot(vB0f20,Vector_B0f20,'Color',mycolors(5,:),'linewidth',2);
grid on
title('(B0)')
xlabel('Average Velocity  (m/s)' )
ylabel('COT' )
xlim([0 5]);
ylim([0 1.5]);
legend('-0.2 m','-0.1 m','Original','+0.1 m','+0.2 m')     
colormap(mycolors);
CB = colorbar('Ticks',[-0.2,-0.1,0,0.1,0.2]);
CB.Units = 'inches';
caxis([-0.2 0.2]);
 