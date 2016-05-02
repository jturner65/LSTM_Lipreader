%%function to test loading of training data csvs
%function will return matrix of training data
%-->file that has training words needs to live in directory trainingData
%and be called "training_WordDict.csv"
%this file will have 1 row per word, and the file's format will be (csv) : 
%word,FrameStEstimate,FrameEndEstimate,SentenceLocation,audioAugFrameStEstimate,audioAugFrameEndEstimate,CaptionsStartTime,CaptionsEndTime,FileName,TimeCaption																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																						
%-->file that holds list of videos required needs to live in directory trainingData
%and be called "training_NecessaryVids.csv" <-- not much benefit, spans all
%files.  NEED TO WRAP VID FILE OPENS IN TRY, since some havent' been
%converted
%-->file that holds list of words as classes needs to be in same dir
%and be called "training_ChosenWords.csv" 
clear;
baseDir = 'D:/LipReaderProject/listeningeye/MatlabCode/FaceDetectCrop/';
seqLength = 25;
fileInfo = trainingDataFormat(baseDir, seqLength);
newTrain = 1;

%build 2 matrices, 1600 x seqLength x total# of training examples, 
%and cls%(1-hot class value) x seqLength x total# of training examples
%then take batches of appropriate size of these
%perform jittering (flip across y axis) as being used
%RUN ONLY WHEN NEW TRAINING DATA

if newTrain == 1
    [classData, trainRaw, numClasses] = loadTrainingData(fileInfo);
    save('trainingDataPass1.mat','classData','trainRaw', 'numClasses');
    disp('done with initial processing');
else
    tmp = load('trainingDataPass1.mat','classData','trainRaw', 'numClasses');
    classData = tmp.classData;
    trainRaw = tmp.trainRaw;
    numClasses = tmp.numClasses;
end
%build sample data based on info from trainRaw matrix, build class data
%from info from classData and trainRaw matrices
%for each example we have 1600x25 sequences in sampleData - #rows of
%we have numSamples # of examples
%for each class
%parpool(12);
%parfor i = 1:numClasses    
for i = 1:numClasses
    classIDX = i-1;    
    classDataName = strcat(fileInfo.trainingDir,'fullTrainData_class_',num2str(classIDX),'.mat');
    trainSubRaw = trainRaw(trainRaw(:,4) == classIDX,1:3);
    disp(strcat('staring class ',num2str(classIDX),' for file name : ',{' '},classDataName));
    [classRes, trainRes] = buildTrainDataForClass(classIDX, fileInfo, trainSubRaw, numClasses);
%     classResAra(i,:) = classRes;
%     trainResAra(i,:) = trainRes;
    disp(strcat('save class ',num2str(classIDX),' for file name : ',{' '},classDataName));
    save(classDataName,'classRes','trainRes');
end
%delete(gcp('nocreate'));
% 
% for i = 1:numClasses
%     classIDX = i-1;
%     classDataName = strcat(fileInfo.trainingDir,'fullTrainData_class_',num2str(classIDX),'.mat');
%    	classRes = classResAra(i,:);
%     trainRes = trainResAra(i,:);
%     save(classDataName,'classRes','trainRes');
% end


