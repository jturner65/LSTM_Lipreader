%%function builds training data for a single class, using sequence size
%%from file info
function [classRes, trainRes] = buildTrainDataForClass(classIDX, fileInfo, trainRaw, numClasses)
    %classDataName = strcat(fileInfo.trainingDir,'fullTrainData_class_',num2str(classIDX),'.mat');
    %disp(strcat('Starting on : ',{' '},classDataName));
    seqLen = fileInfo.seqLen;
    uniqueFiles = unique(trainRaw(:,3));
    numClassSamples = size(trainRaw,1);
    trainRes = zeros(1600,seqLen,numClassSamples);
    %class res is done here
    classRes = zeros(numClasses,seqLen,numClassSamples);
    classRes(classIDX+1,:,:) = 1;

    numUniqueFiles = size(uniqueFiles,1);
    classSampleIDX = 1;
    for i = 1:numUniqueFiles
        fileIDX = uniqueFiles(i);
        if(fileIDX > 1118) 
            continue;
        end
        imgMatFileName = buildImgMatName(fileIDX,fileInfo);
        try
            %some mat files do not exist yet
            tmp = load(imgMatFileName);
        catch ME
            disp(strcat('file does not exist',imgMatFileName));
            continue;
        end
        imgAra = tmp.imgSmallMat;
        %use imgAra to provide training samples
        examplesInVidFile = trainRaw(trainRaw(:,3)==fileIDX, 1:2);
        numExamples = size(examplesInVidFile,1);
        
        for j=1:numExamples         %build each example that uses this file
            trainBlock = zeros(1600,seqLen);    %set up a block of sequences
            blkStIdx = 1;
            blkEndIdx = seqLen;
            blockDiff = blkEndIdx - blkStIdx + 1;
            stIdx = examplesInVidFile(j,1);
            if(stIdx < 1) 
                disp('neg index')
                continue;
            end
            endIdx = examplesInVidFile(j,2);
            if(endIdx > size(imgAra,2)) 
                disp('beyond end of file')
                continue;
            end
            numFrames = endIdx - stIdx + 1;
            distToClip = numFrames - seqLen;
            if(distToClip > 0)  %bigger than sequence length
                %need to clip to fit
                distFront = floor(distToClip/2);
                distBack = distToClip - distFront;
                stIdx = stIdx + distFront;
                endIdx = endIdx - distBack;
                numFrames = endIdx - stIdx + 1;
                %disp('bigger');
            elseif (distToClip < 0)     %smaller than sequence length
                %need to pad
                framesToAdd = floor(-distToClip/4);
                stIdx = stIdx - framesToAdd;
                endIdx = endIdx + framesToAdd;
                numFrames = endIdx - stIdx + 1;
                blkStIdx = blkStIdx + framesToAdd;
                blkEndIdx = blkStIdx + numFrames - 1 ;
                blockDiff = blkEndIdx - blkStIdx + 1;
                %disp('smaller');
            %else %if equal do nothing                
            end
            if numFrames > seqLen  %less than or == is what we want
                disp(strcat('seq len error - length is bigger than seqlen : ',{' '},num2str(numFrames),' vs.',{' '},num2str(seqLen)));
            end
            if(numFrames ~= blockDiff)                
                disp(strcat('array dim mismatch : ',{' '},num2str(numFrames),' vs. ',{' '},num2str(blockDiff)));
            end
            %disp(strcat('blk start : ',num2str(blkStIdx),' blk end : ',num2str(blkEndIdx)));
            try
                trainBlock(:,blkStIdx:blkEndIdx) = imgAra(:,stIdx:endIdx);            
                trainRes(:,:,classSampleIDX) = trainBlock;            
                classSampleIDX = classSampleIDX + 1;
            catch ME
                disp('idx error not written to trainres!');
            end        
        end%for each example   
        disp(strcat('Done with file :',{' '},imgMatFileName));
    end%for every unique file
    disp('Done');
    %save(classDataName,'classRes','trainRes');
end