videoFReader = vision.VideoFileReader('001_xvid.avi');
videoPlayer = vision.VideoPlayer;

while ~isDone(videoFReader)
   frame = step(videoFReader);
   step(videoPlayer,frame);
end


release(videoFReader);
release(videoPlayer);
