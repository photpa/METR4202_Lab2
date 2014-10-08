
clear all
clc
close all
% Load training images into current folder for flute detection
load(strcat(pwd,'/fluteDepthROI.mat'));
addpath(strcat(pwd, '/flute/DepthEmpty/'));
negativeFolder = strcat(pwd, '/negative_images/')
% Run trainer for flute
trainCascadeObjectDetector('FluteDepth_NC_10_FA_0.2.xml','resume');%data, negativeFolder,...
%    'FalseAlarmRate', 0.2, 'NumCascadeStages', 10);
%  'FeatureType','Haar'
