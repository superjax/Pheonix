% Gradient Free Optimization - ME 575
% Caleb Lystrup
clc; clear; close all; format compact;

% Understand, basically, the constraints of your function. Define a region
% to start from for the genetic optimizer. In you test function case, you
% know that the solution will be at about (0,0).

% ------------------------------ %
% 5.2 Custom Genetic Algorithm
% ------------------------------ %

%% Initialize a Population
  
Deg = 10;        % Dimensionality or number of input variables
Pop = 20*Deg;   % Population size, needs to be even 
S = 20;         % "Radial" Range of randomization spread
X = 2*S*(0.5-rand(Pop,Deg)); % Binary representation is not necessary

%% Determine Mating Pool
% This is how you shuffle your population: X(randperm(length(X)),:)

% Initialize tournament
victors = zeros(Pop,Deg); % Needs to happen outside of the main loop

% Initialize mating and mutation
HF = 0.5;      % Hybrid factor. Percent to which one offspring mimics superior parent
M = 0.0001;    % Degree of mutation.

% Initialize fitness
F = ones(Pop,1);
best = 10; % Start at 10 for initial guess

% Initialize stop variable
global rep
rep = 1;

% Define convergence criteria
conv = 1e-3;

% Define function counter
global fcount
fcount = 0;

%% Create a Contour Plot
n = 100;
x = linspace(-20, 20, n);
y = linspace(-20, 20, n);
[contourX, contourY] = meshgrid(x, y);
contourF = zeros(n, n);
for i = 1:n
    for j = 1:n
        contourF(i, j) = func([contourX(i, j); contourY(i, j)]);
    end
end

figure; hold on;
contourf(contourX, contourY, contourF, 100, 'LineStyle', 'none');
for i = 1:Pop
    plot(X(i, 1), X(i, 2), 'ro');
end

% Generation Looper
while rep < 3 % This is related to convergence

    %if one violates constraint, other wins
    %if both violate, better wins
    %if none violate, better wins
    
% Tournament 1
for i = 1:2:Pop
    knightA = func(X(i,:));
    knightB = func(X(i+1,:));
    if knightA < knightB
        victors(i,:) = (X(i,:));
    else
        victors(i,:) = (X(i+1,:));
    end
end

% Shuffle X for next tournament
X = X(randperm(Pop),:);

% Tournament 2
for i = 1:2:Pop
    knightA = func(X(i,:));
    knightB = func(X(i+1,:));
    if knightA < knightB
        victors(i+1,:) = (X(i,:)); % Need to move to the 'i+1' for next set of victors
    else
        victors(i+1,:) = (X(i+1,:));
    end
end

%% Generate Offspring

% Shuffle X for mating
X = victors(randperm(Pop),:);

for i = 1:2:Pop
    if func(X(i,:)) < func(X(i+1,:))
        X(i+1,:) = HF*X(i,:)+(1-HF)*X(i+1,:); % Take average 4 lesser offspring
    else
        X(i,:) = HF*X(i,:)+(1-HF)*X(i+1,:);
    end
end

%% Mutation

Mutate = M*(rand(Pop,Deg)-rand(Pop,Deg)); % Generates random micro array
X = Mutate+X;

%% Compute Offspring's Fitness

% Define Offspring's Constraint Violations Here:

% Define replacement for constraint violation:

% Fitness of non-violaters AND replacements:
for i = 1:Pop
    F(i) = func(X(i,:));
end

%% Identify the Best Member
newbest = min(F);
k = find(F==newbest);
optimum = X(k,:);

if abs(best-newbest) < conv
    rep = rep+1;
else
    rep = 1;
end
best = newbest;
newbest

%% Replace Weakest Members
worst = max(F);
kbad = find(F==worst);
X(k,:) = 2*S*(0.5-rand(1,Deg));

%% Return to Step 2

clf; hold on;
contourf(contourX, contourY, contourF, 100, 'LineStyle', 'none');
for i = 1:Pop
    plot(X(i, 1), X(i, 2), 'ro');
end
shg

end

newbest
optimum
fcount