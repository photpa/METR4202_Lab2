function cup_type = calc_cup_type(cup_depths, bbox)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
% small cup 60mm tall diameter base 45mm top 63mm
% medium cup 92mm tall diameter base 55mm top 79mm
% big cup 105mm tall diameter base 62mm top 87mm 
%at 952mm small cup is 58 pixels wide 72 pixels high
    view_angleW = 57;
    view_angleH = 43;
    cup_widths = [];
    cup_heights = [];
    for n = [1:size(bbox,1)]
       wtemp = bbox(n,3)/(1280/2)*cup_depths(n)*tand(view_angleW/2);
       cup_widths = vertcat(cup_widths, wtemp);
       htemp = bbox(n,4)/(960/2)*cup_depths(n)*tand(view_angleH/2);
       cup_heights = vertcat(cup_heights, htemp);
    end
    cup_type = []; %NaN(size(cup_heights,1),1);
    cup_heights
    cup_widths
%     for n = [1:size(cup_widths,1)]
%         if cup_widths(n) < 55
%             cup_type = vertcat(cup_type, 0);
%         elseif cup_widths(n) >= 55 & cup_widths(n) < 70
%             cup_type = vertcat(cup_type, 1);
%         elseif cup_widths(n) >= 70
%             cup_type = vertcat(cup_type, 2);
%         end
%     end
    for n = [1:size(cup_heights,1)]
        if cup_heights(n) <= 58
            cup_type = vertcat(cup_type, 0);
        elseif cup_heights(n) > 58 & cup_heights(n) < 78
            cup_type = vertcat(cup_type, 1);
        elseif cup_heights(n) > 78
            cup_type = vertcat(cup_type, 2);
        end
    end
end

