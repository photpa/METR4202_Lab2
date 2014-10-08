function upright = determine_orientation(f_scene, f_lib, matches, scores)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
check_up = 20; 
ups = 0;
downs = 0;
        for k = [1:size(matches,2)]
            
            reference_points(k,:) = f_lib(1:2, matches(2,k));
            reference_angle = f_lib(4, matches(2,k)); 
                        
            scene_matches(k,:) = f_scene(1:2, matches(1,k));            
            scene_angle = scene_points(4, matches(1,k));
            
            reference_angle = mod(scene_angle, 2*pi);
            scene_angle = mod(scene_angle, 2*pi);
            while reference_angle < 0
                reference_angle = reference_angle + 2*pi;
            end
            while scene_angle < 0
                scene_angle = scene_angle + 2*pi;
            end
            angle_between = (reference_angle - scene_angle);
            angle_between = abs(angle_between) * 180/pi
%             sum_deg = abs(sum([reference_angle, scene_angle],2)) * 180/pi;
            
            % if the angles differ by less than tolerance, it's upright
            if angle_between < check_up
                ups = ups + 1;
            end
            % if the angles add to be 270, the cup has been inverted
            if abs(angle_between-180) < check_up
                downs = downs + 1;
            end
        end
ups 
downs
    if downs > ups
        upright = 0;
    else
        upright = 1;
    end
    

end

