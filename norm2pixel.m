function cup_centrePixel = norm2pixel(cup_centres)
%UNTITLED8 Summary of this function goes here
%   Detailed explanation goes here
    grid_size = [40, 30]; % x,y
    num_cups = size(cup_centres,1);
    cup_centrePixel = NaN(num_cups, 2);
    for nn = [1:num_cups]
        cup_centrePixel(nn,1) = cup_centres(nn,1)*(grid_size(1));
        cup_centrePixel(nn,2) = cup_centres(nn, 2)*(grid_size(2));         
    end
end

