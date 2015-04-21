function [ output ] = radioPlace(x)
% structure of x
    % alpha_1 - angle with respect to north of radio i
    % alpha_2
    % alpha_3
    % N - number of radios
    global dataset
    global P
    Phi = P.Phi;
    Dmax = P.Dmax;
    m = dataset.m;
    
    alpha = x(1:3);
    n = ceil(x(4));
    vec = zeros(m,1);
    sumRadio = 0;
    for j = 1:n
        for i=2:m
            if(abs(dataset.housenode(i).theta-alpha(j)) <= Phi/2 &&...
               dataset.housenode(i).d < Dmax && ...
               sumRadio <= 1000 &&...
               vec(i) < 1)
           vec(i) = 1;
           sumRadio = sumRadio +1;
            end
        end
        sumRadio = 0;
    end
    output = sum(vec);
    
    
%     theta = zeros(dataset.m,1);
%     rho = zeros(dataset.m,1);
%     for i = 1:dataset.m    
%        theta(i) = dataset.housenode(i).theta;
%        rho(i) = dataset.housenode(i).rho;
%     end
%     thetacap = zeros(dataset.m,1);
%     rhocap = zeros(dataset.m,1);
%     for i = 1:dataset.m
%         if vec(i) == 1
%             thetacap(i) = dataset.housenode(i).theta;
%             rhocap(i) = dataset.housenode(i).rho;
%         end
%     end
%     
%     figure(1)
%     clf
%     hold on
%     polar(theta,rho,'.b');
%     polar(thetacap,rhocap,'.g');
%     polar([alpha(1);,0],[1000;0],'-r');
%     polar([alpha(2);,0],[1000;0],'-r');
%     polar([alpha(3);,0],[1000;0],'-r');
%     hold off
            


end

