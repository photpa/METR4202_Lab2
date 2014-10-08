function grid = generate_grid(scene_img, scene_points)
    grid_size = [40, 30]; % x,y
    grid = NaN(mean(size(scene_img,1)/grid_size(2),...
        size(scene_img,2)/grid_size(1)));
    for hh = [1:mean(size(scene_img,1)/grid_size(2),...
            size(scene_img,2)/grid_size(1))]
        if hh == 1
            horiz_bot_bound = 0;
        elseif 1 < hh & hh < mean(size(scene_img,1)/grid_size(2),...
                size(scene_img,2)/grid_size(1))
            horiz_bot_bound = (hh-1)*grid_size(1);
        end
        for vv = [1:mean(size(scene_img,1)/grid_size(2),...
                size(scene_img,2)/grid_size(1))]
            temp_cnt = 0;
            if vv == 1
                vert_bot_bound = 0;
            elseif 1 < vv & vv < mean(size(scene_img,1)/grid_size(2), ...
                    size(scene_img,2)/grid_size(1))
                vert_bot_bound = (vv-1)*grid_size(2);
            end
            for pp = [1: size(scene_points,1)]
                if horiz_bot_bound < scene_points(pp, 1) & ...
                        scene_points(pp, 1) < hh*grid_size(1)
                    if vert_bot_bound < scene_points(pp, 2) & ...
                        scene_points(pp, 2) < vv*grid_size(2)
                        temp_cnt = temp_cnt + 1;
                    end
                end
            end
            grid(vv, hh) = temp_cnt;
        end
    end  
end

