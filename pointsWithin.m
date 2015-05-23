% 
function H = pointsWithin(source, distance, alpha, halfAngle, arrayOfPoints)
    mask = arrayfun(@(h) isWithin(source, h, distance, alpha, halfAngle) , arrayOfPoints);
    H = arrayOfPoints(mask);
end

function r = isWithin(source, target, distance, alpha, beta)
    [theta,rho] = cart2pol(target.x - source.x, target.y - source.y);
    r = rho < distance && mod(abs(theta-alpha), 2*pi()) <= beta;
end

