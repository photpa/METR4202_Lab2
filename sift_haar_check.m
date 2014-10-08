function [real_cups, bbox_checked] = sift_haar_check(cup_centresPixel, bbox)
% Compare sift points and haar features in a scene to check for accurate
% location of objects.
% ------------------------------------------------------------------------
% Inputs:
%   cup_centresPixel: pixel coordinate of cup centre
%   bbox: an M-by-4 matrix specifying the upper-left corner and size of
%       a bounding box (y,x,height,width)
% Outputs:
%   [real_cups, bbox_checked]: output array containing confirmed locations
%   of cups and the bbox matrices of the detected objects

    checked = []; %haarcheck
    real_cups_check = []; %sift check
    for bb = [1:size(bbox,1)]
        temp_cups = [];
        for pp = [1:size(cup_centresPixel,1)]
            % Check for matches with cup centres and bbox coordinates
            if (bbox(bb,1) <= cup_centresPixel(pp,1)) &...
                    (cup_centresPixel(pp,1) <= bbox(bb,1)+bbox(bb,3))
                if (bbox(bb,2) <= cup_centresPixel(pp,2)) &...
                        (cup_centresPixel(pp,2) <= bbox(bb,2)+bbox(bb,4))
                    checked = vertcat(checked, bb);
                    temp_cups = vertcat(temp_cups, pp);
                end
            end        
        end
            real_cups_check = vertcat(real_cups_check, mean(temp_cups));
    end
    bbox_checked = NaN(size(checked,1),4);
    real_cups = NaN(size(real_cups_check,1),2);
    % Concantenate matched coordinates to output array
        for gg = [1:size(checked,1)]
           bbox_checked(gg,:) = bbox(checked(gg),:);
           real_cups(gg,:) = cup_centresPixel(real_cups_check(gg),:);
        end
end

