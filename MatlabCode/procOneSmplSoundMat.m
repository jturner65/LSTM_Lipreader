%%
%this function will find the # of samples for each sound matrix

function strRes = procOneSmplSoundMat(baseFileName,fullFileName)
    %disp(strcat('Starting Sample Mat -> SOM txt processing on : ',fullFileName));
    
    %load file in as audioDataAra
    load(fullFileName, '-mat', 'audioDataAra');
    tmpAra = audioDataAra';
    %using transpose of audioDataAra to build txt = want rows as cols, cols
    %as training examples
    [resRows, resCols] = size(tmpAra);
    sampleRate = 44100/resCols;
    strRes = strcat(num2str(sampleRate,'%10.5f') ,',',num2str(resRows),',',num2str(resCols));
    disp(strcat('Sound mat in ',baseFileName, ' is sample Rate : ',{' '},num2str(sampleRate,'%10.5f') ,{' '},' with ',num2str(resRows),{' '}, ' samples, including blank samples, and each sample is ',num2str(resCols),{' '},'worth of samples'));
    %disp(strcat('Finished processing ',fullFileName,'\n'));  
end
