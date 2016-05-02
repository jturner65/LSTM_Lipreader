fmtList = VideoReader.getFileFormats();

if any(ismember({fmtList.Extension},'mp4'))
     disp('VideoReader can read mp4 files on this system.');
else
     disp('VideoReader cannot read mp4 files on this system.');
end

%%%%
%look at audio data

plot(timeVec,audioVec)
xlabel('Time')
ylabel('Audio Signal')
