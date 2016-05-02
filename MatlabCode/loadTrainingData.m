%%this function will build entire corpus of training data, to be split into
%%batches later
%"training_WordDict.csv" format : 
%word,FrameStEstimate,FrameEndEstimate,SentenceLocation,audioAugFrameStEstimate,audioAugFrameEndEstimate,CaptionsStartTime,CaptionsEndTime,FileName,TimeCaption																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																						

function [classData, trainRaw, numClasses] = loadTrainingData(fileInfo)
    %load training data csv
    %indices of each component used
    wordIDX = fileInfo.trnDat_wrdIDX; 
    classNumIDX = fileInfo.trnNum_wrdClassIDX;
    frStIDX = fileInfo.trnNum_FrameStIDX;       %can also be trnNum_AudFrameStIDX
    frEndIDX = fileInfo.trnNum_FrameEndIDX;       %can also be trnNum_AudFrameEndIDX
    vidFileIDX = fileInfo.trnNum_VidFileNameIDX;
    
    %read in numeric csv data
    trainTotMat = csvread(fileInfo.trnNumericDataFileName);
    numSamples = size(trainTotMat,1);
    fid = fopen(fileInfo.trnWrdToVidFileName);       
    chFileLine = fgetl(fid);  %get rid of header
    chFileLine = fgetl(fid);
    numClasses = 0;
    classData = cell(numSamples,2);     %string, idx, will grow dynamically
    trainRaw = zeros(numSamples,4);   %st frame, end frame, file #, class - will grow dynamically
    recIDX = 1;
    while ischar(chFileLine)%both files should be same length
        chFileAra = strsplit(chFileLine, ',');
        
        %class file - rows correspond to examples
        classData(recIDX,1) = chFileAra(wordIDX);
        classData(recIDX,2) = cellstr(num2str(trainTotMat(recIDX,classNumIDX)));%numFileAra(classNumIDX);
        numClasses = trainTotMat(recIDX,classNumIDX)+1;
        %train data - rows correspond to examples       
        trainRaw(recIDX,1) = trainTotMat(recIDX,frStIDX);
        trainRaw(recIDX,2) = trainTotMat(recIDX,frEndIDX);
        trainRaw(recIDX,3) = trainTotMat(recIDX,vidFileIDX);
        trainRaw(recIDX,4) = trainTotMat(recIDX,classNumIDX);
         
        recIDX = recIDX + 1;
        chFileLine = fgetl(fid);
    end    
    fclose(fid);  
end