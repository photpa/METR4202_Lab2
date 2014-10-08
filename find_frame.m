function frame_coord = find_frame(metric_coords, dep, map)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
    imageFileNames = strcat(pwd, '\graytemp.png');
    [imagePoints, boardSize, imagesUsed] = detectCheckerboardPoints(imageFileNames);
    imageFileNames = imageFileNames(imagesUsed);
    squareSize = 23.5;  % in units of 'mm'
    worldPoints = generateCheckerboardPoints(boardSize, squareSize);
    
    if size(imagePoints,1) < 70
        divisor = gcd(size(imagePoints,1),7);
        top_full = size(imagePoints,1)/divisor;
        p1 = (imagePoints(1, :));
        p2 = (imagePoints(7, :));
        p3 = (imagePoints(top_full-6, :));
        p4 = (imagePoints(top_full, :));
    else
        p1 = (imagePoints(1, :));
        p2 = (imagePoints(7, :));
        p3 = (imagePoints(64, :));
        p4 = (imagePoints(70, :));
    end
    
    depth_out = dep{1};
    [p1dx, p1dy] = getDepthCoord(map, p1(1), p1(2), 1);
    [p2dx, p2dy] = getDepthCoord(map, p2(1), p2(2), 1);
    [p3dx, p3dy] = getDepthCoord(map, p3(1), p3(2), 1);
    [p4dx, p4dy] = getDepthCoord(map, p4(1), p4(2), 1);

    p1_depth = depth_out(p1dy, p1dx)
    p2_depth = depth_out(p2dy, p2dx)
    p3_depth = depth_out(p3dy, p3dx)
    p4_depth = depth_out(p4dy, p4dx)

    x = p2(1);
    y = p2(2);
    z = p2_depth;

    met_coord = metric_space([x, y], z);

    angleroll = -atan2d((p1(2)-p3(2)),p3(1)-p1(1))
    angleyaw = asind(double(p1_depth-p3_depth)/213)
    anglepitch = -asind(double(p1_depth-p2_depth)/142)

    Rx = [1, 0, 0; 0, cosd(angleroll), -sind(angleroll); 0, sind(angleroll), cosd(angleroll)];
    Ry = [cosd(anglepitch), 0, sind(anglepitch); 0, 1, 0; -sind(anglepitch), 0, cosd(anglepitch)];
    Rz = [cosd(angleyaw), sind(angleyaw), 0; -sind(angleyaw), cosd(angleyaw), 0; 0, 0, 1];

    R = Rx*Ry*Rz;
    Ri = double(inv(R));
    frame_coord = [];
    for n = [1:size(metric_coords,1)]
        temp = Ri*double(metric_coords(n,:))' + double(met_coord-metric_coords(n,:))';
    %     temp = metric_coords(n,:)*(Ri-eye(size(Ri))) + met_coord;
    %     tempY = metric_coords(n,2)*(Ri-eye(size(Ri))) + met_coord(1,2);
        frame_coord = horzcat(frame_coord,  temp);
    end

end

