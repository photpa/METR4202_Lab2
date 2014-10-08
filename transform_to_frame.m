function frame_ref_coord = transform_to_frame(rotation_mat,...
    trans_mat, metric_points)

    rot_mat = inv(rotation_mat);
    trans_mat = -trans_mat;
    transform_mat = [rot_mat, trans_mat'];
    transform_mat = [transform_mat; 0 0 0 1];
    frame_ref_coord = [];
        for i = 1:size(metric_points, 1)
            cup_coord_temp = [metric_points(i,:) 1];
            tempframecoord = transform_mat*cup_coord_temp';
            frame_ref_coord = vertcat(frame_ref_coord, tempframecoord(1:3)');
        end
end