%process audio for a single video - find breaks between words based on
%sound level, record word spans in frames
%audioData is a global and should be preloaded from calling function
%will return a matrix with 3 columns - frame of word break start, frame of
%word break end, and ratio of current frame to prev frame avg vol
function wordBounds = findBreaksInVideo(fileInfo, qThresh, lThresh, numWords)
    tmpDat = load(fileInfo.writeSndFileName, '-mat', 'audioDataAra');
    audioDataAra = tmpDat.audioDataAra;    
    clear tmpDat;   
    
%     qThresh = thresh;           %mult between samples to show end of word/ quieter
%     lThresh = 2.0;      %multiplier to change to show beginning of word/ louder
    
    numFrames = size(audioDataAra,2);  %# of columns is # of frames 
    sampleSize = size(audioDataAra,1);  %#rows is # of samples per frame
    rmsOfData = zeros(numFrames,1,'single');
    ratioRMSData = zeros(numFrames,1,'single');
    %set boundarys of words in frames in here - 2 columns - when goes
    %silent, then when goes loud again, last value is ratio of avg volume
    %between frame and prev frame
    speakState = zeros(numFrames,1);        %whether a word is being spoken or not in a particular frame
    
    %these will provide rough estimates of word boundaries based on audio.
    %combined with caption suggestions, we should be able to get reasonable
    %estimates of where the word boundaries are for training
    wordBounds = zeros(2*numWords,2);       %frame # of where a word starts, ends (col 1, 2)
    %wordEnds = zeros(2*numWords,1);         %frame # of where a word ends
    stWordIDX = 1;
    endWordIDX =  1;
    %doing first frame separate removes if check from loop
    %rmsOfData(1) = abs(sum(audioDataAra(:,1)));
    rmsOfData(1) = rms(audioDataAra(:,1));
    ratioRMSData(1) = 1;
    isInWord = 0;
    if(rmsOfData(1) > .01)
        isInWord = 1;       %may start in a word
        speakState(1) = isInWord;
        wordBounds(stWordIDX,1) = 1;      %1st word is started already in 
        stWordIDX = stWordIDX + 1;
    end
    for frame = 2:numFrames
        rmsOfData(frame) = rms(audioDataAra(:,frame));       %find abs val of avg of audio in frame.  a quiet frame should mark the boundary of a word
        %rmsOfData(frame) = abs(sum(audioDataAra(:,frame)));       %find abs val of avg of audio in frame.  a quiet frame should mark the boundary of a word
        ratioRMSData(frame) = rmsOfData(frame)/rmsOfData(frame-1); 
        %if (rmsOfData(frame) < qThresh*rmsOfData(frame-1) && isInWord==1)  %below quiet threshold 
        if (ratioRMSData(frame) < qThresh && isInWord==1)  %below quiet threshold 
            if isInWord==1
                wordBounds(endWordIDX,2) = frame;
                endWordIDX = endWordIDX + 1;
            end
            isInWord = 0;            
        %elseif (rmsOfData(frame) > lThresh*rmsOfData(frame-1) && isInWord==0)    %above loud threshold 
        elseif (ratioRMSData(frame) > lThresh && isInWord==0)    %above loud threshold 
            if isInWord==0                    %if wasn't in a word before
                wordBounds(stWordIDX,1) = frame;
                stWordIDX = stWordIDX + 1;
            end
            isInWord = 1;
        end
        speakState(frame) = isInWord;
    end
    
    disp(strcat('done with ',{' '},fileInfo.baseFileName,'.mat'));
%     
%     tmpAra = audioDataAra(:);
%     frameSt = 1; frameEnd = 100;
%     x = (frameSt:frameEnd);%in frames
%     x2 = ((sampleSize*(frameSt-1)+1):(sampleSize*frameEnd));   %per sample
% %play span of audio
%     player = audioplayer(tmpAra,44100);
%     play(player, [(sampleSize*(frameSt-1)+1),(sampleSize*frameEnd)]);
%     %stop
%     stop(player);
%     % plot(x,tmpAra(x));
%     % plot(x2*sampleSize,avgData(x2));
%     %plot(x2,tmpAra(x2),x*sampleSize,avgAbsData(x));speakState
%     %plot(x2,tmpAra(x2),x*sampleSize,ratioAbsData(x),x*sampleSize,avgAbsData(x));
%     %plot(x2,tmpAra(x2),x*sampleSize,rmsOfData(x),x*sampleSize,ratioRMSData(x));%,x*sampleSize,10*speakState(x));
%     plot(x,rmsOfData(x),x,ratioRMSData(x),x,10*speakState(x));
end


function plotAudio(frameSt, frameEnd, sampleSize, tmpAra, avgData)
    x = (frameSt:frameEnd);%in frames
    x2 = ((sampleSize*(frameSt-1)+1):(sampleSize*frameEnd));   %per sample

    plot(x2,tmpAra(x2),x*sampleSize,avgAbsData(x));
end
