clc
clear all
close all
tic
load('sift_library_up.mat');
load('flute_library.mat');
tic
f_scene = [];
d_scene = [];
bbox = [];
bbox_flute = [];
bbox_FULLflute = [];
bbox_HALFflute = [];
bbox_DEPTHflute = [];
sift_thresh_multi = 0.2; %0.25; %0.25 Well lit room minimal fuckery in background
bbox_thresh = 0.1;
repeat = 2;
vid = videoinput('mwkinectimaq',1, 'RGB_1280x960');
depth = videoinput('mwkinectimaq',2);
triggerconfig([vid depth],'manual')
set([vid depth], 'FramesPerTrigger', 1);
for zz = [1:repeat]
    start([vid depth]);
    trigger([vid depth]);
    scene_img{zz} = getdata(vid);
    dep{zz}= bitshift(getdata(depth),0);
    stop([vid depth]);
    scene{zz} = single(rgb2gray(scene_img{zz}));
    gray_scene{zz} = rgb2gray(scene_img{zz});
    disp('snap snap snap')
    [bbox_temp, detector] = cascade(gray_scene{zz}, 0);
    if ~isempty(bbox_temp)
        bbox = group_haar(bbox, bbox_temp);
    end
    [bbox_flute_temp, detector_flute] = cascade(gray_scene{zz}, 1);
    bbox_flute = group_haar(bbox_flute, bbox_flute_temp);
    
    [bbox_FULLflute_temp, detector_FULLflute] = cascade(gray_scene{zz}, 2);
    bbox_FULLflute = group_haar(bbox_FULLflute, bbox_flute_temp);
    
    [bbox_HALFflute_temp, detector_HALFflute] = cascade(gray_scene{zz}, 3);
    bbox_HALFflute = group_haar(bbox_HALFflute, bbox_flute_temp);
    
    [bbox_DEPTHflute_temp, detector_DEPTHflute] = cascade(dep{zz}, 4);
    bbox_DEPTHflute = group_haar(bbox_DEPTHflute, bbox_DEPTHflute_temp);
    
end
imwrite(gray_scene{1}, 'graytemp.png');
map = depth2colormap(bitshift(dep{1},3)'); 
load('cameraParams.mat');
[rotation_mat, trans_mat] = frame_extrinsics(scene_img{1}, cameraParams);
checked_bbox = [];
max_scene_points = 0;
min_scene_points = 1e100;
for n = [1:size(bbox,1)]
    cropped_img{n} = imcrop(gray_scene{1}, bbox(n,:));
    for ss = [1:repeat]
        [f_scene{n}{ss}, d_scene{n}{ss}] = ...
            vl_sift(single(cropped_img{n}),'PeakThresh', ...
                peak_thresh, 'edgethresh', edge_thresh);
        if ss == 1 
            [obj_points{n}, scene_points{n}, matches{n}, score{n}] = make_match(f_library,...
            d_library, f_scene{n}{ss}, d_scene{n}{ss});
        else
            [obj_points_temp, scene_points_temp, matches_temp, score_temp] = ...
                make_match(f_library, d_library, f_scene{n}{ss},...
                 d_scene{n}{ss});
            obj_points{n} = horzcat(obj_points{n}, obj_points_temp);
            scene_points{n} = horzcat(scene_points{n}, ...
                scene_points_temp);
            matches{n} = horzcat(matches{n}, matches_temp);
            score{n} = horzcat(score{n}, score_temp);
        end
    end
    unique_scene_points{n} = unique(scene_points{n});
     if size(unique_scene_points{n},1) > max_scene_points
         max_scene_points = size(unique_scene_points{n},1);
     end
     if size(unique_scene_points{n},1) < min_scene_points
         min_scene_points = size(unique_scene_points{n},1);
     end
end 
for qq = [1:size(bbox,1)]
    if size(unique_scene_points{qq},1) > ....
            sift_thresh_multi*max_scene_points
     checked_bbox = vertcat(checked_bbox, bbox(qq ,:));
%      upright{qq} = determine_orientation(f_scene{qq}, f_library, matches{qq}, score{qq});
    end 
end
cup_centres = [];
cup_depth_coord = [];
cup_depths = [];
for jj = [1:size(checked_bbox,1)]
    cup_centres = vertcat(cup_centres, ...
        [checked_bbox(jj,1)+checked_bbox(jj,3)/2, ... 
        checked_bbox(jj,2)+checked_bbox(jj,4)/2]);
    
    [dx_temp, dy_temp] = getDepthCoord(map, cup_centres(jj,1),...
        cup_centres(jj,2), 1);
    cup_depths = vertcat(cup_depths, dep{1}(dy_temp, dx_temp));
    cup_depth_coord = vertcat(cup_depth_coord, [dx_temp, dy_temp]);
end
flute_centres = [];
flute_depth_coord = [];
flute_depths = [];
for jj = [1:size(bbox_flute,1)]
    flute_centres = vertcat(flute_centres, ...
        [bbox_flute(jj,1)+bbox_flute(jj,3)/2, ... 
        bbox_flute(jj,2)+bbox_flute(jj,4)/2]);
        [dx_temp, dy_temp] = getDepthCoord(map, flute_centres(jj,1),...
        flute_centres(jj,2), 1);
    fd = dep{1}(dy_temp, dx_temp);
    while fd == 0
        dy_temp = dy_temp - 1;
        fd = dep{1}(dy_temp, dx_temp);
    end
    flute_depths = vertcat(flute_depths, fd);
    flute_depth_coord = vertcat(flute_depth_coord, [dx_temp, dy_temp]);
end
plot_bbox = vertcat(checked_bbox, bbox_flute);
draw_cascade(plot_bbox, scene_img{1});
if ~isempty(cup_centres)
    hold on
    plot(cup_centres(:,1), cup_centres(:,2), 'yd');
    hold off
end
if ~isempty(flute_centres)
    hold on
    plot(flute_centres(:,1), flute_centres(:,2), 'rd');
    hold off
end
figure;
imshow(bitshift(dep{1},5));
hold on
if ~isempty(cup_depth_coord)
plot(cup_depth_coord(:,1), cup_depth_coord(:,2),'yd');
end
if ~isempty(flute_depth_coord)
plot(flute_depth_coord(:,1), flute_depth_coord(:,2),'ro');
end
hold off
cup_type = calc_cup_type(cup_depths, checked_bbox);
metric_coords = metric_space(cup_centres, cup_depths);
metric_flute_coords = metric_space(flute_centres, flute_depths);
cup_frame_coords = transform_to_frame(rotation_mat, trans_mat, metric_coords);
flute_frame_coords = transform_to_frame(rotation_mat, trans_mat, metric_flute_coords);
fill_lvl = find_fill(gray_scene{1}, checked_bbox);
% frame_coord = find_frame(metric_coords, dep, map);
num_cups = size(checked_bbox,1);
num_flutes = size(bbox_flute,1);
fdisp = sprintf('You have found %d cups and %d flutes, Congratulations!'...
    , num_cups, num_flutes);
disp(fdisp)
nl = sprintf('\n');
disp(nl)
for n = [1:num_cups]
    if cup_type(n) == 0
        temp_type = ' small';
    elseif cup_type(n) == 1
        temp_type = ' medium';
    elseif cup_type(n) == 2
        temp_type = ' large';
    else
        temp_type = 'one of the others';
    end
   print = sprintf(strcat('Cup number %d was found to be a '...
       ,temp_type, ' cup. It is  ', fill_lvl{n},'.'),n);
   disp(print)
   loca = sprintf(...
       'The cup is located at [%d, %d] in the pixel space at a metric range of %d',...
       int16(cup_centres(n,:)), int16(cup_depths(n)));
   disp(loca)
    metric_location = double(metric_coords(n,:))
    in_reference_to_frame = cup_frame_coords(n,:)
   disp(nl)
end
for n = [1:num_flutes]
       print = sprintf(strcat('Flute number %d was found to be at. It is full/half/empty (your choice).'),n);
   disp(print)
   loca = sprintf(...
       'The flute is located at [%d, %d] in the pixel space at a metric range of %d',...
       int16(flute_centres(n,:)), int16(flute_depths(n)));
      disp(loca)
   metric_location = double(metric_flute_coords(n,:))
      in_reference_to_frame = flute_frame_coords(n,:)

   disp(nl)        
end
toc

