%process audio for a single video - find breaks between words based on
%sound level, record word spans in frames
a = load('snd/out_1000_xvid.mat');
ftoread = 'wordScript_1000_xvid.csv';

audioDataAra = a.audioDataAra;
numFrames = size(audioDataAra,2);
sampleSize = size(audioDataAra,1);
%player = audioplayer(audioDataAra(:),44100);

fid = fopen(ftoread);
a = fgetl(fid);
n = 0;
tline = fgetl(fid);

while ischar(tline)
  
    c = strsplit(tline, ',');
    
    n = n+1;
    s = str2num(char(c(1)));
    e = str2num(char(c(2)))+2;
    sampleSt = s * sampleSize + 1; %row count is # samples per frame
    sampleEnd = e * sampleSize; %row count is # samples per frame
    disp(strcat(num2str(s), ', ', num2str(e)));
    disp(c(3)); 
    player = audioplayer(audioDataAra(:),44100); 
    playblocking(player, [sampleSt, sampleEnd]);
%     while( strcmp(player.running,'on') )    
%       % Waiting for sound to finish
%     end
   
    pause(0.5);
    stop(player);
    tline = fgetl(fid);

end
%M = textscan(fid, '%f', 'Delimiter','\,'); % you will need to change the number   of values to match your file %f for numbers and %s for strings.
fclose (fid)
 
disp(n)
%stop
%stop(player);

