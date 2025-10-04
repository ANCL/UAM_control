function R_ZYX = RotZYX(phi,theta,psi)
%ROTZYX by Muhammad Awais Rafique
%   Detailed explanation goes here
R_ZYX = rotz(psi)*roty(theta)*rotx(phi);
end

