%this will use the csv files of the data from the .vtt caption files
%along with the audio from the videos to find the best frame boundaries for
%each word.
%the csvs have each word in each video in order, plus suggestions of frame
%bounds based on timestamps embedded in the vtt file (the time the captions
%are displayed)
%the audio will first be examined for when a frame drops below a particular
%threshold to denote the boundary of a word, and correspondences with
%info from csv will be built.  

%base directory  :fileDir = 'D:/LipReaderProject/listeningeye/MatlabCode/FaceDetectCrop/';
baseDir =  'D:/LipReaderProject/listeningeye/MatlabCode/FaceDetectCrop/';
outputDir = {'output','output_2'};
dirIDX = 2;
% dirIDX = 1:2 
    outputVal = outputDir(dirIDX);
    sndDirStr = char(strcat(baseDir,outputDir(dirIDX),'/snd'));
    %sndDirList is list of all directories in snd dir
    sndDirList = dir(sndDirStr);   
    iters = size(sndDirList,1);
    parpool(12);
    parfor incr = 3:iters
    %for incr = 3:iters%skip first two - . and ..
        if(sndDirList(incr).isdir ~= 1) %if not a dir skip
            continue;
        end
        %add dummy ext to dir name
        %fileInfo = fileDataWithOutputStruct(strcat(sndDirList(incr).name,'.abc'), outputDir(dirIDX));
        fileInfo = fileDataWithOutputStruct(strcat(sndDirList(incr).name,'.abc'), outputVal);
        %via fileInfo can now get all individual snd.mat files and script
        %csv files for each video
        disp(strcat('incr',num2str(incr),'open:',fileInfo.readCapCSVFileName));
        fid = fopen(fileInfo.readCapCSVFileName);
        fgetl(fid);     %pass coltitle row of csv
        %tmpDat is a cell array
        %cols 1:  estimated frame start, 2: estimated frame end, 3: word, 
        %4: filename, 5:time/frame start->end string from caption vtt
        tmpDat = textscan(fid,'%d%d%s%s%s','delimiter',',');
        fclose(fid);
        %for this file, get vectors of estimated start frames, end frames and list of
        %words: 
        stFrameEsts = tmpDat{1};
        endFrameEsts = tmpDat{2};
        capWords = tmpDat{3};
    
        numWords = length(capWords);
        
        %get 2-column matrix of beginning/ending frame values of quiet
        %spots in audio - to be used for word bounds suggestions combined
        %with suggestions from caption file
        wordBounds = findBreaksInVideo(fileInfo, .5, 1.1, numWords);
        fileID = fopen(fileInfo.audioBndsCapCSVFileName,'w');
        fprintf(fileID,'startFrame,endFrame,\n');
        for i = 1:size(wordBounds,1)
            if (wordBounds(i,1) + wordBounds(i,2)) ~= 0
                fprintf(fileID,'%d,%d,\n',wordBounds(i,1),wordBounds(i,2));
            end
        end
        fclose(fileID);        
    end; 
    delete(gcp('nocreate'));
%end
  
   
format shortg;
c = clock
