clear;
%%%
%this file will preprocess the videos of obama to be images and audio data,
%sync'ed by filename & index, in directories based on filename
%base file name comes from iterating loop - will have ext, want to remove
%it
%% Process videos into images and sound samples
inVidFileDir = 'trainingVidsAndCaps\avi_vids_weekly-1\AVI\';
%inVidFileDir = 'trainingVidsAndCaps\avi_vids\AVI\';
vidList = dir(inVidFileDir);
iters = size(vidList,1);
delete(gcp('nocreate'));
parpool(12);
parfor incr = 1:iters
%for incr = 1:3
    if(vidList(incr).isdir == 1) 
        continue;
    end
    baseFileName = vidList(incr).name;
    procOneVid(baseFileName,inVidFileDir);
end;

