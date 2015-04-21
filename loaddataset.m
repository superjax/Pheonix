function [ dataset ] = loaddataset(filename)

DATA = load(filename);

[THETA,RHO] = cart2pol(DATA(:,1)-DATA(1,1)*ones(length(DATA),1),DATA(:,2)-DATA(1,2)*ones(length(DATA),1));

for i = 1:length(DATA)
    housenode.rho = RHO(i);
    housenode.theta = mod(THETA(i)+2*pi(),2*pi());
    Test(i) = mod(THETA(i)+2*pi(),2*pi());
    housenode.d = housenode.rho; % this could eventually be the radio adjusted distance   
    dataset.housenode(i) = housenode;
end
dataset.m = length(DATA);

end

