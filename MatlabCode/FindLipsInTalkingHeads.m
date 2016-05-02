clear;

%% Global Vars
% Create a cascade detector object.
faceDetector = vision.CascadeObjectDetector();      %can detect mouths too
% to be increased to make sure we only get 1 face (defaults to 4)
faceDetector.MergeThreshold = 10;
inVidFileDir = 'trainingVidsAndCaps\avi_vids\AVI\';

fileData = fileDataStruct('001_xvid.avi',inVidFileDir);
% Read a video frame and run the face detector.
readFileName = '001_xvid.avi';
writeFileName = strcat('cropped_',readFileName);
%loop around this call
%procOneVid(readFileName, writeFileName, faceDetector); 
%%%comment out below when actually working and using loop

%%
%read video file obj
videoFileReader = vision.VideoFileReader(readFileName, 'AudioOutputPort',true, 'AudioOutputDataType', 'uint8');  
%write video file obj
videoFileWriter = vision.VideoFileWriter(writeFileName,'AudioInputPort',true,'FrameRate',videoFileReader.info.VideoFrameRate);
videoFileWriter.VideoCompressor='MJPEG Compressor';

encInfo = getEncInfo();

%get # of frames in video - easiest to just use Video reader for this -
%need the file reader to get the audio too.
tmpVidObj = VideoReader(readFileName);
numFramesInVid = tmpVidObj.NumberOfFrames;
clearvars tmpVidObj;

%Audio is each sample, for each channel (l and r)
frame = 0;
% move past empty frames - go to ~5 seconds into video

while (frame < 160)
    [videoFrame, audioFrame]      = step(videoFileReader);
    bbox = step(faceDetector, videoFrame);
    frame = frame + 1;
end;
%frames - starts at current frame (no audio for skipped vid frames)
numFramesToProc = numFramesInVid-frame;

bbox = step(faceDetector, videoFrame);
% Draw the returned bounding box around the detected face.
videoFrame = insertShape(videoFrame, 'Rectangle', bbox);

% Convert the first box into a list of 4 points
% This is needed to be able to visualize the rotation of the object.
bboxPoints = bbox2points(bbox(1, :));
%find most here in blue channel in eigen features, which is darker than red or green
points = detectMinEigenFeatures(videoFrame(:,:,3), 'ROI', bbox);

% Create a point tracker and enable the bidirectional error constraint to
% make it more robust in the presence of noise and clutter.
pointTracker = vision.PointTracker('MaxBidirectionalError', 12);

% Initialize the tracker with the initial point locations and the initial
% video frame.
points = points.Location;
initialize(pointTracker, points, videoFrame);

%% Initialize a Video Player to Display the Results
% Create a video player object for displaying video frames.
% videoPlayer  = vision.VideoPlayer('Position',...
%     [100 100 [size(videoFrame, 2)+100, size(videoFrame, 1)]+50]);

% Make a copy of the points to be used for computing the geometric
% transformation between the points in the previous and the current frames
oldPoints = points;
numOldPoints = size(points,1);

%save frame around crop box of specific
bboxSavePoints = bbox;
offsetX = 120;
offsetY = 120;
bboxSavePoints(:, 1) = max(bboxSavePoints(:, 1) - offsetX,0);
bboxSavePoints(:, 2) = max(bboxSavePoints(:, 2) - offsetY,0);
bboxSavePoints(:, 3) = min(bboxSavePoints(:, 3) + 2*offsetX,size(videoFrame, 2)-bboxSavePoints(:, 1));
bboxSavePoints(:, 4) = min(bboxSavePoints(:, 4) + 2*offsetY,size(videoFrame, 1)-bboxSavePoints(:, 2));

%videoFileWriter.VideoCompressor='DV Video Encoder';    %<-crappy, forces size to be wrong
%set up structure to hold audio data #rows->#samples per frame, #cols ->num
tmpSmple = createNewAudioDSFromRaw(audioFrame(:,1), 1, readFileName);
%make ara of structs
%audioDSAra(numFramesToProc) = createNewAudioDSFromRaw(audioFrame(:,1), 1, readFileName);
audioDataAra = zeros(size(audioFrame,1),numFramesToProc, 'uint8');
index = 1;
while ~isDone(videoFileReader)
    % get the next frame
    [videoFrame, audioFrame]      = step(videoFileReader);
    %audioDSAra(index) = createNewAudioDSFromRaw(audioFrame(:,1), index,readFileName);  %only 1 channel needed for audio   
    % Track the points. Note that some points may be lost.
    [points, isFound] = step(pointTracker, videoFrame);
    
    visiblePoints = points(isFound, :);
    oldInliers = oldPoints(isFound, :);
    numNewPoints = size(visiblePoints,1);
    if numNewPoints >= 2 % need at least 2 points        
        % Estimate the geometric transformation between the old points
        % and the new points and eliminate outliers
        [xform, oldInliers, visiblePoints] = estimateGeometricTransform(...
            oldInliers, visiblePoints, 'similarity', 'MaxDistance', 12);
        
        % Apply the transformation to the bounding box points
        bboxPoints = transformPointsForward(xform, bboxPoints);
        % Insert a bounding box around the object being tracked
        bboxPolygon = reshape(bboxPoints', 1, []);
%         videoFrame = insertShape(videoFrame, 'Polygon', bboxPolygon, ...
%             'LineWidth', 2);
%                 
%         % Display tracked points
%         videoFramePts = insertMarker(videoFrame, visiblePoints, '+', ...
%             'Color', 'white');
        %find more points if we lost too many of the old ones
        if(numNewPoints < .75*numOldPoints)
            %update bboxs - find points in each quadrant
            newPoints = reacquirePoints(videoFrame(:,:,3),bboxPoints);
            oldPoints = unique(vertcat(visiblePoints, newPoints), 'rows');
        else
            oldPoints = visiblePoints;
        end
        setPoints(pointTracker, oldPoints);              
    end
    
    writeFrame = imresize(imcrop(videoFrame, bboxSavePoints),.5);
    %save frame without points
    %step(videoFileWriter, videoFrame, audioFrame);
    step(videoFileWriter, writeFrame, audioFrame);
    % Display the annotated video frame using the video player object
%     step(videoPlayer, writeFrame);
    audioDataAra(:,index) = audioFrame(:,1);  %only 1 channel needed for audio
    index = index + 1;
    disp(index);
end

% Clean up
release(videoFileReader);
release(videoFileWriter);
%release(videoPlayer);
release(pointTracker);

