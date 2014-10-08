function cup_centres = find_clusters(norm_grid_ref)
    conn_data = bwconncomp(norm_grid_ref, 8);
    cup_centres = [];
    cup_centresX = [];
    cup_centresY = [];
    for n = [1:length(conn_data.PixelIdxList)-1]
%         [cup_centresX(n), cup_centresY(n)] = ...
        [xtemp, ytemp] = ind2sub(32, cell2mat(conn_data.PixelIdxList(n)));  
        cup_centres = vertcat(cup_centres, [xtemp, ytemp]);
          
    end
%     cup_centres = transpose(vertcat(cup_centresX, cup_centresY));
end

