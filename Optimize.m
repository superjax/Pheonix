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

    %% common history variables
    persistent x_last;
    global x_history;
    x_history = zeros(1,4);
    global c_history;
    c_history = zeros(1,4);
    
    %% optimize
    
    [xopt, fopt, exitflag] = PSGO(@obj, x0, population_size, max_iter, lb,ub);
    
    calls

end

%% PSO Optimizer
function [xopt, fopt, exitflag, output] = PSGO(obj_function, x0, population_size, max_iter, lb, ub)
% PSGO Particle Swarm Genetic Optimization
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

% the individual contains values for all 12 microhubs
% structure for each hub is [x; y; alpha1; alpha2; alpha3; bool1; bool2; bool3]
individual = zeros(6,12); 

% the population contains an array of individuals
population = cell(population_size,1);
for i = 1:population_size
    population(i) = {individual};
end

% initialize values
% \todo this should not be dividing up a rectangle
for i = 1:population_size % iterate through individuals
	for j = 1:12 % iterate through microhubs
        % split up the area into a number of zones.  Spread out the
        % microhubs across the zones
        if (ub(1) - lb(1)) > (ub(2) - lb(2)) % longer in the x-direction, put 4 in that direction
            x_chunk = (ub(1)-lb(1))/4;
            y_chunk = (ub(2)-lb(2))/3;
            if(j < 5) % first row
                population{i,1}(j,1) = rand()*x_chunk+(j-1)*x_chunk+lb(1);
                population{i,1}(j,2) = rand()*y_chunk+lb(2);
            else if(j < 9) % second row
                population{i,1}(j,1) = rand()*x_chunk + (j-5)*y_chunk + lb(1);
                population{i,1}(j,2) = rand()*y_chunk + y_chunk + lb(2);
            else % last row
                population{i,1}(j,1) = rand()*x_chunk + (j-9)*y_chunk + lb(1);
                population{i,1}(j,2) = rand()*y_chunk + 2*y_chunk + lb(2);
                end
            end
        else % longer in the y-direction, put 4 that way
            x_chunk = (ub(1)-lb(1))/3;
            y_chunk = (ub(2)-lb(2))/4;
            if(j < 4) % first row
                population{i,1}(j,1) = rand()*x_chunk+(j-1)*x_chunk+lb(1);
                population{i,1}(j,2) = rand()*y_chunk+lb(2);
            else if (j < 7)
                population{i,1}(j,1) = rand()*x_chunk + (j-4)*y_chunk + lb(1);
                population{i,1}(j,2) = rand()*y_chunk + y_chunk + lb(2);
            else if(j < 9)
                population{i,1}(j,1) = rand()*x_chunk + (j-7)*y_chunk + lb(1);
                population{i,1}(j,2) = rand()*y_chunk + 2*y_chunk + lb(2);
            else
                population{i,1}(j,1) = rand()*x_chunk + (j-7)*y_chunk + lb(1);
                population{i,1}(j,2) = rand()*y_chunk + 3*y_chunk + lb(2);
                end
                end
            end
        end
    end        
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