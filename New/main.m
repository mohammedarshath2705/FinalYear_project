clc;
clear all;
close all;

% Dataset Path
imageFolder = './Data';
imds = imageDatastore(imageFolder, 'LabelSource', 'foldernames', 'IncludeSubfolders',true);

% Find the first instance of an image for each category
% leaf = find(imds.Labels == '001', 1);
% figure; imshow(readimage(imds,leaf))

tbl = countEachLabel(imds);

% Determine the smallest amount of images in a category
minSetCount = min(tbl{:,2}); 

% Limit the number of images to reduce the time it takes
% run this example.
maxNumImages = 100;
minSetCount = min(maxNumImages,minSetCount);

% Use splitEachLabel method to trim the set.
imds = splitEachLabel(imds, minSetCount, 'randomize');

% Notice that each set now has exactly the same number of images.
countEachLabel(imds)



% Load pretrained network
net = resnet50();
% Visualize the first section of the network. 
% figure
% plot(net)
% title('First section of ResNet-50')
set(gca,'YLim',[150 170]);
% Inspect the first layer
net.Layers(1)
% Inspect the last layer
net.Layers(end)
% Number of class names for ImageNet classification task
numel(net.Layers(end).ClassNames)
[trainingSet, testSet] = splitEachLabel(imds, 0.3, 'randomize');

% Create augmentedImageDatastore from training and test sets to resize
% images in imds to the size required by the network.
imageSize = net.Layers(1).InputSize;
augmentedTrainingSet = augmentedImageDatastore(imageSize, trainingSet, 'ColorPreprocessing', 'gray2rgb');
augmentedTestSet = augmentedImageDatastore(imageSize, testSet, 'ColorPreprocessing', 'gray2rgb');

% Get the network weights for the second convolutional layer
w1 = net.Layers(2).Weights;

% Scale and resize the weights for visualization
w1 = mat2gray(w1);
w1 = imresize(w1,5); 

% Display a montage of network weights. There are 96 individual sets of
% weights in the first layer.
figure
montage(w1)
title('First convolutional layer weights')

featureLayer = 'fc1000';
trainingFeatures = activations(net, augmentedTrainingSet, featureLayer, ...
    'MiniBatchSize', 32, 'OutputAs', 'columns');

% Get training labels from the trainingSet
trainingLabels = trainingSet.Labels;

% Train multiclass SVM classifier using a fast linear solver, and set
% 'ObservationsIn' to 'columns' to match the arrangement used for training
% features.
classifier = fitcecoc(trainingFeatures, trainingLabels, ...
    'Learners', 'Linear', 'Coding', 'onevsall', 'ObservationsIn', 'columns');

% Extract test features using the CNN
testFeatures = activations(net, augmentedTestSet, featureLayer, ...
    'MiniBatchSize', 32, 'OutputAs', 'columns');

% Pass CNN image features to trained classifier
predictedLabels = predict(classifier, testFeatures, 'ObservationsIn', 'columns');

% Get the known labels
testLabels = testSet.Labels;

% Tabulate the results using a confusion matrix.
confMat = confusionmat(testLabels, predictedLabels);

% Convert confusion matrix into percentage form
confMat = bsxfun(@rdivide,confMat,sum(confMat,2))

% Display the mean accuracy
mean(diag(confMat))

addpath(genpath('Functions'));

% Read files form pc. 
[FileName,PathName] = uigetfile('./Test/*.jpg;*.png;*.bmp',... 
                                    'Select an Input Image File');
I = imread([PathName,FileName]);
figure; imshow(I); title('Input Test Image');

% Image Resize
ReI = imresize(I,[256 256]);
% figure; imshow(ReI); title('Resized Test Image');

% Gray Conversion
GrI = rgb2gray(I);
GrI = imresize(GrI,[256 256]);
figure; imshow(GrI); title('Gray  Image');

% Preprocessing
I=double(ReI);
g=fspecial('gaussian');
pre(:,:,1)=imfilter(double(I(:,:,1)),g);
pre(:,:,2)=imfilter(double(I(:,:,2)),g);
pre(:,:,3)=imfilter(double(I(:,:,3)),g);
figure; imshow(uint8(pre)); title('Preprocessed Image');


% Segmentation
I = rgb2gray(uint8(pre));
% Specify initial contour location
mask = zeros(size(I));
mask(25:end-25,25:end-25) = 1;

% CNN Clasification
fprintf('Loading Data...\n')
load('Train_Data_FV.mat');
fprintf('Data Loaded Successfully...\n')
inputs = Feature'; 
test_x = cnn_test(GrI);
test_x = test_x(1:255);
Feature = Feature(1:end,1:end-7);

train_cnn = mean(Feature,2);
test__cnn = mean(test_x,2);

N = 30;
test12 = zeros(N,1) + test__cnn;

% cnn_data = ismember(train_cnn, test12);
cnn_data = ismembertol(train_cnn, test12);
cnn_mem  = find(cnn_data(:,1)>0);

% cnn_mem = find(train_cnn == test12)

fprintf('* * * * Predicted Label * * * * \n')

if (cnn_mem >= 0) && (cnn_mem <= 18)
    disp('Person: 001')
    helpdlg('  Person: 001 ');

elseif (cnn_mem >= 19) && (cnn_mem <= 36)
    disp(' Person: 002')
    helpdlg('  Person: 002  ');

elseif (cnn_mem >= 37) && (cnn_mem <= 54)
    disp(' Person: 003')
    helpdlg('  Person: 003  ');

elseif (cnn_mem >= 55) && (cnn_mem <= 72)
    disp(' Person: 004')
    helpdlg('  Person: 004  ');

elseif (cnn_mem >= 73) && (cnn_mem <= 90)
    disp(' Person: 005')
    helpdlg('  Person: 005  ');
    
else
    disp(' NOT IN DB')
    helpdlg('  NOT IN DB  ');
        
end
fprintf(' \n')


