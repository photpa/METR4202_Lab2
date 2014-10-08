function in_clusters = filter_dist(scene_points)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    dist_thresh = 50;
%     dist = pdist(scene_points);
%     dist_mat = squareform(dist);
%     dist_mat_norm = dist_mat./max(dist);
%     cluster_points = [];
%     for n = [1:size(dist_mat,1)]
%         sprintf('%d / %d', n, size(dist_mat,1))
%         tic
%        for ii = [1:size(dist_mat,2)]
%            if dist_mat_norm(n,ii) > dist_thresh
%                cluster_points = vertcat(cluster_points, [n ii]);
%        end
%        end
%    toc
tic
    for n = [1:size(scene_points,1)]
        sprintf('%d / %d', n, size(scene_points,1))
        for ii = [1:size(scene_points,1)]
            dist_temp = pdist([scene_points(n), scene_points(ii)]);
            if dist_temp < dist_thresh
                in_clusters = vertcat(in_clusters,...
                    [scene_points(n), scene_points(ii)]);
            end
        end
    end
    toc
end

