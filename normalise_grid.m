function norm_grid_ref = normalise_grid(grid)
    per_thresh = 40; % grid count threshold 40 start
    max_match = max(max(grid, [], 1));
    norm_grid = round(grid/max_match*100);
    [sort_value, sort_index] = sort(norm_grid(:),'descend');
    for nn = [1:length(sort_index)]
        if sort_value(nn) > per_thresh
            top_per = nn;
        else
            break            
        end
    end
    pot_cups = sort_index(1:top_per);
    pot_cup_top = sort_value(1:top_per); 
    norm_grid_ref = +ismember(norm_grid, pot_cup_top);
end

