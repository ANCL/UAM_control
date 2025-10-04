function [R_theta] = roty(theta)
%ROTY by Muhammad Awais Rafique
%   Detailed explanation goes here
R_theta=[cos(theta),0,sin(theta);0,1,0;-sin(theta),0,cos(theta)];
end

