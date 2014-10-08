function [bbox, detector] = cascade(img, type)
% The cascade object detector function uses the Viola-Jones algorithm to
% detect either cup or flute (depending on 'type') as defined by the model
% defined in vision.CascadeObjectDetector string (this model has been
% created through training).
% ------------------------------------------------------------------------
% Inputs:
%   img: Image file object detection to be performed on (grayscale or RGB)
%   type: 0 - cup, 1 - flute
% Outputs:
%   [bbox, detector]:
%       bbox: an M-by-4 matrix specifying the upper-left corner and size of
%       a bounding box (y,x,height,width)
%       detector: the cascade object detector object    
    if type == 0 %cup type
        detector = vision.CascadeObjectDetector('FA0_5_NC_19.xml');
        bbox = step(detector, img);
    elseif type == 1 %flute type
        detector = vision.CascadeObjectDetector('Flute_NC_10_FA_0.2Haar.xml');
        bbox = step(detector, img);
    elseif type == 2
        detector = vision.CascadeObjectDetector('FULLFlute_NC_10_FA_0.2.xml');
        bbox = step(detector, img);      
    elseif type == 3
        detector = vision.CascadeObjectDetector('HALFFlute_NC_10_FA_0.2Haar.xml');
        bbox = step(detector, img);
    elseif type == 4
        detector = vision.CascadeObjectDetector('FluteDEPTH_NC_10_FA_0.2.xml');
        bbox = step(detector, img);       
    else
        disp('invalid type')
        bbox = 0;
        detector = 0;
end

