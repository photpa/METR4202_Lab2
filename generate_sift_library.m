% Generate sift library for all cups
% clear all
% close all
% clc
% tic
% peak_thresh = 0; %default 0
% edge_thresh = 1e100; %default 10
% lib_mults = 2;
% % direc = strcat(pwd,'\library\*.png');
% cup_files = dir('H:\1OCT\library\*.png');
lib_iter = 1;
for ii = [1:lib_mults]

    for n = [1:length(cup_files)]
        sprintf('%d/%d',n, length(cup_files))
        temp = single(rgb2gray(imread(cup_files(n).name)));
       [f_library{lib_iter} d_library{lib_iter} ] = vl_sift(temp, ...
           'PeakThresh', peak_thresh,'edgethresh', edge_thresh);
    lib_iter = lib_iter + 1;
    end
    
end

save('sift_library_up');

toc
