function r = signalStrength(microhub, house, angleFromBore)
    distance = norm([microhub.x, microhub.y] - [house.x, house.y]);
    r = distance + abs(angleFromBore);
end