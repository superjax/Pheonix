mirco = Home;
micro.x = 0;
micro.y = 0;

home1 = Home;
home1.x = 20;
home1.y = 20;

home4 = Home;
home4.x = 20;
home4.y = -20;

home3 = Home;
home3.x = -20;
home3.y = -20;

home2 = Home;
home2.x = -20;
home2.y = 20;
signalStrength(micro,home, 20);

pointsWithin(micro, 100, pi(), pi() / 2, [home1, home2, home3, home4])