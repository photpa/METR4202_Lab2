function draw_cascade(bbox, img)
% The function draw_cascade outputs a single image of each detected image
% from the cascade.m function.
% ------------------------------------------------------------------------
% Inputs:
%   bbox: an M-by-4 matrix specifying the upper-left corner and size of
%       a bounding box (from cascade.m)
%   img: Image file object detection to be performed on (grayscale or RGB)
% Outputs:
%   detectedImg: a snapshot of the detected object
if ~isempty(bbox)
    nums = [1:size(bbox,1)];
    for n = [1:size(bbox,1)]
        name{n} = ['cup' num2str(nums(n))];
    end
    detectedImg = insertObjectAnnotation(img, 'rectangle', bbox, name);
    figure; 
    imshow(detectedImg);
end
end

