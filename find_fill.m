function fill_lvl = find_fill(gray, bbox)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    fill_lvl = [];
    points = [];
    pxoff = -2;
    for n = [1:size(bbox,1)]
        inten = 0;
        iter = 0;
        while iter < 3
            points = vertcat(points, round([bbox(n,2)+10,...
                bbox(n,1)+bbox(n,3)/2]));
            i1 = gray(round(points(n,1))+pxoff*iter, round(points(n,2)));
            if  i1 >= 255/2
                i1 = 1;
                iter = iter + 1;
            else 
                i1 = 0;
                iter = 10;
            end
            inten = inten + i1;        
        end
        intensity = i1;
       if intensity >= 0.5
            lvl = ' empty';
        elseif intensity < 0.5
            lvl = ' full';
        else
            lvl = ' this should not be happening';
        end
    fill_lvl{n} = lvl;
    end
end

