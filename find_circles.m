function [cup_radius] = find_circles(rgb, bbox)
% Finds the radius of each of the detected cups, to be used for determining
% cup type.
% ------------------------------------------------------------------------
% Inputs:
%   rgb: RGB image
%   bbox: an M-by-4 matrix specifying the upper-left corner and size of
%       a bounding box
% Outputs:
%   [cup_radius]: a matrix specifying the radii of each detected object/cup

    % Create an array containing points defining detected objects   
    points = [];
   for n = [1:size(bbox,1)]
    points = vertcat(points, round([bbox(n,2)+10,...
        bbox(n,1)+bbox(n,3)/2]));
   end
   % Turn RGB image into grayscale and intensify
    Ib = rgb2gray(rgb);
    Ib = imadjust(Ib);
    % Show only edges in image
    Ib = bitshift(Ib, 1);
    E = edge(Ib, 'canny', 0.3);
    % E = imfill(E, 4, 'holes');
    E = bwmorph(E, 'thicken');
    imshow(E);

cup_radius = [];
cup_opening_info = [];
count = 5;
% Iterate through detected objects to trace circle boundaries in order
    % to calculate circle radii = cup radii
    for g = [1:count]
        for ii=[1:size(points, 1)]
            if g == 1
                cup_radius{ii} = 0;
            end
            while E(points(ii, 1), points(ii, 2)) == 0
                points(ii, 2) = points(ii, 2) + 1;
            end

            boundary{ii} = bwtraceboundary(E, [points(ii, 1), points(ii, 2)],...
                'W', 8, 100, 'counterclockwise'); 
            clean_boundary{ii} = [];
            for kk = [1:size(boundary{ii},1)]
                for pp = [1:size(boundary{ii},1)]
                    temp = vertcat(boundary{ii}(kk,:), boundary{ii}(pp,:));
                    distb = pdist(temp);
                    if distb < 1
                    else
                        clean_boundary{ii} = vertcat(clean_boundary{ii}, boundary{ii}(pp,:));
                    end
                end
            end
            stat = 1;
            attempt = 1;
            while stat == 1
                blength = size(clean_boundary{ii},1);
                randsamp = randperm(round(blength*0.4), round(blength*0.4));
                bound_samp = [];
                for n = [1:length(randsamp)]
                   bound_samp = vertcat(bound_samp, clean_boundary{ii}(randsamp(n),:)); 
                end
                if ~isempty(bound_samp)
                cup_info{ii} = fit_ellipse(bound_samp(:,1), bound_samp(:,2));
                if ~isempty(cup_info{ii}.status)
                    stat = 0;
                end
                attempt = attempt + 1;
                if attempt == 10
                    break
                end

            
            open_area{ii} = cup_info{ii}.a*cup_info{ii}.b*pi;
            cup_radius{ii} = horzcat(cup_radius{ii},sqrt(open_area{ii}/pi)); 

            hold on
            plot(boundary{ii}(:,2),boundary{ii}(:,1),'g','LineWidth',2);
                end
            end
        end
    end    
    for n = [1:size(cup_radius,2)]
        cup_radius{n} = mean(cup_radius{n});
    end
    
end