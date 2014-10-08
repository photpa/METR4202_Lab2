      %Create video input devices
      cvi = videoinput('mwkinectimaq', 1);
      dvi = videoinput('mwkinectimaq', 2);
  
      %Set manual triggering and frame count
      triggerconfig([cvi dvi], 'manual');
      set([cvi dvi], 'FramesPerTrigger', 1);
  
      %Start input devices
      start([cvi dvi]);
  
      %Trigger input devices
      trigger([cvi dvi]);
  
      %Get data from devices
      c = rgb2gray(getdata(cvi));
      d = bitshift(getdata(dvi), 3);

      %Stop input devices
      stop([cvi dvi]);
 
      %Calculate map
      map = depth2colormap(d');
  
      %Generate mapped color image
      cMapped = uint8(zeros(size(c)));
      for i = 1:size(map, 1)
          for j = 1:size(map,2)
              x = map(i,j,2);
              y = map(i,j,1);
  
              if (x > 0) && (y > 0) && ...
                  (x < size(c, 1)) && (y < size(c, 2))
                  cMapped(i, j) = c(x, y);
              end
          end
      end
      
      fusedBefore = imfuse(d, c);
      fusedAfter = imfuse(d, cMapped);
      
      imshow(fusedBefore);
      figure;
      imshow(fusedAfter);