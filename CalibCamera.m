% Define images to process
imageFileNames = {'H:\1OCT\Calibration\calibration_1.png',...
    'H:\1OCT\Calibration\calibration_2.png',...
    'H:\1OCT\Calibration\calibration_3.png',...
    'H:\1OCT\Calibration\calibration_4.png',...
    'H:\1OCT\Calibration\calibration_5.png',...
    'H:\1OCT\Calibration\calibration_6.png',...
    'H:\1OCT\Calibration\calibration_7.png',...
    'H:\1OCT\Calibration\calibration_8.png',...
    'H:\1OCT\Calibration\calibration_9.png',...
    'H:\1OCT\Calibration\calibration_10.png',...
    'H:\1OCT\Calibration\calibration_11.png',...
    'H:\1OCT\Calibration\calibration_12.png',...
    'H:\1OCT\Calibration\calibration_13.png',...
    'H:\1OCT\Calibration\calibration_14.png',...
    'H:\1OCT\Calibration\calibration_15.png',...
    };

% Detect checkerboards in images
[imagePoints, boardSize, imagesUsed] = detectCheckerboardPoints(imageFileNames);
imageFileNames = imageFileNames(imagesUsed);

% Generate world coordinates of the corners of the squares
squareSize = 29;  % in units of 'mm'
worldPoints = generateCheckerboardPoints(boardSize, squareSize);

% Calibrate the camera
cameraParams = estimateCameraParameters(imagePoints, worldPoints, ...
    'EstimateSkew', true, 'EstimateTangentialDistortion', true, ...
    'NumRadialDistortionCoefficients', 3, 'WorldUnits', 'mm');

