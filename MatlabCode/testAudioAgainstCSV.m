clear;
%%%
%this file will test all audio files for sample rate

baseDir =  'D:\LipReaderProject\listeningeye\MatlabCode\FaceDetectCrop\';
soundDir = {'output\snd\','output_2\snd\'};
outSampleRateFile = strcat(baseDir,'allVidFrameRate.csv');
fileID = fopen(outSampleRateFile,'w');
for dirIDX = 1:2 
    dirStr = char(strcat(baseDir,soundDir(dirIDX)));
    sndDirList = dir(dirStr);
    disp(sndDirList);
    iters = size(sndDirList,1);
%     parpool(12);
%     parfor incr = 1:iters
    for incr = 3:iters
        if(sndDirList(incr).isdir ~= 1) 
            continue;
        end
        sndMatFileName = strcat('out_',sndDirList(incr).name,'.mat');
        sndMatFullFileName = strcat(dirStr,sndDirList(incr).name,'\',sndMatFileName);
        strRes = procOneSmplSoundMat(sndMatFileName,sndMatFullFileName);
        fprintf(fileID,'%s,%s,%s,\n',sndMatFullFileName,sndMatFileName,strRes);
    end;   
    
end;
% fprintf(fileID,strcat('c1765\n'));
fclose(fileID);

