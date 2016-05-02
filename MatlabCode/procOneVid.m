%%
%this function will convert and save one obama video into a series of images and
%audio, sync'ed by filename

function res = procOneVid(baseFileName,inVidFileDir)
    disp(strcat('Starting processing ',baseFileName));
    fileData = fileDataStruct(baseFileName,inVidFileDir);
    [status,message,messageid] = mkdir(fileData.writeImgDir);
    if(length(message) > 0)
        disp(strcat('Already processed ',baseFileName));
        return;
    end
    mkdir(fileData.writeSndDir);
    % Create a cascade detector object.
    %faceDetector = vision.CascadeObjectDetector();      %can detect mouths too
    % to be increased to make sure we only get 1 face (defaults to 4)
    %faceDetector.MergeThreshold = 10;

    %%
    %read video file obj
    videoFileReader = vision.VideoFileReader(fileData.readFileName, 'AudioOutputPort',true, 'AudioOutputDataType', fileData.audFileOutDataTyp);  
    %need the file reader to get the audio too.
    tmpVidObj = VideoReader(fileData.readFileName);
    numFramesInVid = tmpVidObj.NumberOfFrames;
    clearvars tmpVidObj;

    %Audio is each sample, for each channel (l and r)
    frame = 0;
    % move past empty frames - go to ~5 seconds into video
    while (frame < 160)
        [videoFrame, audioFrame]      = step(videoFileReader);
        frame = frame + 1;
    end;
    %frames - starts at current frame (no audio for skipped vid frames)
    numFramesToProc = numFramesInVid-frame-210; %ignore last 210 frames - ending title screen

    audioDataAra = zeros(size(audioFrame,1),numFramesToProc, fileData.audFileOutDataTyp);
    index = 1;
    %while ~isDone(videoFileReader)
    while index <= numFramesToProc
        prefix = '';
        if(index<1000)
            prefix = strcat(prefix,'0');
        end   
        if(index<100)
            prefix = strcat(prefix,'0');
        end   
        if(index<10)
            prefix = strcat(prefix,'0');
        end    

        
        % get the next frame
        [videoFrame, audioFrame]      = step(videoFileReader);

        writeFrame = videoFrame;%imcrop(videoFrame, bboxSavePoints);
        imwrite(writeFrame,strcat(fileData.writeImgNamePrefix,'_',strcat(prefix,num2str(index)),fileData.writeImgNameExt));

        audioDataAra(:,index) = audioFrame(:,1);  %only 1 channel needed for audio
        index = index + 1;
        %disp(index);
    end
    save(fileData.writeSndFileName,'audioDataAra');
    % Clean up
    release(videoFileReader);
    %release(pointTracker);
    disp(strcat('Finished processing ',baseFileName));
    res = 0;
end