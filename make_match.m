function [obj_points, scene_points, matches, scores] = make_match(f_library, d_library, ...
    f_scene, d_scene)
% Match sift points in scene for object detection.
% ------------------------------------------------------------------------
% Inputs:
%   f_library: Obtained from sift library
%   d_library: Obtained from sift library
%   f_scene: 
%   d_scene: 
% Outputs:
%   [obj_points, scene_points]: array containing points in the scene that
%   match the significant sift points detecting objects

    eucdist = 2;
    obj_points = [];
    scene_points = [];
    scene_temp = [];
    obj_temp = [];
    scores_thresh = 0.1; %number of scores present for match to occur
    for n = [1:length(f_library)]
        f_temp = f_library{n};
        d_temp = d_library{n};
        [matches{n}, scores{n}] = vl_ubcmatch(d_temp,...
            d_scene, eucdist);
        ii = 1;
        jj = 1;
        while ii <= size(matches{n},2)
% If the number of matches is above the treshold, add the
% matches (object points and scene points) to the output array
            if scores{n}(ii)/max(scores{n}) > scores_thresh
                temp_matches{n}(:,jj) = matches{n}(:,ii);   

                scene_temp = vertcat(scene_temp,...
                [f_scene(1,matches{n}(2,jj)),...
                f_scene(2,matches{n}(2,jj))]);

                obj_temp = vertcat(obj_temp,...
                    [f_temp(1,matches{n}(1,jj)), ....
                    f_temp(2,matches{n}(1,jj))]);     
                jj = jj + 1;
            end
            ii = ii + 1;
        end
            obj_points = vertcat(obj_points, obj_temp);
            scene_points = vertcat(scene_points, scene_temp);
    end
end

