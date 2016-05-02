
%load audio file here



%process audio for a single video - find breaks between words based on
%sound level, record word spans in frames
numFrames = size(audioDataAra,2);
sampleSize = size(audioDataAra,1);
% avgAbsData = zeros(numFrames,1,'single');
% for i = 1:numFrames
%     avgData(i) = abs(sum(audioDataAra(:,i)));
% end
%make player
player = audioplayer(audioDataAra(:),44100);
%play from beginning
%play(player);
%play from frame # 446 to 462 - plays back in frames 426 - 442
sampleSt = 426 * sampleSize; %row count is # samples per frame
sampleEnd = 442 * sampleSize; %row count is # samples per frame

%play ((frame - 1) * sampleSize) - 1
%play from frame # 1142 to 1158 - plays back 1142 - 1150
sampleSt = 0 * sampleSize + 1; %row count is # samples per frame
sampleEnd = 1158 * sampleSize; %row count is # samples per frame


play(player, [sampleSt, sampleEnd]);
%stop
stop(player);
tmpAra = audioDataAra(:);
x = (sampleSt:sampleEnd);
x2 = (1142:1158);
% plot(x,tmpAra(x));
% plot(x2*sampleSize,avgData(x2));
plot(x,tmpAra(x),x2*sampleSize,avgData(x2));

