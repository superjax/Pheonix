function [xopt, fopt, exitflag] = optimize()
%% Optimize Function

% structure of x
    % alpha_1 - angle with respect to north of radio i
    % alpha_2
    % alpha_3
    % N - number of radios
    
    %% starting point and bounds
    x0 = [0;...
          pi()/4;...
          pi();...
          3];
      
    ub = [2*pi();
          2*pi();
          2*pi();
          3];
      
    lb = [0;...
          0;...
          0;...
          3];
    
    %% Function Counter
    global calls
    calls = 0;

    %% linear constraints
    A = [];
    b = [];
    Aeq = [];
    beq = [];

    %% common variables
    persistent x_last
    x_last = zeros(1,4);
    global x_history;
    x_history = zeros(1,4);
    global c_history;
    c_history = zeros(1,4);
    
    %% initialize
    global P
    P.Phi = pi()/3;
    P.Dmax = 200;
    global dataset
    dataset = loaddataset('points.csv');

    %% optimize
    options = gaoptimset(...
        'Display','iter',...
        'Generations',50,...
        'PopulationSize',50);
    
    [xopt, fopt, exitflag] = ga(@obj, 4, A, b, Aeq, beq, lb, ub, @con,options);
    
    alpha = xopt(1:3);
    N = 1;
    plotResult(xopt);
    
    
    calls

    %% Objective Function
    function [J, g] = obj(x)
        x_last=x;
        x_history = [x_history;x];
        J = -radioPlace(x);
    end

    %% Constraints
    function [c, ceq, gc, gceq] = con(x)
        c = [];
        ceq = [];
        gc = [];
        gceq = [];        
    end
end

