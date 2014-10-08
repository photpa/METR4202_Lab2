function [ hDepth, vDepth ] = getDepthCoord( map, hGuess, vGuess, mode )
% AUTHOR John Francis TLDR: Given depth script was hard to use this was
% adapted instead
% Takes the map output from given depth2colormap function and the x and y
% coordinate of the rgb image we wish to find the correspondng points in.
%  highResCoord is 1 if a high resolution input image was
% supplied and 0 if standard 640x480 is supplied.

%This function returns a matrix 
%   [n m 2], were the pixel at dImage(i, j) can be mapped to some color
%   image 'cImage' pixel using cImage(map(i, j, 1), map(i, j, 2)).

%xGuess -> 640 argument
%yGuess -> 480 argument

	%Coordinate to find in the depth image	
	if (mode  == 1)
		hInitial = round(hGuess/2);
		vInitial = round(vGuess/2);
	else
		hInitial = hGuess;
		vInitial = vGuess;
    end
    
    %numChecks is a fail safe variable to ensure function won't continue
    %forever
    numChecks = 0;
    %Tolerances
    TOLERANCE = 1;

    %Assume the Depth coordinates map 1 to 1 to rgb coordinates
    hDepth = hInitial;
    vDepth = vInitial;

    %Initially the error should be more than tolerance
    err = TOLERANCE + 1;

    while err > TOLERANCE
        %Check the number of times loop has run
        numChecks = numChecks + 1;
        if (numChecks > 200)
            return;
        end
        
        %Compute RGB coordinates
        xRGB = map(vDepth, hDepth, 1);
        yRGB = map(vDepth, hDepth, 2);

        %Compute errors from guess
        hErr = hInitial - double(xRGB);
        vErr = vInitial - double(yRGB);

        %Compute total error
        err = sqrt(hErr^2 + vErr^2);

        %Check for early end condition
        if ( err < TOLERANCE )
            return;
        end
        
        %Adjust new test coordinate
        if (hErr > 0)
            hDepth = hDepth + 1;
        elseif (hErr < 0)
            hDepth = hDepth - 1;
        end
        if (vErr < 0)
            vDepth = vDepth - 1;
        elseif (vErr > 0)
            vDepth = vDepth + 1;
        end
    end
end
