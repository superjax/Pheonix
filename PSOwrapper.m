function [xopt,fopt,exitflag,output] = PSOwrapper()
    %% starting point and bounds
    x0 = [1.2;.2;3;3];
    ub = [3;.7;7;7];
    lb = [0.2;0.02;0;0];
    population_size = 50;
    max_iter = 100;
    
    %% Function Counter
    global calls
    calls = 0;

    %% common variables
    persistent x_last;
    global x_history;
    x_history = zeros(1,4);
    global c_history;
    c_history = zeros(1,4);
    
    %% optimize
    
    [xopt, fopt, exitflag] = PSO(@obj, x0, population_size, max_iter, lb,ub);
    
    calls

end


%% PSO Optimizer
function [xopt, fopt, exitflag, output] = PSO(obj_function, x0, population_size, max_iter, lb, ub)
% PSO Particle Swarm Optimization
%   x0 initial input (to get size of variable)
%   obj_function function handle to optimize
%   population_size number of individuals in swarm
%   lb lower bound (array)
%   ub upper bound (array)


%% Debug Output
fcn_calls = 0;
output_to_screen = 1;
if output_to_screen
    disp('================James Jackson PSO Algorithm================');
    disp('Using Population Size ');
    disp(population_size);
    disp('  ');
    disp(['    ', 'iter', '     ', 'f_call','     ','f_best','    ', 'last_up']);
end

%% Initialize Population
% give initial values
% x is the whole population
	% rows = state
	% column = individual
x = zeros(length(x0),population_size);
v = zeros(size(x));
for j = 1:population_size
	for i = 1:length(x0)
		 x(i, j) = lb(i)+(ub(i)-lb(i))*rand();
         v(i, j) = 0.5-rand();
	end
end
% initialize parameters
individual_memory = x;
individual_best = zeros(1,population_size);
for i = 1:population_size
    individual_best(i) = obj(x(:,i));
    fcn_calls = fcn_calls + 1;
end
[global_best, i] = min(individual_best);
global_memory = x(:,i);
w = 1.0;
c1 = 1.8;
c2 = 1.1;

iteration_count = 1;
last_global_update = 0;


while iteration_count < max_iter && last_global_update < 5
    %% output to screen
    if output_to_screen
        disp([iteration_count,fcn_calls,global_best,last_global_update]);
    end
    
    iteration_count = iteration_count + 1;
    %% update
    for i = 1:population_size
        v(:,i) = w*v(:,i) + c1*rand()*(individual_memory(:,i)-x(:,i)) + c2*rand()*(global_memory - x(:,i));
    end
    x = x + v;
    % check bounds
    for i=1:population_size
        for j=1:length(x0)
            if x(j,i) < lb(j)
                x(j,i) = lb(j);
            end
            if x(j,i) > ub(j)
                x(j,i) = ub(j);
            end
        end
    end

    %% evaluate
    evaluation = zeros(population_size,1);
    for i = 1:population_size
        evaluation(i) = obj_function(x(:,i));
        fcn_calls = fcn_calls + 1;
    end

    %% update memory
    % individual memory
    for i = 1:population_size
        if evaluation(i) < individual_best(i)
            individual_best(i) = evaluation(i);
            individual_memory(:,i) = x(:,i);
        end
    end
    % global memory
    if min(individual_best) < global_best
        [global_best, i] = min(individual_best);
        global_memory = x(:,i);
        last_global_update = 0;
    else
        last_global_update = last_global_update + 1;
    end


end

xopt = global_memory;
fopt = global_best;
exitflag = 1;
output.iterations = iteration_count;

end

%% Objective Function
function [J, g] = obj(x)
    global x_history c_history y P
    x_last=x;
    x_history = [x_history;x'];
    t = run_model(x);
    c = [y.hdot_final-4.5;-4.5-y.hdot_final;...  % ensure reasonable approach speed
         y.phi_final-185*pi()/180; 175*pi()/180-y.phi_final];
    c_history = [c_history;[c']];
    for i = 1:length(c)
        if c(i) <= 0
            c(i) = 0;
        end
    end
    J = t + [10,10,10,10]*c;  % linear penalty constraint method
end
























