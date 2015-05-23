classdef Home
    %HOME Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        x;
        y;
        z;
        conversionRate;
        baselineAttritionRate;
    end
    
    methods
        function r = value(signalStrength)
           r = 10 + signalStrength; 
        end
    end
    
end

