function metric_coords = metric_space(cup_centres, cup_depths)
% Convert pixel coordinates to metric coordinates.
% ------------------------------------------------------------------------
% Inputs:
%   cup_centres: coordinates of cup centres
%   cup_depths: cup depth values
% Outputs:
%   metric_coords: array of metric coordinates mapped from original pixel
%   values
    % Initialisation
    view_angleW = 57;
    view_angleH = 43;
    metX_coord = [];
    metY_coord = [];
    metZ_coord = [];
    % Concatenate metric X and Y coordinates to metric_coords array
    for n = [1:size(cup_centres,1)]
       wtemp = double((cup_centres(n,1)-640)/(1280/2)*cup_depths(n)*tand(view_angleW/2));
       metX_coord = vertcat(metX_coord, wtemp);
       htemp = double((cup_centres(n,2)-480)/(960/2)*cup_depths(n)*tand(view_angleH/2));
       metY_coord = vertcat(metY_coord, htemp);
       
       deptemp = double(cup_depths(n));
       metZtemp = ((deptemp^2-wtemp^2-htemp^2));
       metZtemp = double(metZtemp)^0.5;
       
       metZ_coord = vertcat(metZ_coord, metZtemp);
    end
    metric_coords = horzcat(metX_coord, metY_coord, metZ_coord);
end

