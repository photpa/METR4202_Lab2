function bbox = group_haar(bbox, bbox_temp)
% Concatenate existing bounding boxes for each cup with its haar features.
% ------------------------------------------------------------------------
% Inputs:
%   bbox: an M-by-4 matrix specifying the upper-left corner and size of
%       a bounding box (y,x,height,width)
%   bbox_temp: temp variable for storing bbox
% Outputs:
%   bbox: an M-by-4 matrix specifying the upper-left corner and size of
%       a bounding box (y,x,height,width), modified using Haar features
    bbox_thresh = 0.5;
    if ~isempty(bbox)
        for bb = [1:size(bbox,1)]
% Take magnitude of height and width
            bb_hyp = hypot(bbox(bb,3),bbox(bb,4));
            for bbt = [1:size(bbox_temp,1)]
% Find magnitude of bbox height/width
                    bbt_hyp = hypot(bbox_temp(bbt,3),bbox_temp(bbt,4));
% Determine threshold value for bbox magnitude
                    dist_thresh = mean(round(bb_hyp), round(bbt_hyp));
                    bb_bbt_dist = pdist([[bbox_temp(bbt,1) ...
                        bbox_temp(bbt,2)],[bbox(bb,1) bbox(bb,2)]]);
                    if ~(bb_bbt_dist <= ((1-dist_thresh*bbox_thresh)+1) | ...
                            bb_bbt_dist >= (dist_thresh*bbox_thresh))
                        bbox = vertcat(bbox, bbox_temp); 
                    end
            end
        end
    else
% Concatenate new bbox values to existing bbox matrix
        bbox = vertcat(bbox, bbox_temp); 
    end
    if ~isempty(bbox)
        for n = [1:size(bbox,1)]
            for jj = [1:size(bbox,1)]
                if jj > size(bbox,1)
                    if [bbox(n,1), bbox(n,2)] > [bbox(jj,1),bbox(jj,2)] &...
                          [bbox(n,1), bbox(n,2)] < ...
                            [bbox(jj,1)+bbox(jj,3),bbox(jj,2)+bbox(jj,4)]
                      bbox(n) = [];
                    end
                end
            end
        end
    end
end

